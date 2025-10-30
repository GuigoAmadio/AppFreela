import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class SharedPrefsHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception('SharedPreferences não inicializado. Chame init() primeiro.');
    }
    return _prefs!;
  }

  // Token
  static Future<void> saveToken(String token) async {
    await instance.setString(AppConstants.keyToken, token);
  }

  static String? getToken() {
    return instance.getString(AppConstants.keyToken);
  }

  static Future<void> removeToken() async {
    await instance.remove(AppConstants.keyToken);
  }

  // User ID
  static Future<void> saveUserId(String userId) async {
    await instance.setString(AppConstants.keyUserId, userId);
  }

  static String? getUserId() {
    return instance.getString(AppConstants.keyUserId);
  }

  // User Type
  static Future<void> saveUserType(String type) async {
    await instance.setString(AppConstants.keyUserType, type);
  }

  static String? getUserType() {
    return instance.getString(AppConstants.keyUserType);
  }

  // User Name
  static Future<void> saveUserName(String name) async {
    await instance.setString(AppConstants.keyUserName, name);
  }

  static String? getUserName() {
    return instance.getString(AppConstants.keyUserName);
  }

  // Is Logged In
  static Future<void> setLoggedIn(bool value) async {
    await instance.setBool(AppConstants.keyIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return instance.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  // Limpar tudo (logout)
  static Future<void> clearAll() async {
    await instance.clear();
  }
}

