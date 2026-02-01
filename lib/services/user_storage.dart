import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _photoUrlKey = 'user_photo_url';
  static const _fullNameKey = 'user_full_name';
  static const _groupNameKey = 'group_name';
  static const _id = 'student_id';

  static Future<void> saveUserInfo({
    required String fullName,
    required String photoUrl,
    required String groupName,
    required int id,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_photoUrlKey, photoUrl);
    await prefs.setString(_groupNameKey, groupName);
    await prefs.setInt(_id, id);
  }

  static Future<bool?> isValidAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString(_fullNameKey);
    final photoUrl = prefs.getString(_photoUrlKey);
    final groupName = prefs.getString(_groupNameKey);
    final id = prefs.getInt(_id);

    if (fullName != null && photoUrl != null && groupName != null && id != null) {
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

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
