import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(var password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setInt("password", password);
  }

  Future readCache(var password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cache = _preferences.getInt("password");
    return cache;
  }

  Future removeCache(var password) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove("password");
  }
}
