import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/components/game_buttons/default_game_button.dart';

class PauseDialog extends StatelessWidget {
  const PauseDialog({super.key, required this.game});
  final TomtitGame game;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.deepPurple[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ПАУЗА',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            DefaultGameButton(
              onTap: () {
                Navigator.of(context).pop();
                game.resumeGame();
              },
              text: 'ПРОДОЛЖИТЬ',
            ),
            const SizedBox(height: 15),
            DefaultGameButton(
              onTap: () {
                Navigator.of(context).pop();
                game.restartGame();
              },
              text: 'ПЕРЕЗАПУСТИТЬ УРОВЕНЬ',
            ),
            const SizedBox(height: 15),
            DefaultGameButton(
              onTap: () {
                Navigator.of(context).pop();
                game.returnToMenu();
              },
              text: 'ВЫЙТИ В МЕНЮ',
            ),
          ],
        ),
      ),
    );
  }
}
