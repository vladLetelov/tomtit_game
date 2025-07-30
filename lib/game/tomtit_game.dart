import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:tomtit_game/components/background_component.dart';
import 'package:tomtit_game/models/level_model.dart';
import 'package:tomtit_game/storage/game_score.dart';
import 'dart:async';
import 'dart:math';
import '../components/sinica_component.dart';
import '../components/meteorit_component.dart';
import '../components/semechko_component.dart';
import '../components/nicik_component.dart';
import '../components/ColoredSinicaComponent.dart';
import 'package:flutter/material.dart';

class TomtitGame extends FlameGame with HasCollisionDetection {
  TomtitGame({required this.levelModel});

  late SinicaComponent sinica;
  late SpriteComponent background;
  final LevelModel levelModel;

  late Sprite meteoritSprite;
  late Sprite nicikSprite;
  late Sprite semechkoSprite;

  late Timer _bulletTimer;
  late Timer _meteorTimer;
  Timer? _nicikTimer;
  Timer? _coloredSinicaTimer;

  Timer? _timeLimitTimer;
  ValueNotifier<int> timeLeftNotifier = ValueNotifier<int>(0);

  int get currentLevel => levelModel.levelNumber;
  double get requiredScore => levelModel.scoreForNextLevel;

  final Random random = Random();
  ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  bool isGameOver = false;

  late int lastLevel;

  @override
  Future<void> onLoad() async {
    lastLevel = await GameScoreManager.getLastUnlockedLevel();

    meteoritSprite = await Sprite.load('meteorit.webp');
    nicikSprite = await Sprite.load('nicik.webp');
    semechkoSprite = await Sprite.load('semechko.webp');
    sinica = SinicaComponent();
    addAll([BackgroundComponent(), sinica]);

    _bulletTimer = Timer(levelModel.bulletFrequency,
        onTick: () => add(SemechkoComponent()), repeat: true);
    _meteorTimer = Timer(levelModel.meteorFrequency,
        onTick: () => add(MeteoritComponent()), repeat: true);

    // Инициализация таймеров только если они нужны на уровне
    if (levelModel.hasNiciks) {
      _nicikTimer = Timer(
        levelModel.nicikFrequency,
        onTick: () => add(NicikComponent()),
        repeat: true,
      );
    }
    // Только если уровень предусматривает цветных птичек
    if (levelModel.hasColoredSinicis &&
        levelModel.coloredSinicaFrequency != null) {
      _coloredSinicaTimer = Timer(
        levelModel.coloredSinicaFrequency!,
        onTick: () => add(ColoredSinicaComponent()),
        repeat: true,
      );
    }
    overlays.add('ScoreOverlay');

    // Инициализация таймера уровня, если есть ограничение
    if (levelModel.timeLimit != null) {
      timeLeftNotifier.value = levelModel.timeLimit!;
      _timeLimitTimer = Timer(1, onTick: () {
        timeLeftNotifier.value--;
        if (timeLeftNotifier.value <= 0) {
          endGame();
        }
      }, repeat: true);
      overlays.add('TimeOverlay');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    _timeLimitTimer?.update(dt);
    _bulletTimer.update(dt);
    _meteorTimer.update(dt);
    _nicikTimer?.update(dt);
    _coloredSinicaTimer?.update(dt);
  }

  @override
  void onRemove() {
    _timeLimitTimer?.stop();
    _nicikTimer?.stop();
    _coloredSinicaTimer?.stop();
    super.onRemove();
  }

  void endGame() async {
    isGameOver = true;

    // Проверяем, был ли достигнут необходимый счет перед завершением игры
    if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      await GameScoreManager.setLevelCompleted(levelModel.levelNumber);
      if (levelModel.levelNumber ==
          await GameScoreManager.getLastUnlockedLevel()) {
        await GameScoreManager.setLevelUnlocked(levelModel.levelNumber + 1);
      }
    }

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
    await GameScoreManager.setLevelScore(
        levelModel.levelNumber, scoreNotifier.value);

    // Для 1 уровня: при наборе 1 очка разблокируем историю 2 уровня
    if (levelModel.levelNumber == 1 && scoreNotifier.value >= 1) {
      await GameScoreManager.setLevelHistoryCompleted(2);
    }
    // Для других уровней: при наборе нужных очков разблокируем историю следующего уровня
    else if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      await GameScoreManager.setLevelHistoryCompleted(
          levelModel.levelNumber + 1);
    }
  }

  // Общая обработка сбора
  void onCollectItem() {
    scoreNotifier.value += 1;
  }
}
