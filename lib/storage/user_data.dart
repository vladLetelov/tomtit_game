// storage/user_data.dart
import 'package:shared_preferences/shared_preferences.dart';

class UserDataManager {
  static const String _userNameKey = 'user_name';
  static const String _userInitialsKey = 'user_initials';
  static const String _nameSetKey = 'name_set';

  static Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  static Future<void> saveUserName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, fullName);

    final initials = _getInitials(fullName);
    await prefs.setString(_userInitialsKey, initials);

    // Помечаем что имя было установлено
    await prefs.setBool(_nameSetKey, true);
  }

  static Future<bool> hasUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userNameKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  static Future<bool> canChangeName() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_nameSetKey) ?? false);
  }

  static String _getInitials(String fullName) {
    final parts = fullName.split(' ');
    if (parts.isEmpty) return '';

    String initials = parts[0].isNotEmpty ? parts[0][0] : '';

    if (parts.length > 1 && parts[1].isNotEmpty) {
      initials += parts[1][0];
    }

    if (parts.length > 2 && parts[2].isNotEmpty) {
      initials += parts[2][0];
    }

    return initials.toUpperCase();
  }
}
