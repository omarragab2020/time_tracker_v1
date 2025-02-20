import 'package:shared_preferences/shared_preferences.dart';

class OfflineHelper {
  static const String USERKEY = 'USER_KEY';
  static SharedPreferences? instance;
  OfflineHelper() {
    init();
  }
  void init() async {
    instance = await SharedPreferences.getInstance();
  }

  Future<void> saveUser(User) async {
    instance?.setString(USERKEY, 'value');
  }

  static Future<String?> getUser() async {
    return instance?.getString(USERKEY);
  }
}
