import 'package:flutter/material.dart';
import 'package:tomtit_game/components/game_buttons/default_game_button.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';
import 'package:tomtit_game/storage/game_score.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key, required this.game});

  final TomtitGame game;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  late bool isLevelPassed;

  @override
  void initState() {
    super.initState();

    isLevelPassed = widget.game.scoreNotifier.value >=
        widget.game.levelModel.scoreForNextLevel;

    if (isLevelPassed) {
      _handleLevelCompletion();
    }
  }

  void _handleLevelCompletion() async {
    final levelNumber = widget.game.levelModel.levelNumber;

    await GameScoreManager.setLevelCompleted(levelNumber);
    await GameScoreManager.saveLastLevel(levelNumber);

    // Сохраняем лучший счёт
    final previousScore = GameScoreManager.getLevelScore(levelNumber);
    if (widget.game.scoreNotifier.value > previousScore) {
      await GameScoreManager.setLevelScore(
          levelNumber, widget.game.scoreNotifier.value);
    }

    // Делаем доступной историю следующего уровня
    await GameScoreManager.setLevelHistoryAvailable(levelNumber + 1);
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
                    ? "Вы прошли уровень набрав ${widget.game.scoreNotifier.value} нициков!"
                    : "Не повезло, вы набрали ${widget.game.scoreNotifier.value} нициков из ${widget.game.levelModel.scoreForNextLevel}",
              ),
              const SizedBox(height: 20),
              isLevelPassed
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          text: "Перейти к следующему уровню",
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
