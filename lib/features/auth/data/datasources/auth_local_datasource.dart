import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go2car/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
  Future<void> cacheToken(String token);
  String? getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  static const _kUserKey = 'CACHED_USER';
  static const _kTokenKey = 'AUTH_TOKEN';

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_kUserKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _prefs.getString(_kUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_kUserKey);
  }

  @override
  Future<void> cacheToken(String token) async {
    await _prefs.setString(_kTokenKey, token);
  }

  @override
  String? getToken() {
    return _prefs.getString(_kTokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_kTokenKey);
  }
}
