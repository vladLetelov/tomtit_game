import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/dialogs/pause_dialog.dart';

class PauseButtonOverlay extends StatelessWidget {
  const PauseButtonOverlay(this.game, {super.key});
  final TomtitGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20, // Отступ сверху
      right: 20, // Отступ справа
      child: GestureDetector(
        onTap: () {
          if (!game.isGameOver && !game.isBlackHoleMode) {
            game.pauseGame();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PauseDialog(game: game);
              },
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.pause,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
