import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:tomtit_game/components/background_component.dart';
import 'package:tomtit_game/enums/level_step.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'dart:async';
import 'dart:math';

import '../components/sinica_component.dart';
import '../components/meteorit_component.dart';
import '../components/semechko_component.dart';
import '../components/nicik_component.dart';
import 'package:flutter/material.dart';

class TomtitGame extends FlameGame with HasCollisionDetection {
  TomtitGame({required this.levelModel}) {
    Sprite.load('meteorit.webp').then((val) {
      meteoritSprite = val;
    });
    Sprite.load('nicik.webp').then((val) {
      nicikSprite = val;
    });
    Sprite.load('semechko.webp').then((val) {
      semechkoSprite = val;
    });
  }

  late SinicaComponent sinica;
  late SpriteComponent background;
  final LevelModel levelModel;
  /*
  * load sprites only on start of the game for optimization
  * */
  late Sprite meteoritSprite;
  late Sprite nicikSprite;
  late Sprite semechkoSprite;

  /*
  * Timers of spawn
  * */
  late Timer _bulletTimer;
  late Timer _meteorTimer;
  late Timer _nicikTimer;

  final Random random = Random();
  ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  bool isGameOver = false;
  
  /*
  * for understand need update step or no
  * */
  late int lastLevel;
  late LevelStep step;

  @override
  Future<void> onLoad() async {
    add(FpsTextComponent());
    GameScoreManager.getLastLevel().then((val) {
      lastLevel = val;
    });
    GameScoreManager.getLastLevelStep().then((val) {
      step = val;
    });
    sinica = SinicaComponent();
    addAll([
      BackgroundComponent(),
      sinica
    ]);

    _bulletTimer = Timer(levelModel.bulletFrequency, onTick: () => add(SemechkoComponent()), repeat: true);
    _meteorTimer = Timer(levelModel.meteorFrequency, onTick: () => add(MeteoritComponent()), repeat: true);
    _nicikTimer = Timer(levelModel.nicikFrequency, onTick: () => add(NicikComponent()), repeat: true);

    overlays.add('ScoreOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    _bulletTimer.update(dt);
    _meteorTimer.update(dt);
    _nicikTimer.update(dt);
  }

  void endGame() async{
    isGameOver = true;
    showGameOverDialog();
  }

  void showGameOverDialog() {
    overlays.add("GameOver");
  }

  void restartGame() {
    isGameOver = false;
    scoreNotifier.value = 0;
    onLoad();
  }

  void onCaughtNicik() async {
    scoreNotifier.value += 1;
    if (scoreNotifier.value == levelModel.scoreForNextLevel) {
      if (lastLevel == levelModel.levelNumber && step == LevelStep.level) {
        await GameScoreManager.saveLastLevelStep(LevelStep.video);
      }
    }
  }
}