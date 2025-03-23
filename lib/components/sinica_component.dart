import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tomtit_game/components/meteorit_component.dart';
import 'package:tomtit_game/components/nicik_component.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class SinicaComponent extends SpriteComponent
    with DragCallbacks, HasGameReference<TomtitGame>, CollisionCallbacks {
  bool _shouldRemove = false;
  Vector2 _dragDelta = Vector2.zero();

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica.png');
    size = Vector2.all(50);
    anchor = Anchor.center;
    position = Vector2((game.size.x / 2) - 25, game.size.y - 50);
    add(RectangleHitbox()..collisionType = CollisionType.active);
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
      game.meteorPool.add(other);
    }
    if (other is NicikComponent) {
      game.onCaughtNicik();
      other.removeFromParent();
      game.nicikPool.add(other);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_shouldRemove) return;
    _dragDelta.add(event.localDelta); // Копим смещение, но не меняем позицию сразу
  }

  @override
  void update(double dt) {
    if (_dragDelta.length2 > 0) {
      position.add(_dragDelta); // Обновляем позицию один раз в кадр
      _dragDelta.setZero(); // Обнуляем смещение после применения
    }
    super.update(dt);
  }
}
