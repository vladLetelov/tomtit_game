import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomtit_game/enums/level_step.dart';

class GameScoreManager {
  /*
  * steps of level - level, video, questions
  * */
  static Future<void> saveLastLevel(int newRecordScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastLevel", newRecordScore);
  }

  static Future<void> saveLastLevelStep(LevelStep step) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastLevelStep", step.name);
  }

  static Future<int> getLastLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("lastLevel") ?? 1;
  }

  static Future<LevelStep> getLastLevelStep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stepString = prefs.getString("lastLevelStep") ?? "level";

    return LevelStep.values.firstWhere(
      (e) => e.name == stepString,
      orElse: () => LevelStep.level,
    );
  }
}