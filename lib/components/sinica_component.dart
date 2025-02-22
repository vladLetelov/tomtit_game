import 'package:flame/components.dart';
import 'package:flame/events.dart';

class SinicaComponent extends SpriteComponent with DragCallbacks {
  late Vector2 _dragStartPosition;
  late Vector2 _dragOffset;

  SinicaComponent() {
    size = Vector2(50, 50);
    position = Vector2.zero();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
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
