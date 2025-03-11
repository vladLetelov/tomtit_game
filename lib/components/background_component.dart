import 'package:flame/components.dart';

class BackgroundComponent extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background.jpg');
  }
}