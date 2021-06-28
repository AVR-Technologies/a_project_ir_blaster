import 'package:shared_preferences/shared_preferences.dart';

class Storage{
  static var _prefs = SharedPreferences.getInstance();
  static clear() async => (await _prefs).clear();
  static Future<String> get address => _prefs.then((value) => value.getString('address') ?? '');
  static set address (_address) => _prefs.then((value) => value.setString("address", _address as String));
}