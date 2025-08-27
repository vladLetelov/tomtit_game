import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';
import 'package:tomtit_game/overlays/time_overlay.dart';
import 'package:tomtit_game/overlays/pause_button_overlay.dart';
import 'package:tomtit_game/overlays/victory_slideshow.dart';
import 'package:tomtit_game/overlays/tutorial_completed_overlay.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/enums/level_step.dart';
import 'package:tomtit_game/components/cards/history_card.dart';
import 'package:tomtit_game/models/history_model.dart';
import 'dart:async';

class LevelHistoryesScreen extends StatefulWidget {
  const LevelHistoryesScreen({
    super.key,
    required this.level,
  });

  final LevelModel level;

  @override
  State<LevelHistoryesScreen> createState() => _LevelHistoryesScreenState();
}

class _LevelHistoryesScreenState extends State<LevelHistoryesScreen> {
  late LevelModel currlevel;
  late PageController _pageController;
  int _currentHistoryIndex = 0;
  bool? _lastAnswerCorrect;
  bool _alreadyAnswered = false;
  String? _currentCountdownImage;
  bool _showCountdown = false;
  final Map<String, bool> _questionResults = {};
  final Map<int, bool> _questionAnswers = {};
  List<HistoryModel> _displayHistory = [];

  // Функция для создания игры с правильными колбэками
  TomtitGame _createGameWithCallbacks(LevelModel level, BuildContext context) {
    return TomtitGame(
      levelModel: level,
      onRestart: () {
        // Перезапуск игры
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GameWidget<TomtitGame>.controlled(
              gameFactory: () => _createGameWithCallbacks(level, context),
              overlayBuilderMap: {
                'PauseButton': (context, TomtitGame game) =>
                    PauseButtonOverlay(game),
                'GameOver': (_, game) => GameOver(game: game),
                'ScoreOverlay': (_, game) => ScoreOverlay(
                      game: game,
                      level: level,
                    ),
                'TimeOverlay': (_, game) => TimeOverlay(game: game),
                'VictorySlideshow': (_, game) => VictorySlideshow(game: game),
                'TutorialCompleted': (_, game) =>
                    TutorialCompletedOverlay(game: game),
              },
            ),
          ),
        );
      },
      onReturnToMenu: () {
        // Возврат в главное меню
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LevelSelectionScreen()),
          (route) => false,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    currlevel = widget.level;
    _pageController = PageController();
    _displayHistory = List.from(widget.level.history);
    _loadQuestionResults();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentHistoryIndex = index;
    });
  }

  void _loadQuestionResults() async {
    for (var i = 0; i < _displayHistory.length; i++) {
      final item = _displayHistory[i];
      if (item.questions != null && item.questions!.isNotEmpty) {
        for (var q = 0; q < item.questions!.length; q++) {
          final questionId = item.questions![q].id;
          final result = GameScoreManager.getQuestionResultById(
            widget.level.levelNumber,
            questionId,
          );
          if (result != null) {
            _questionResults[questionId] = result;
          }
        }
      }
    }
  }

  void _onQuestionAnswered(bool isCorrect, String questionId) {
    if (_alreadyAnswered) return;

    setState(() {
      _alreadyAnswered = true;
      _lastAnswerCorrect = isCorrect;
      _questionResults[questionId] = isCorrect;

      // Находим соответствующий вопрос
      final currentHistoryItem = _displayHistory[_currentHistoryIndex];
      Question? question;

      try {
        question = currentHistoryItem.questions?.firstWhere(
          (q) => q.id == questionId,
        );
      } catch (e) {
        question = null;
      }

      HistoryModel? resultCard;

      if (question != null) {
        // Используем карточку из вопроса, если она есть
        resultCard = isCorrect ? question.correctCard : question.incorrectCard;
      }
      if (resultCard != null) {
        // Проверяем, нет ли уже такой карточки для этого вопроса
        bool hasResultCard = false;
        for (var i = _currentHistoryIndex + 1;
            i < _displayHistory.length;
            i++) {
          if (_displayHistory[i].isResultCard &&
              _displayHistory[i].relatedQuestionId == questionId) {
            hasResultCard = true;
            break;
          }
        }

        if (!hasResultCard) {
          // Вставляем карточку результата в displayHistory
          _displayHistory.insert(
            _currentHistoryIndex + 1,
            HistoryModel(
              title: resultCard.title,
              description: resultCard.description,
              isResultCard: true,
              isCorrect: resultCard.isCorrect,
              relatedQuestionId: questionId,
            ),
          );

          // После вставки карточки, обновляем текущий индекс
          // чтобы он указывал на вставленную карточку
          _currentHistoryIndex = _currentHistoryIndex + 1;
        }
      }
    });
  }

  void _showHistoryCompletionDialog() async {
    // Для обучения особая логика
    if (widget.level.levelNumber == 0) {
      // Просто переходим к игре обучения
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameWidget<TomtitGame>.controlled(
            gameFactory: () => _createGameWithCallbacks(widget.level, context),
            overlayBuilderMap: {
              'PauseButton': (context, TomtitGame game) =>
                  PauseButtonOverlay(game),
              'GameOver': (_, game) => GameOver(game: game),
              'ScoreOverlay': (_, game) =>
                  ScoreOverlay(game: game, level: widget.level),
              'TimeOverlay': (_, game) => TimeOverlay(game: game),
              'VictorySlideshow': (_, game) => VictorySlideshow(game: game),
              'TutorialCompleted': (_, game) =>
                  TutorialCompletedOverlay(game: game),
            },
          ),
        ),
      );
      return;
    }

    // Отмечаем, что история текущего уровня пройдена
    await GameScoreManager.setLevelHistoryCompleted(widget.level.levelNumber);

    // Сохраняем, что переходим к игре этого же уровня
    await GameScoreManager.saveLastLevelStep(LevelStep.game);

    // Разблокировать следующий уровень (если текущий < максимум)
    if (widget.level.levelNumber == 1) {
      await GameScoreManager.setLevelRequirementsMet(1);
    } else {
      final prevLevelScore =
          GameScoreManager.getLevelScore(widget.level.levelNumber - 1);
      final prevLevelRequiredScore =
          levels[widget.level.levelNumber - 1]!.scoreForNextLevel;

      if (prevLevelScore >= prevLevelRequiredScore) {
        await GameScoreManager.setLevelRequirementsMet(
            widget.level.levelNumber);
      }
    }

    // Для 1 уровня показываем обратный отсчет с картинками
    if (widget.level.levelNumber == 1) {
      await GameScoreManager.setLevelGameUnlocked(1);
      setState(() {
        _showCountdown = true;
        _currentCountdownImage = 'assets/images/Timer/3.png';
      });

      final countdownImages = [
        'assets/images/Timer/3.png',
        'assets/images/Timer/2.png',
        'assets/images/Timer/1.png',
      ];

      int currentIndex = 0;

      Timer.periodic(const Duration(seconds: 1), (timer) {
        currentIndex++;

        if (currentIndex < countdownImages.length) {
          setState(() {
            _currentCountdownImage = countdownImages[currentIndex];
          });
        } else {
          timer.cancel();
          GameScoreManager.setLastPlayedLevel(widget.level.levelNumber);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameWidget<TomtitGame>.controlled(
                gameFactory: () =>
                    _createGameWithCallbacks(widget.level, context),
                overlayBuilderMap: {
                  'PauseButton': (context, TomtitGame game) =>
                      PauseButtonOverlay(game),
                  'GameOver': (_, game) => GameOver(game: game),
                  'ScoreOverlay': (_, game) => ScoreOverlay(
                        game: game,
                        level: currlevel,
                      ),
                  'TimeOverlay': (_, game) => TimeOverlay(game: game),
                  'VictorySlideshow': (_, game) => VictorySlideshow(game: game),
                  'TutorialCompleted': (_, game) =>
                      TutorialCompletedOverlay(game: game),
                },
              ),
            ),
          );
        }
      });
    } else {
      // Разблокируем игру текущего уровня
      await GameScoreManager.setLevelGameUnlocked(widget.level.levelNumber);

      showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                constraints: const BoxConstraints(maxHeight: 500),
                decoration: BoxDecoration(
                  color: deepDarkPurple.withOpacity(0.9),
                  border: Border.all(width: 2, color: Colors.deepPurple),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'История изучена!',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Вы ознакомились с историей!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Переход к игре этого же уровня
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GameWidget<TomtitGame>.controlled(
                              gameFactory: () => _createGameWithCallbacks(
                                  widget.level, context),
                              overlayBuilderMap: {
                                'PauseButton': (context, TomtitGame game) =>
                                    PauseButtonOverlay(game),
                                'GameOver': (_, game) => GameOver(game: game),
                                'ScoreOverlay': (_, game) => ScoreOverlay(
                                      game: game,
                                      level: widget.level,
                                    ),
                                'TimeOverlay': (_, game) =>
                                    TimeOverlay(game: game),
                                'VictorySlideshow': (_, game) =>
                                    VictorySlideshow(game: game),
                                'TutorialCompleted': (_, game) =>
                                    TutorialCompletedOverlay(game: game),
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(200, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Начать игру',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        GameScoreManager.setLastPlayedLevel(
                            widget.level.levelNumber);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LevelSelectionScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        minimumSize: const Size(150, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.deepPurple),
                        ),
                      ),
                      child: const Text(
                        'В меню',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: deepDarkPurple,
        title: Text(
            'Фрагмент ${_currentHistoryIndex + 1}/${widget.level.history.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined, color: Colors.white),
            onPressed: () {
              // Сохраняем текущий уровень перед выходом
              GameScoreManager.setLastPlayedLevel(widget.level.levelNumber);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LevelSelectionScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackgroundHistoryPage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: _showCountdown
                      ? const SizedBox.shrink()
                      : PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            if (index < _displayHistory.length) {
                              _onPageChanged(index);
                            } else {
                              _pageController
                                  .jumpToPage(_displayHistory.length - 1);
                            }
                          },
                          itemCount: _displayHistory
                              .length, // Используем displayHistory
                          itemBuilder: (context, index) {
                            final historyItem = _displayHistory[index];

                            if (historyItem.isResultCard) {
                              final relatedQuestionId =
                                  historyItem.relatedQuestionId;
                              if (relatedQuestionId != null &&
                                  _questionResults
                                      .containsKey(relatedQuestionId)) {
                                final isCorrect =
                                    _questionResults[relatedQuestionId];
                                if (historyItem.isCorrect != isCorrect) {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            }

                            return HistoryCard(
                              historyItem: historyItem,
                              isActive: index == _currentHistoryIndex,
                              backgroundImage:
                                  'assets/images/BackgroundHistoryCard.png',
                              planetImage: 'assets/images/Planets.png',
                              currentIndex: _currentHistoryIndex,
                              totalCount: _displayHistory
                                  .length, // Используем displayHistory
                              onQuestionAnswered: (isCorrect, questionId) =>
                                  _onQuestionAnswered(isCorrect, questionId),
                              pageController: _pageController,
                              levelNumber: widget.level.levelNumber,
                            );
                          },
                        ),
                ),
                if (_currentHistoryIndex == _displayHistory.length - 1 &&
                    !_showCountdown)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: _showHistoryCompletionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                      ),
                      child: const Text(
                        'Летим дальше!',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 55, 25, 69),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_showCountdown && _currentCountdownImage != null)
            Center(
              child: Image.asset(
                _currentCountdownImage!,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
        ],
      ),
    );
  }
}
