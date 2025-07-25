import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/components/utils/level_card_connector.dart';
import 'package:tomtit_game/components/utils/step_button.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/components/cards/level_card.dart';
import 'package:tomtit_game/overlays/game_over.dart';
import 'package:tomtit_game/overlays/score_overlay.dart';
import 'package:tomtit_game/screens/level_questions_screen.dart';
import 'package:tomtit_game/screens/level_histories_screen.dart';
import 'package:tomtit_game/screens/level_video_screen.dart';
import 'package:tomtit_game/components/game_buttons/history_button.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/enums/level_step.dart';

class LevelStepCard extends StatelessWidget {
  final LevelModel level;
  final bool isLocked;
  final bool isLevelUnlocked;
  final bool isVideoUnlocked;
  final bool isQuestionsUnlocked;
  final bool isHistoryUnlocked;

  const LevelStepCard({
    super.key,
    required this.level,
    required this.isLocked,
    required this.isLevelUnlocked,
    required this.isVideoUnlocked,
    required this.isQuestionsUnlocked,
    required this.isHistoryUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LevelStep>(
        future: GameScoreManager.getLevelProgress(level.levelNumber),
        builder: (context, snapshot) {
          final levelProgress = snapshot.data ?? LevelStep.level;
          final isHistoryUnlocked =
              levelProgress.index >= LevelStep.questions.index;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LevelCard(
                level: level,
                isLocked: !isLevelUnlocked,
                onTap: isLevelUnlocked
                    ? () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                GameWidget<TomtitGame>.controlled(
                              gameFactory: () => TomtitGame(levelModel: level),
                              overlayBuilderMap: {
                                'GameOver': (_, game) => GameOver(game: game),
                                'ScoreOverlay': (_, game) =>
                                    ScoreOverlay(game: game),
                              },
                            ),
                          ),
                        );
                      }
                    : null,
              ),
              const LevelCardConnector(),
              StepButton(
                text: "Посмотреть видео",
                icon: Icons.play_circle_fill,
                onTap: isVideoUnlocked
                    ? () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LevelVideoScreen(level: level)));
                      }
                    : null,
                isLocked: !isVideoUnlocked,
              ),
              const LevelCardConnector(),
              StepButton(
                text: "Вопросы",
                icon: Icons.question_answer,
                onTap: isQuestionsUnlocked
                    ? () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LevelQuestionsScreen(level: level)));
                      }
                    : null,
                isLocked: !isQuestionsUnlocked,
              ),
              const LevelCardConnector(),
              HistoryGameButton(
                onTap: isHistoryUnlocked
                    ? () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LevelHistoryesScreen(level: level)));
                      }
                    : () {},
                backgroundImage: level.historyButtonPath,
                isLocked: !isHistoryUnlocked,
              ),
            ],
          );
        });
  }
}
