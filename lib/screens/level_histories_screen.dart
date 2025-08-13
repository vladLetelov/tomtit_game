import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';
import 'package:tomtit_game/overlays/time_overlay.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
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
  late PageController _pageController;
  int _currentHistoryIndex = 0;
  bool? _lastAnswerCorrect;
  bool _alreadyAnswered = false;
  String? _currentCountdownImage;
  bool _showCountdown = false;
  final Map<int, bool> _questionResults = {}; // Храним результаты вопросов
  final Map<int, bool> _questionAnswers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    for (var i = 0; i < widget.level.history.length; i++) {
      final item = widget.level.history[i];
      if (item.questions != null && item.questions!.isNotEmpty) {
        for (var q = 0; q < item.questions!.length; q++) {
          final questionId = item.questions![q].id;
          final result = GameScoreManager.getQuestionResultById(
            widget.level.levelNumber,
            questionId,
          );
          if (result != null) {
            _questionResults[i] = result; // Используем индекс истории, а не вопроса
          }
        }
      }
    }
  }

  void _onQuestionAnswered(bool isCorrect) {
    if (_alreadyAnswered) return;

    setState(() {
      _alreadyAnswered = true;
      _lastAnswerCorrect = isCorrect;
      _questionResults[_currentHistoryIndex] = isCorrect; // Сохраняем результат

      final resultCard =
          isCorrect ? widget.level.correctCard : widget.level.incorrectCard;

      if (resultCard != null) {
        // Проверяем, нет ли уже такой карточки
        bool hasResultCard = false;
        for (var i = _currentHistoryIndex + 1;
            i < widget.level.history.length;
            i++) {
          if (widget.level.history[i].isResultCard) {
            hasResultCard = true;
            break;
          }
        }

        if (!hasResultCard) {
          widget.level.history.insert(
            _currentHistoryIndex + 1,
            HistoryModel(
              title: resultCard.title,
              description: resultCard.description,
              isResultCard: true,
              isCorrect: resultCard.isCorrect,
            ),
          );
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_pageController.hasClients &&
          _currentHistoryIndex < widget.level.history.length - 1) {
        _pageController.jumpToPage(_currentHistoryIndex + 1);
      }
    });
  }

  void _showHistoryCompletionDialog() async {
    // Отмечаем, что история текущего уровня пройдена
    await GameScoreManager.setLevelHistoryCompleted(widget.level.levelNumber);

    // Разблокировать следующий уровень (если текущий < максимум)
    if (widget.level.levelNumber == 1) {
      await GameScoreManager.setLevelRequirementsMet(1);
    } else {
      // Проверяем, пройдена ли игра предыдущего уровня
      final prevLevelScore =
          await GameScoreManager.getLevelScore(widget.level.levelNumber - 1);
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
        _currentCountdownImage = '/images/Timer/3.png';
      });

      // Создаем список изображений в порядке отсчета
      final countdownImages = [
        '/images/Timer/3.png',
        '/images/Timer/2.png',
        '/images/Timer/1.png',
      ];

      int currentIndex = 0;

      // Запускаем таймер
      Timer.periodic(const Duration(seconds: 1), (timer) {
        currentIndex++;

        if (currentIndex < countdownImages.length) {
          setState(() {
            _currentCountdownImage = countdownImages[currentIndex];
          });
        } else {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameWidget<TomtitGame>.controlled(
                gameFactory: () => TomtitGame(levelModel: widget.level),
                overlayBuilderMap: {
                  'GameOver': (_, game) => GameOver(game: game),
                  'ScoreOverlay': (_, game) => ScoreOverlay(game: game),
                  'TimeOverlay': (_, game) => TimeOverlay(game: game),
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
                constraints: const BoxConstraints(
                  maxHeight: 500,
                ),
                decoration: BoxDecoration(
                  color: deepDarkPurple.withOpacity(0.9),
                  border: Border.all(
                    width: 2,
                    color: Colors.deepPurple,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'История изучена!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Вы ознакомились со всеми фрагментами истории!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LevelSelectionScreen(),
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (levels.containsKey(widget.level.levelNumber + 1))
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameWidget<TomtitGame>.controlled(
                                    gameFactory: () => TomtitGame(
                                        levelModel: levels[widget.level.levelNumber + 1]!),
                                    overlayBuilderMap: {
                                      'GameOver': (_, game) =>
                                          GameOver(game: game),
                                      'ScoreOverlay': (_, game) =>
                                          ScoreOverlay(game: game),
                                      'TimeOverlay': (_, game) =>
                                          TimeOverlay(game: game),
                                    },
                                  ),
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
                              'Следующий уровень',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
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
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LevelSelectionScreen()),
            ),
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
                            // Запрещаем переход на страницы за пределами списка
                            if (index < widget.level.history.length) {
                              _onPageChanged(index);
                            } else {
                              // Если пытаемся перейти дальше - возвращаем на последнюю страницу
                              _pageController
                                  .jumpToPage(widget.level.history.length - 1);
                            }
                          },
                          itemCount: widget.level.history.length,
                          itemBuilder: (context, index) {
                            final historyItem = widget.level.history[index];

                            if (historyItem.isResultCard) {
                              final questionIndex = index - 1;
                              if (_questionResults.containsKey(questionIndex)) {
                                final isCorrect =
                                    _questionResults[questionIndex];
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
                              totalCount: widget.level.history.length,
                              onQuestionAnswered: _onQuestionAnswered,
                              pageController: _pageController,
                              levelNumber: widget
                                  .level.levelNumber, // Добавляем номер уровня
                            );
                          },
                        ),
                ),
                if (_currentHistoryIndex == widget.level.history.length - 1 &&
                    !_showCountdown)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: _showHistoryCompletionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: const Text(
                        'Завершить просмотр',
                        style: TextStyle(fontSize: 18, color: Colors.black),
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
