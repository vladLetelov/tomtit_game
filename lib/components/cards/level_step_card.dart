import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/components/utils/level_card_connector.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/components/cards/level_card.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';
import 'package:tomtit_game/overlays/time_overlay.dart';
import 'package:tomtit_game/overlays/victory_slideshow.dart';
import 'package:tomtit_game/overlays/game_completed.dart';
import 'package:tomtit_game/overlays/pause_button_overlay.dart';
import 'package:tomtit_game/screens/level_histories_screen.dart';
import 'package:tomtit_game/components/game_buttons/history_button.dart';

class LevelStepCard extends StatelessWidget {
  final LevelModel level;
  final bool isLocked;
  final bool isLevelUnlocked;
  final bool isHistoryUnlocked;
  final VoidCallback? onLevelCompleted;
  final ValueChanged<int>? onLevelSelected;

  const LevelStepCard({
    super.key,
    required this.level,
    required this.isLocked,
    required this.isLevelUnlocked,
    required this.isHistoryUnlocked,
    this.onLevelCompleted,
    this.onLevelSelected,
  });

  void _startHistory(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => LevelHistoryesScreen(level: level),
      ),
    );

    if (result == true || result != null) {
      if (onLevelCompleted != null) {
        onLevelCompleted!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HistoryGameButton(
          onTap: isHistoryUnlocked
              ? () {
                  _startHistory(context);
                }
              : null,
          isLocked: !isHistoryUnlocked,
          backgroundImage: level.historyButtonPath,
        ),
        const LevelCardConnector(),
        LevelCard(
          level: level,
          isLocked: !isLevelUnlocked,
          onTap: isLevelUnlocked
              ? () {
                  // Сообщаем о выборе уровня
                  if (onLevelSelected != null) {
                    onLevelSelected!(level.levelNumber);
                  }

                  final navigator = Navigator.of(context);

                  void startGame() {
                    navigator
                        .push(
                      MaterialPageRoute(
                        builder: (context) => GameWidget<TomtitGame>.controlled(
                          gameFactory: () => TomtitGame(
                            levelModel: level,
                            onRestart: () {
                              navigator.pop(); // закрыть текущую игру
                              startGame(); // запустить новую игру
                            },
                            onReturnToMenu: () {
                              navigator.pop(); // просто закрыть игру
                            },
                          ),
                          overlayBuilderMap: {
                            'PauseButton': (context, TomtitGame game) =>
                                PauseButtonOverlay(game),
                            'GameOver': (_, game) => GameOver(game: game),
                            'ScoreOverlay': (_, game) =>
                                ScoreOverlay(game: game),
                            'TimeOverlay': (_, game) => TimeOverlay(game: game),
                            'VictorySlideshow': (_, game) =>
                                VictorySlideshow(game: game),
                            'GameCompleted': (_, game) =>
                                GameCompleted(game: game),
                          },
                        ),
                      ),
                    )
                        .then((value) {
                      if (onLevelCompleted != null) {
                        onLevelCompleted!();
                      }
                    });
                  }

                  startGame();
                }
              : null,
        ),
      ],
    );
  }
}
