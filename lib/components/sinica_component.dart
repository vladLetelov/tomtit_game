import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tomtit_game/components/meteorit_component.dart';
import 'package:tomtit_game/components/nicik_component.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class SinicaComponent extends SpriteComponent
    with DragCallbacks, HasGameReference<TomtitGame>, CollisionCallbacks  {
  bool _shouldRemove = false;
  bool _skipDragUpdates = false;
  int _lastUpdate = 0;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica.png');
    size = Vector2.all(50);
    anchor = Anchor.center;
    position = Vector2((game.size.x / 2) - 25, game.size.y - 50);
    add(RectangleHitbox()
      ..collisionType = CollisionType.active);
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

    if (other is NicikComponent) {
      game.onCaughtNicik();
      other.removeFromParent();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {

    if (_shouldRemove && !_skipDragUpdates) {
      _skipDragUpdates = true;
    }
    if (!_skipDragUpdates) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastUpdate < 16) return; // Ограничение 60 FPS (1000ms / 60)

      _lastUpdate = now;
      position.add(event.localDelta);
    }
  }
}
