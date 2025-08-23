import 'package:flutter/material.dart';
import 'package:tomtit_game/components/game_buttons/default_game_button.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/enums/level_step.dart';
import 'package:tomtit_game/levels.dart';
import 'package:tomtit_game/screens/level_histories_screen.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key, required this.game});

  final TomtitGame game;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  late bool isLevelPassed;
  late String scoreUnit;

  @override
  void initState() {
    super.initState();

    isLevelPassed = widget.game.scoreNotifier.value >=
        widget.game.levelModel.scoreForNextLevel;

    scoreUnit = _getScoreUnit(widget.game.levelModel.levelNumber);

    if (isLevelPassed) {
      _handleLevelCompletion();
    }
  }

  String _getScoreUnit(int levelNumber) {
    if (levelNumber == 4) {
      return 'птичек';
    } else {
      return 'нициков';
    }
  }

  void _handleLevelCompletion() async {
    final levelNumber = widget.game.levelModel.levelNumber;

    await GameScoreManager.setLevelCompleted(levelNumber);
    await GameScoreManager.saveLastLevel(levelNumber);

    final previousScore = GameScoreManager.getLevelScore(levelNumber);
    if (widget.game.scoreNotifier.value > previousScore) {
      await GameScoreManager.setLevelScore(
          levelNumber, widget.game.scoreNotifier.value);
    }

    // Сохраняем, что переходим к истории следующего уровня
    await GameScoreManager.saveLastLevelStep(LevelStep.history);

    // Разблокируем историю следующего уровня
    if (levelNumber < levels.length) {
      await GameScoreManager.setLevelHistoryAvailable(levelNumber + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 500,
          decoration: BoxDecoration(
            color: deepDarkPurple.withOpacity(0.7),
            border: Border.all(
              width: 2,
              color: Colors.deepPurple,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Игра окончена',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                style: TextStyles.defaultStyle,
                isLevelPassed
                    ? "Вы прошли уровень набрав ${widget.game.scoreNotifier.value} $scoreUnit!"
                    : "Не повезло, вы набрали ${widget.game.scoreNotifier.value} $scoreUnit из ${widget.game.levelModel.scoreForNextLevel}",
              ),
              const SizedBox(height: 20),
              isLevelPassed
                  ? Column(
                      children: [
                        DefaultGameButton(
                          onTap: () {
                            widget.game.removeWhere((component) => true);
                            // Переход к истории СЛЕДУЮЩЕГО уровня
                            final nextLevelNumber =
                                widget.game.levelModel.levelNumber + 1;
                            if (nextLevelNumber <= levels.length) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevelHistoryesScreen(
                                    level: levels[nextLevelNumber]!,
                                  ),
                                ),
                              );
                            } else {
                              // Если это последний уровень - в меню
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LevelSelectionScreen(),
                                ),
                              );
                            }
                          },
                          text: "Перейти к следующей истории",
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            DefaultGameButton(
                              onTap: () {
                                widget.game.removeWhere((component) => true);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LevelSelectionScreen(),
                                  ),
                                );
                              },
                              text: 'Выход в меню',
                            ),
                            DefaultGameButton(
                              onTap: () {
                                widget.game.removeWhere((component) => true);
                                widget.game.restartGame();
                                widget.game.overlays.remove('GameOver');
                              },
                              text: "Играть заново",
                            ),
                          ],
                        ),
                      ],
                    )
                  : Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        DefaultGameButton(
                          onTap: () {
                            widget.game.removeWhere((component) => true);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const LevelSelectionScreen(),
                              ),
                            );
                          },
                          text: 'Выход в меню',
                        ),
                        DefaultGameButton(
                          onTap: () {
                            widget.game.removeWhere((component) => true);
                            widget.game.restartGame();
                            widget.game.overlays.remove('GameOver');
                          },
                          text: "Попробовать снова",
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
