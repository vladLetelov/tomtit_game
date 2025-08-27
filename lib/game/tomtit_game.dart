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
  TomtitGame(
      {required this.levelModel,
      required this.onRestart,
      required this.onReturnToMenu});

  final VoidCallback onRestart;
  final VoidCallback onReturnToMenu;
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

    // Добавляем overlays только если они еще не добавлены
    if (!overlays.activeOverlays.contains('ScoreOverlay')) {
      overlays.add('ScoreOverlay');
    }

    // Инициализация таймера уровня, если есть ограничение
    if (levelModel.timeLimit != null) {
      timeLeftNotifier.value = levelModel.timeLimit!;
      _timeLimitTimer = Timer(1, onTick: () {
        timeLeftNotifier.value--;
        if (timeLeftNotifier.value <= 0) {
          if (levelModel.levelNumber == 2) {
            // На 2 уровне: если набрали 5 очков - черная дыра, иначе - обычное завершение
            if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
              startBlackHoleMode(); // Успех - черная дыра
            } else {
              endGame(); // Неудача - обычное завершение
            }
          } else {
            endGame();
          }
        }
      }, repeat: true);

      if (!overlays.activeOverlays.contains('TimeOverlay')) {
        overlays.add('TimeOverlay');
      }
    }

    if (!overlays.activeOverlays.contains('PauseButton')) {
      overlays.add('PauseButton');
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

  void showTutorialCompletedDialog() {
    overlays.add("TutorialCompleted");
  }

  void endGame() async {
    isGameOver = true;

    // Проверяем, был ли достигнут необходимый счет перед завершением игры
    if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      // Для уровня обучения особенная логика
      if (levelModel.levelNumber == 0) {
        // Разблокируем уровень 1 после прохождения обучения
        await GameScoreManager.setLevelCompleted(0);
        await GameScoreManager.setLevelHistoryCompleted(1);
        await GameScoreManager.setLevelRequirementsMet(1);

        // Показываем сообщение о завершении обучения
        showTutorialCompletedDialog();
        return;
      }
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

      // На 2 уровне при успешном прохождении запускаем черную дыру
      if (levelModel.levelNumber == 2) {
        startBlackHoleMode();
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
    // Убедимся, что overlays не дублируются
    if (overlays.activeOverlays.contains('GameOver') ||
        overlays.activeOverlays.contains('GameCompleted')) {
      return;
    }

    if (levelModel.levelNumber == 6 &&
        scoreNotifier.value >= levelModel.scoreForNextLevel) {
      overlays.add("GameCompleted");
    } else {
      overlays.add("GameOver");
    }
  }

  void restartGame() {
    try {
      isGameOver = false;
      scoreNotifier.value = 0;
      followerSinicas.clear();

      // Удаляем все overlays перед перезагрузкой
      overlays.removeAll(overlays.activeOverlays);

      // Останавливаем все таймеры
      _timeLimitTimer?.stop();
      _bulletTimer.stop();
      _meteorTimer.stop();
      _nicikTimer?.stop();
      _coloredSinicaTimer?.stop();

      // Очищаем все компоненты
      removeAll(children);

      // Загружаем заново
      onLoad();

      // Вызываем колбэк перезапуска
      onRestart();
    } catch (e) {
      print('Error in restartGame: $e');
      // Если произошла ошибка, все равно пытаемся перезапустить
      onRestart();
    }
  }

  void onCaughtNicik() async {
    scoreNotifier.value += 1;
    await GameScoreManager.setLevelScore(levelModel.levelNumber, 1);

    // Для уровня обучения не сохраняем очки в общий счет
    if (levelModel.levelNumber == 0) {
      if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
        endGame();
      }
      return;
    }

    // Для 1 уровня: при наборе 1 очка разблокируем историю 2 уровня
    if (levelModel.levelNumber == 1 && scoreNotifier.value >= 1) {
      await GameScoreManager.setLevelHistoryCompleted(2);
    }
    // Для других уровней: при наборе нужных очков разблокируем историю следующего уровня
    else if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      await GameScoreManager.setLevelHistoryCompleted(
          levelModel.levelNumber + 1);
    }

    if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      endGame(); // Вызываем завершение игры
    }
  }

  // Общая обработка сбора
  void onCollectItem() {
    scoreNotifier.value += 1;

    if (scoreNotifier.value >= levelModel.scoreForNextLevel) {
      endGame();
    }
  }

  // Метод для запуска режима черной дыры
  void startBlackHoleMode() async {
    if (isBlackHoleMode) {
      return; // Избегаем повторного запуска
    }

    isBlackHoleMode = true;

    // Останавливаем все таймеры
    _timeLimitTimer?.stop();
    _bulletTimer.stop();
    _meteorTimer.stop();
    _nicikTimer?.stop();
    _coloredSinicaTimer?.stop();

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

    // Создаем и добавляем черную дыру
    try {
      blackHole = BlackHoleComponent();
      await add(blackHole!);

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

  void pauseGame() {
    paused = true;
    _timeLimitTimer?.pause();
    _bulletTimer.pause();
    _meteorTimer.pause();
    _nicikTimer?.pause();
    _coloredSinicaTimer?.pause();
  }

  void resumeGame() {
    paused = false;
    _timeLimitTimer?.resume();
    _bulletTimer.resume();
    _meteorTimer.resume();
    _nicikTimer?.resume();
    _coloredSinicaTimer?.resume();
  }

  void returnToMenu() {
    try {
      // Сохраняем текущий уровень как последний играемый
      GameScoreManager.setLastPlayedLevel(levelModel.levelNumber);

      // Останавливаем все таймеры
      _timeLimitTimer?.stop();
      _bulletTimer.stop();
      _meteorTimer.stop();
      _nicikTimer?.stop();
      _coloredSinicaTimer?.stop();

      // Удаляем все overlays
      if (overlays.activeOverlays.isNotEmpty) {
        overlays.removeAll(overlays.activeOverlays);
      }

      // Вызываем колбэк для возврата в меню
      onReturnToMenu();
    } catch (e) {
      print('Error in returnToMenu: $e');
      // Все равно вызываем колбэк, даже если произошла ошибка
      onReturnToMenu();
    }
  }
}
