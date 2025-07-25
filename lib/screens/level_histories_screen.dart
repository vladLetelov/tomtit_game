import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/enums/level_step.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/components/cards/history_card.dart';
import 'package:tomtit_game/models/history_model.dart';

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
  late int lastLevel;
  late LevelStep step;
  bool? _lastAnswerCorrect;
  bool _alreadyAnswered = false;

  @override
  void initState() {
    _pageController = PageController();
    GameScoreManager.getLastLevel().then((val) {
      lastLevel = val;
    });
    GameScoreManager.getLastLevelStep().then((val) {
      step = val;
    });
    super.initState();
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

  void _onQuestionAnswered(bool isCorrect) {
    if (_alreadyAnswered) return; // Если уже отвечали - выходим

    setState(() {
      _alreadyAnswered = true; // Помечаем что ответили
      _lastAnswerCorrect = isCorrect;

      final resultCard =
          isCorrect ? widget.level.correctCard : widget.level.incorrectCard;

      if (resultCard != null) {
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
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_pageController.hasClients &&
          _currentHistoryIndex < widget.level.history.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showHistoryCompletionDialog() {
    if (lastLevel == widget.level.levelNumber && lastLevel != 7) {
      // HERE 7 IS COUNT OF LEVELS
      GameScoreManager.saveLastLevelStep(LevelStep.level);
      GameScoreManager.saveLastLevel(lastLevel + 1);
    }
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameWidget<TomtitGame>.controlled(
                                gameFactory: () => TomtitGame(
                                    levelModel: levels[lastLevel + 1]!),
                                overlayBuilderMap: {
                                  'GameOver': (_, game) => GameOver(game: game),
                                  'ScoreOverlay': (_, game) =>
                                      ScoreOverlay(game: game),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BackgroundHistoryPage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.level.history.length,
                itemBuilder: (context, index) {
                  final historyItem = widget.level.history[index];

                  // Пропускаем только если это карточка результата НЕ для текущего ответа
                  if (historyItem.isResultCard &&
                      historyItem.isCorrect != _lastAnswerCorrect) {
                    return Container();
                  }

                  return HistoryCard(
                    historyItem: historyItem,
                    isActive: index == _currentHistoryIndex,
                    backgroundImage: 'assets/images/BackgroundHistoryCard.png',
                    planetImage: 'assets/images/Planets.png',
                    currentIndex: _currentHistoryIndex,
                    totalCount: widget.level.history.length,
                    onQuestionAnswered: _onQuestionAnswered,
                    pageController: _pageController,
                  );
                },
              ),
            ),
            if (_currentHistoryIndex == widget.level.history.length - 1)
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
    );
  }
}
