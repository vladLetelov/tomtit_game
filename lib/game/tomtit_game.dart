import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:tomtit_game/components/background_component.dart';
import 'package:tomtit_game/components/rocket_animation_component.dart';
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
  bool gameStarted = false;

  /*
  * Pools of components
  * */
  final List<MeteoritComponent> meteorPool = [];
  final List<NicikComponent> nicikPool = [];
  final List<SemechkoComponent> semechkoPool = [];

  @override
  Future<void> onLoad() async {
    add(FpsTextComponent(position: Vector2(20, 20)));
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
    if (meteorPool.isEmpty) {
      for (int i = 0; i < 50; i++) {
        meteorPool.add(MeteoritComponent());
      }
      for (int i = 0; i < 5; i++) {
        nicikPool.add(NicikComponent());;
      }
      for (int i = 0; i < 10; i++) {
        semechkoPool.add(SemechkoComponent());
      }
    }

    _bulletTimer = Timer(levelModel.bulletFrequency, onTick: spawnSemechko, repeat: true);
    _meteorTimer = Timer(levelModel.meteorFrequency, onTick: spawnMeteor, repeat: true);
    _nicikTimer = Timer(levelModel.nicikFrequency, onTick: spawnNicik, repeat: true);

    overlays.add('ScoreOverlay');
    add(RocketAnimationComponent());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;
    if (gameStarted) {
      _bulletTimer.update(dt);
      _meteorTimer.update(dt);
      _nicikTimer.update(dt);
    }
  }

  void spawnMeteor() {
    if (meteorPool.isNotEmpty) {
      final meteor = meteorPool.removeLast();
      add(meteor);
      meteor.reset();
    } else {
      print("No meteorits");
    }
  }

  void spawnNicik() {
    if (nicikPool.isNotEmpty) {
      final nicik = nicikPool.removeLast();
      add(nicik);
      nicik.reset();
    } else {
      print("No nicik");
    }
  }

  void spawnSemechko() {
    if (semechkoPool.isNotEmpty) {
      final semechko = semechkoPool.removeLast();
      add(semechko);
      semechko.reset();
    } else {
      print("No semechko");
    }
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