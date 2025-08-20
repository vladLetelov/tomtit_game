import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/storage/game_score.dart';

class ScoreOverlay extends StatelessWidget {
  final TomtitGame game;

  const ScoreOverlay({super.key, required this.game});

  bool _isLevelPassed() {
    final score = game.scoreNotifier.value;
    final requiredScore = game.requiredScore;
    return score >= requiredScore;
  }

  Future<void> _unlockNextHistory() async {
    final nextLevelId = game.currentLevel + 1;
    final isAlreadyUnlocked =
        GameScoreManager.isLevelHistoryCompleted(nextLevelId);

    if (!isAlreadyUnlocked && _isLevelPassed()) {
      await GameScoreManager.setLevelHistoryCompleted(nextLevelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: ValueListenableBuilder<int>(
          valueListenable: game.scoreNotifier,
          builder: (context, score, child) {
            if (_isLevelPassed()) {
              _unlockNextHistory();
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 2, color: Colors.deepPurple),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Score: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
