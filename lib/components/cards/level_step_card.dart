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
import 'package:tomtit_game/screens/level_histories_screen.dart';
import 'package:tomtit_game/components/game_buttons/history_button.dart';

class LevelStepCard extends StatelessWidget {
  final LevelModel level;
  final bool isLocked;
  final bool isLevelUnlocked;
  final bool isHistoryUnlocked;

  const LevelStepCard({
    super.key,
    required this.level,
    required this.isLocked,
    required this.isLevelUnlocked,
    required this.isHistoryUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HistoryGameButton(
          onTap: isHistoryUnlocked
              ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LevelHistoryesScreen(level: level),
                    ),
                  );
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => GameWidget<TomtitGame>.controlled(
                        gameFactory: () => TomtitGame(levelModel: level),
                        overlayBuilderMap: {
                          'GameOver': (_, game) => GameOver(game: game),
                          'ScoreOverlay': (_, game) => ScoreOverlay(game: game),
                          'TimeOverlay': (_, game) => TimeOverlay(game: game),
                          'VictorySlideshow': (_, game) =>
                              VictorySlideshow(game: game),
                          'GameCompleted': (_, game) =>
                              GameCompleted(game: game),
                        },
                      ),
                    ),
                  );
                }
              : null,
        ),
      ],
    );
  }
}
