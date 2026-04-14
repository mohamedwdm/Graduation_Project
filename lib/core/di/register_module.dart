import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterModule {
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  Connectivity get connectivity => Connectivity();
}
