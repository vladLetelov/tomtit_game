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

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('sinica.png');
    size = Vector2.all(game.levelModel.sinicaSize);
    anchor = Anchor.center;
    position = Vector2((game.size.x / 2) - 25, game.size.y - 50);
    add(RectangleHitbox());
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
    if (!_skipDragUpdates) {
      super.onDragUpdate(event);
      position = _dragStartPosition + (event.localStartPosition - _dragOffset);
    }
  }
}
