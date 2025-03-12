import 'package:flame/components.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameReference<TomtitGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(game.levelModel.background);
    size = game.size;
  }
}