import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class TimeOverlay extends StatelessWidget {
  final TomtitGame game;

  const TimeOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: Material(
        color: Colors.transparent,
        child: ValueListenableBuilder<int>(
          valueListenable: game.timeLeftNotifier,
          builder: (context, timeLeft, child) {
            final minutes = (timeLeft ~/ 60).toString().padLeft(2, '0');
            final seconds = (timeLeft % 60).toString().padLeft(2, '0');

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 2, color: Colors.deepPurple),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                '$minutes:$seconds',
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
