import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'package:tomtit_game/theme/styles/text_styles.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key, required this.game});

  final TomtitGame game;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late Future<int> maxScoreFuture;

  @override
  void initState() {
    super.initState();
    maxScoreFuture = GameScoreManager.getRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 250,
          width: 300,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tomtit game',
                style: TextStyles.defaultStyle,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Record: ", style: TextStyles.defaultStyle,),
                  FutureBuilder<int>(
                    future: maxScoreFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.toString(), style: TextStyles.defaultStyle);
                      } else {
                        return const Text("-", style: TextStyles.defaultStyle,);
                      }
                    }
                  )
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    widget.game.overlays.remove('MainMenu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
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