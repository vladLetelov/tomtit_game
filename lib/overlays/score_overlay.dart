import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class ScoreOverlay extends StatelessWidget {
  final TomtitGame game;

  const ScoreOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: ValueListenableBuilder<int>(
          valueListenable: game.scoreNotifier,
          builder: (context, score, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(
                  width: 2,
                  color: Colors.deepPurple
                ),
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