import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tomtit_game/components/meteorit_component.dart';
import 'package:tomtit_game/components/nicik_component.dart';
import 'package:tomtit_game/components/ColoredSinicaComponent.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class SinicaComponent extends SpriteComponent
    with DragCallbacks, HasGameReference<TomtitGame>, CollisionCallbacks {
  late Vector2 _dragStartPosition;
  late Vector2 _dragOffset;
  bool _shouldRemove = false;
  bool _skipDragUpdates = false;

  // Переменные для притягивания к черной дыре
  bool _isBeingPulledByBlackHole = false;
  Vector2? _blackHolePosition;
  final double _pullSpeed = 200.0;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica.png');
    size = Vector2.all(game.levelModel.sinicaSize);
    anchor = Anchor.center;
    position = Vector2((game.size.x / 2) - 25, game.size.y - 50);
    add(RectangleHitbox());

    // Устанавливаем высокий приоритет, чтобы синица была поверх всех объектов
    priority = 10;

    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is MeteoritComponent) {
      other.removeFromParent();
      _shouldRemove = true;
      game.endGame();
      removeFromParent();
    }

    if (other is NicikComponent || other is ColoredSinicaComponent) {
      game.onCollectItem();
      other.removeFromParent();
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStartPosition = position;
    _dragOffset = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_shouldRemove && !_skipDragUpdates) {
      _skipDragUpdates = true;
    }
    // Если синица притягивается к черной дыре, игнорируем перетаскивание
    if (!_skipDragUpdates && !_isBeingPulledByBlackHole) {
      super.onDragUpdate(event);
      position = _dragStartPosition + (event.localStartPosition - _dragOffset);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Логика притягивания к черной дыре
    if (_isBeingPulledByBlackHole && _blackHolePosition != null) {
      final direction = (_blackHolePosition! - position).normalized();
      final movement = direction * _pullSpeed * dt;
      position += movement;

      // Добавляем эффект уменьшения размера при приближении к черной дыре
      final distance = position.distanceTo(_blackHolePosition!);
      if (distance < 100) {
        final scaleRatio = distance / 100;
        scale = Vector2.all(scaleRatio.clamp(0.1, 1.0));
      }

      // Проверяем, достигла ли синица черной дыры
      if (distance < 30) {
        print('Sinica reached black hole, being absorbed');
        _onAbsorbedByBlackHole();
      }
    }

    // Телепортация слева-направо
    if (position.x < -size.x / 100) {
      position.x = game.size.x + size.x / 100;
    }

    if (position.x > game.size.x + size.x / 100) {
      position.x = -size.x / 100;
    }
  }

  // Метод для начала притягивания к черной дыре
  void startBlackHoleAttraction(Vector2 blackHolePosition) {
    print('Sinica: Starting black hole attraction');
    _isBeingPulledByBlackHole = true;
    _blackHolePosition = blackHolePosition;
    _skipDragUpdates = true; // Отключаем перетаскивание
    print('Sinica: Black hole position set to $blackHolePosition');
  }

  // Метод вызывается когда синица поглощается черной дырой
  void _onAbsorbedByBlackHole() {
    _shouldRemove = true;
    // Запускаем финальную анимацию поглощения
    removeFromParent();
    // Завершаем игру с особым эффектом для черной дыры
    game.endGameByBlackHole();
  }
}
