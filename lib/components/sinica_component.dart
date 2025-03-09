import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tomtit_game/components/meteorit_component.dart';
import 'package:tomtit_game/components/nicik_component.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class SinicaComponent extends SpriteComponent
    with DragCallbacks, HasGameReference<TomtitGame>, CollisionCallbacks  {
  late Vector2 _dragStartPosition;
  late Vector2 _dragOffset;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica.png');
    size = Vector2.all(50);
    anchor = Anchor.center;
    add(RectangleHitbox());
    super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is MeteoritComponent) {
      game.endGame();
    }

    if (other is NicikComponent) {
      game.scoreNotifier.value += 1;
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
    super.onDragUpdate(event);
    position = _dragStartPosition + (event.localStartPosition - _dragOffset);
  }
}
