import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final deviceInfo = DeviceInfoPlugin();

enum PlatformType {
  android,
  ios,
}

Future<void> getDeviceInfo(prefs, _devicePlatform, _deviceModel, _deviceOsVersion) async {
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    await prefs.setString(_devicePlatform, PlatformType.android);
    await prefs.setString(_deviceModel, androidInfo.model);
    await prefs.setString(_deviceOsVersion, androidInfo.version.release);
    return;
  }

  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    await prefs.setString(_devicePlatform, PlatformType.ios);
    await prefs.setString(_deviceModel, iosInfo.utsname.machine);
    await prefs.setString(_deviceOsVersion, iosInfo.systemVersion);
    return;
  }
}

class UserStorage {
  static const _photoUrlKey = 'user_photo_url';
  static const _fullNameKey = 'user_full_name';
  static const _groupNameKey = 'group_name';
  static const _id = 'student_id';
  static const _topcoins = 'topcoins';
  static const _topgems = 'topgems';
  static const _devicePlatform = 'device_platform';
  static const _deviceModel = 'device_model';
  static const _deviceOsVersion = 'device_os_version';

  static Future<void> saveUserInfo({
    required String fullName,
    required String photoUrl,
    required String groupName,
    required int id,
    required int topcoins,
    required int topgems,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    getDeviceInfo(prefs, _devicePlatform, _deviceModel, _deviceOsVersion);
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_photoUrlKey, photoUrl);
    await prefs.setString(_groupNameKey, groupName);
    await prefs.setInt(_id, id);
    await prefs.setInt(_topcoins, topcoins);
    await prefs.setInt(_topgems, topgems);
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

  static Future<String?> getDevicePlatform() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_devicePlatform);
  }

  static Future<String?> getDeviceModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceModel);
  }

  static Future<String?> getDeviceOsVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceOsVersion);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
