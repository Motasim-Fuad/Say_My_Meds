import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = "access_token";
  static const String _rememberMeKey = "remember_me";

  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final safeToken = token.trim();
      await prefs.setString(_tokenKey, safeToken);
      print("✅ StorageHelper: Token saved");
      print("✅ Token length: ${safeToken.length}");
      print("✅ Token preview: ${safeToken.substring(0, safeToken.length > 30 ? 30 : safeToken.length)}...");
    } catch (e) {
      print("❌ StorageHelper: Error saving token - $e");
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      print("📦 StorageHelper: getToken called");
      print("📦 Token exists: ${token != null ? 'YES' : 'NO'}");
      if (token != null) {
        print("📦 Token length: ${token.length}");
      }
      return token;
    } catch (e) {
      print("❌ StorageHelper: Error getting token - $e");
      return null;
    }
  }

  static Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      print("🗑️ StorageHelper: Token cleared");
    } catch (e) {
      print("❌ StorageHelper: Error clearing token - $e");
    }
  }

  // Save remember me preference
  static Future<void> saveRememberMe(bool remember) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, remember);
      print("✅ StorageHelper: Remember me saved = $remember");
    } catch (e) {
      print("❌ StorageHelper: Error saving remember me - $e");
    }
  }

  // Get remember me preference
  static Future<bool> getRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      print("❌ StorageHelper: Error getting remember me - $e");
      return false;
    }
  }

  // Clear all data (for logout)
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_rememberMeKey);
      print("🗑️ StorageHelper: All data cleared");
    } catch (e) {
      print("❌ StorageHelper: Error clearing all data - $e");
    }
  }
}