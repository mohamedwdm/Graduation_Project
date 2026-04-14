import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(ProfileModel model);
  Future<ProfileModel?> getCachedProfile();
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences _prefs;
  static const String _profileKey = 'CACHED_PROFILE';

  ProfileLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheProfile(ProfileModel model) async {
    await _prefs.setString(_profileKey, jsonEncode(model.toJson()));
  }

  @override
  Future<ProfileModel?> getCachedProfile() async {
    final jsonStr = _prefs.getString(_profileKey);
    if (jsonStr != null) {
      return ProfileModel.fromJson(jsonDecode(jsonStr));
    }
    return null;
  }

  @override
  Future<void> clearProfile() async {
    await _prefs.remove(_profileKey);
  }
}
