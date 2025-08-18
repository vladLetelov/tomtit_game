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
import '../components/black_hole_component.dart';
import '../components/follower_sinica_component.dart';
import 'package:flutter/material.dart';

class TomtitGame extends FlameGame with HasCollisionDetection {
  TomtitGame({required this.levelModel});

  late SinicaComponent sinica;
  late SpriteComponent background;
  final LevelModel levelModel;
  List<FollowerSinicaComponent> followerSinicas = [];

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
  bool isBlackHoleMode = false;
  BlackHoleComponent? blackHole;

  late int lastLevel;

  @override
  Future<void> onLoad() async {
    lastLevel = GameScoreManager.getLastUnlockedLevel();

    meteoritSprite = await Sprite.load('meteorit.webp');
    nicikSprite = await Sprite.load('nicik.webp');
    semechkoSprite = await Sprite.load('semechko.webp');
    sinica = SinicaComponent();
    addAll([BackgroundComponent(), sinica]);

    // Добавляем клонов синицы для режима tripleSinicaMode
    if (levelModel.tripleSinicaMode == true) {
      final follower1 = FollowerSinicaComponent(sinica, Vector2(-30, 25), 5);
      final follower2 = FollowerSinicaComponent(sinica, Vector2(30, 25), 5);
      final follower3 = FollowerSinicaComponent(sinica, Vector2(0, 40), 10);
      
      followerSinicas = [follower1, follower2, follower3];
      addAll(followerSinicas);
    }

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
          // Для второго уровня запускаем черную дыру вместо обычного окончания
          if (levelModel.levelNumber == 2) {
            print('Timer ended on level 2, starting black hole mode');
            startBlackHoleMode();
          } else {
            // Для всех остальных уровней, включая 5-й, завершаем игру обычным способом
            print('Timer ended on level ${levelModel.levelNumber}, ending game');
            endGame();
          }
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
      if (levelModel.levelNumber == GameScoreManager.getLastUnlockedLevel()) {
        await GameScoreManager.setLevelUnlocked(levelModel.levelNumber + 1);
      }

      // Для 6 уровня показываем слайдшоу победы
      if (levelModel.levelNumber == 6 &&
          levelModel.victorySlideshowImages != null &&
          levelModel.victorySlideshowImages!.isNotEmpty) {
        showVictorySlideshow();
        return;
      }
    }

    showGameOverDialog();
  }

  void showVictorySlideshow() {
    overlays.remove('ScoreOverlay');
    overlays.remove('TimeOverlay');
    overlays.add('VictorySlideshow');
  }

  void showGameOverDialog() {
    if (levelModel.levelNumber == 6 &&
        scoreNotifier.value >= levelModel.scoreForNextLevel) {
      // Для 6 уровня показываем специальный диалог
      overlays.add("GameCompleted");
    } else {
      overlays.add("GameOver");
    }
  }

  void restartGame() {
    isGameOver = false;
    scoreNotifier.value = 0;
    followerSinicas.clear();
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

  // Метод для запуска режима черной дыры
  void startBlackHoleMode() async {
    print('startBlackHoleMode called');
    if (isBlackHoleMode) {
      print('Black hole mode already active, returning');
      return; // Избегаем повторного запуска
    }

    isBlackHoleMode = true;
    print('Black hole mode activated');

    // Останавливаем все таймеры
    _timeLimitTimer?.stop();
    _bulletTimer.stop();
    _meteorTimer.stop();
    _nicikTimer?.stop();
    _coloredSinicaTimer?.stop();
    print('All timers stopped');

    // Удаляем все движущиеся объекты кроме синицы
    children.whereType<MeteoritComponent>().forEach((meteorit) {
      meteorit.removeFromParent();
    });
    children.whereType<SemechkoComponent>().forEach((semechko) {
      semechko.removeFromParent();
    });
    children.whereType<NicikComponent>().forEach((nicik) {
      nicik.removeFromParent();
    });
    children.whereType<ColoredSinicaComponent>().forEach((coloredSinica) {
      coloredSinica.removeFromParent();
    });
    print('All game objects removed');

    // Создаем и добавляем черную дыру
    try {
      blackHole = BlackHoleComponent();
      await add(blackHole!);
      print('Black hole component added successfully');
      
      // Начинаем притягивание всех синиц к черной дыре
      sinica.startBlackHoleAttraction(blackHole!.position);
      for (final follower in followerSinicas) {
        follower.startBlackHoleAttraction(blackHole!.position);
      }
    } catch (e) {
      print('Error adding black hole: $e');
    }

    // Скрываем таймер, так как он больше не нужен
    overlays.remove('TimeOverlay');
    print('Timer overlay removed');
  }

  // Метод для завершения игры через черную дыру
  void endGameByBlackHole() async {
    isGameOver = true;

    // Проверяем, был ли достигнут необходимый счет перед завершением игры
    if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      await GameScoreManager.setLevelCompleted(levelModel.levelNumber);
      if (levelModel.levelNumber == GameScoreManager.getLastUnlockedLevel()) {
        await GameScoreManager.setLevelUnlocked(levelModel.levelNumber + 1);
      }
    }

    // Небольшая задержка перед показом диалога для эффектности
    await Future.delayed(const Duration(milliseconds: 1000));
    showGameOverDialog();
  }
}
