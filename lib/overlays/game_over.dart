import 'package:flutter/material.dart';
import 'package:tomtit_game/components/game_buttons/default_game_button.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/screens/level_selection_screen.dart';
import 'package:tomtit_game/screens/level_video_screen.dart';
import 'package:tomtit_game/theme/colors.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

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
    isLevelPassed = widget.game.scoreNotifier.value >= widget.game.levelModel.scoreForNextLevel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: deepDarkPurple.withOpacity(0.7),
            border: Border.all(
              width: 2,
              color: Colors.deepPurple,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(16), // Рамка с радиусом 16, как у контейнера
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
                              builder: (BuildContext context) => LevelVideoScreen(level: widget.game.levelModel)
                          )
                      );
                    },
                    text: "Перейти к фрагменту истории",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultGameButton(
                          onTap: () {
                            widget.game.removeWhere((component) => true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => LevelSelectionScreen()
                                )
                            );
                          },
                          text: 'Выход в меню'
                      ),
                      const SizedBox(width: 10),
                      DefaultGameButton(
                        onTap: () {
                          widget.game.removeWhere((component) => true);
                          widget.game.restartGame();
                          widget.game.overlays.remove('GameOver');
                        },
                        text: "Играть заново",
                      ),
                    ],
                  )
                ],
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultGameButton(
                    onTap: () {
                      widget.game.removeWhere((component) => true);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => LevelSelectionScreen()
                          )
                      );
                    },
                    text: 'Выход в меню'
                  ),
                  const SizedBox(width: 10),
                  DefaultGameButton(
                    onTap: () {
                      widget.game.removeWhere((component) => true);
                      widget.game.restartGame();
                      widget.game.overlays.remove('GameOver');
                    },
                    text: "Попробовать снова",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
