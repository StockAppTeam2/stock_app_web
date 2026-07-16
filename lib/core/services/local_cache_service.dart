import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  Future<void> addStringCache({
    required String key,
    required String value,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString(key, value);
  }

  Future<String> getStringCache({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String value = preferences.getString(key) ?? '';
    return value;
  }
}
