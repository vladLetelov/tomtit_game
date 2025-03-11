import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key, required this.game});

  final TomtitGame game;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  late ValueNotifier<int> lastRecordNotifier;

  @override
  void initState() {
    super.initState();
    lastRecordNotifier = ValueNotifier<int>(0);
    _loadLastRecord();
  }

  Future<void> _loadLastRecord() async {
    final record = await GameScoreManager.getRecord();
    lastRecordNotifier.value = record;

    if (widget.game.scoreNotifier.value > record) {
      await GameScoreManager.saveNewRecord(widget.game.scoreNotifier.value);
    }
  }

  @override
  void dispose() {
    lastRecordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 0.1);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<int>(
                valueListenable: lastRecordNotifier,
                builder: (context, lastRecord, child) {
                  return Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      widget.game.scoreNotifier.value > lastRecord
                          ? "Поздравляю, новый рекорд, с $lastRecord до ${widget.game.scoreNotifier.value}"
                          : "Ницики: ${widget.game.scoreNotifier.value}",
                      style: TextStyles.defaultStyle,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    widget.game.restartGame();
                    widget.game.overlays.remove('GameOver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}