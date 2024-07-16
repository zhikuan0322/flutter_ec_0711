import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static late SharedPreferences _sharedPreferences;

  static initSharePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static String? getJwt() {
    return _sharedPreferences.getString("jwt");
  }

  static setJwt(String? jwt) async {
    if (jwt == null) {
      await _sharedPreferences.remove("jwt");
    } else {
      await _sharedPreferences.setString("jwt", jwt);
    }
  }
}