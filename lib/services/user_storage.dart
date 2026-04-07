import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _usernameKey = 'username';
  static const _passwordKey = 'password';

  static const _photoUrlKey = 'user_photo_url';
  static const _fullNameKey = 'user_full_name';
  static const _groupNameKey = 'group_name';
  static const _id = 'student_id';
  static const _topcoins = 'topcoins';
  static const _topgems = 'topgems';

  static Future<void> saveUserInfo({
    required String fullName,
    required String photoUrl,
    required String groupName,
    required int id,
    required int topcoins,
    required int topgems,

    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_photoUrlKey, photoUrl);
    await prefs.setString(_groupNameKey, groupName);
    await prefs.setInt(_id, id);
    await prefs.setInt(_topcoins, topcoins);
    await prefs.setInt(_topgems, topgems);

    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  static Future<bool?> isValidAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString(_fullNameKey);
    final photoUrl = prefs.getString(_photoUrlKey);
    final groupName = prefs.getString(_groupNameKey);
    final id = prefs.getInt(_id);
    final topcoins = prefs.getInt(_topcoins);
    final topgems = prefs.getInt(_topgems);

    if (fullName != null && photoUrl != null && groupName != null && id != null && topcoins != null && topgems != null) {
      return true;
    }
    return false;
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  static Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_id);
  }

  static Future<String?> getGroupName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_groupNameKey);
  }

  static Future<String?> getPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_photoUrlKey);
  }

  static Future<int?> getTopCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_topcoins);
  }

  static Future<int?> getTopGems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_topgems);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
