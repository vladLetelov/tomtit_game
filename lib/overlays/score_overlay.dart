import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class ScoreOverlay extends StatelessWidget {
  final TomtitGame game;

  const ScoreOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20, // Отступ сверху
      right: 20, // Отступ справа
      child: ValueListenableBuilder<int>(
        valueListenable: game.scoreNotifier,
        builder: (context, score, child) {
          return Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}