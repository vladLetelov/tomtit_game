import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tomtit_game/game/tomtit_game.dart';

class ExtraLifeBuffComponent extends SpriteComponent
    with HasGameReference<TomtitGame>, CollisionCallbacks {

}