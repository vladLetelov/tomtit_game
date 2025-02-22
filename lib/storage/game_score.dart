import 'package:shared_preferences/shared_preferences.dart';

class GameScoreManager {
  static Future<void> saveNewRecord(int newRecordScore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("record", newRecordScore);
  }

  static Future<int> getRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("record")!;
  }
}