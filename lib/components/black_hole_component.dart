import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tomtit_game/game/tomtit_game.dart';
import 'dart:ui' as ui;

class BlackHoleComponent extends PositionComponent with HasGameRef<TomtitGame> {
  late double _targetSize;
  late double _growthSpeed;
  late Vector2 _centerPosition;
  bool _isFullyGrown = false;
  double _currentRadius = 10.0;
  double _rotationAngle = 0.0;
  Sprite? _blackHoleSprite; // Может быть null если не загрузится

  @override
  Future<void> onLoad() async {
    print('BlackHole onLoad started');
    
    try {
      // Пытаемся загрузить спрайт черной дыры
      _blackHoleSprite = await Sprite.load('black_hole.png');
      print('Black hole sprite loaded successfully');
    } catch (e) {
      print('Error loading black hole sprite: $e, using fallback rendering');
      _blackHoleSprite = null; // Будем использовать fallback отрисовку
    }
    
    // Начальный размер
    _currentRadius = 10.0;
    _targetSize = 100.0; // Финальный радиус
    _growthSpeed = 75.0; // Скорость роста в пикселях в секунду
    
    // Размер компонента для отрисовки
    size = Vector2.all(_targetSize * 2);
    
    // Позиция в центре экрана
    _centerPosition = Vector2(
      gameRef.size.x / 2,
      gameRef.size.y / 2,
    );
    
    // Центрируем компонент
    position = _centerPosition - size / 2;
    
    // Устанавливаем приоритет выше фона, но ниже синицы
    priority = 5;
    
    print('BlackHole initialized at position: $position, center: $_centerPosition, radius: $_currentRadius');
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Анимация роста черной дыры
    if (!_isFullyGrown && _currentRadius < _targetSize) {
      final growth = _growthSpeed * dt;
      _currentRadius += growth;
      
      // Проверяем, достигла ли черная дыра максимального размера
      if (_currentRadius >= _targetSize) {
        _currentRadius = _targetSize;
        _isFullyGrown = true;
        print('Black hole fully grown, starting to pull sinica');
        
        // Когда черная дыра выросла полностью, начинаем притягивать синицу
        _startPullingSimica();
      }
    }
    
    // Добавляем эффект вращения (для визуального эффекта)
    _rotationAngle += 1.0 * dt; // Медленное вращение
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    
    final center = size / 2; // Центр относительно компонента
    
    if (_blackHoleSprite != null) {
      // Если спрайт загружен, рисуем его
      canvas.save();
      canvas.translate(center.x, center.y);
      canvas.rotate(_rotationAngle);
      canvas.scale(_currentRadius / 50); // Масштабируем спрайт
      
      _blackHoleSprite!.render(
        canvas,
        size: Vector2.all(100), // Базовый размер спрайта
        anchor: Anchor.center,
      );
      
      canvas.restore();
    } else {
      // Fallback: рисуем черную дыру кругами
      
      // Основное тело черной дыры (темно-фиолетовый)
      final fillPaint = Paint()
        ..color = const Color(0xFF2D1B69)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center.toOffset(), _currentRadius, fillPaint);
      
      // Обводка (фиолетовая)
      final strokePaint = Paint()
        ..color = Colors.purple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      
      canvas.drawCircle(center.toOffset(), _currentRadius, strokePaint);
      
      // Дополнительный внутренний круг для эффекта глубины
      if (_currentRadius > 20) {
        final innerPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(center.toOffset(), _currentRadius * 0.3, innerPaint);
      }
    }
  }

  void _startPullingSimica() {
    print('Starting to pull sinica');
    if (gameRef.sinica.isMounted) {
      // Запускаем анимацию притягивания синицы к черной дыре
      gameRef.sinica.startBlackHoleAttraction(_centerPosition);
      print('Sinica attraction started');
    } else {
      print('Sinica is not mounted');
    }
  }

  // Метод для проверки, поглощена ли синица
  bool isSinicaAbsorbed() {
    if (!gameRef.sinica.isMounted) return false;
    
    final distance = gameRef.sinica.position.distanceTo(_centerPosition);
    return distance < 30; // Если синица близко к центру черной дыры
  }
}