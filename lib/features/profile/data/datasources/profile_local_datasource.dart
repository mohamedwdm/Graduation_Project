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
  static const String cachedProfileKey = 'CACHED_PROFILE';

  ProfileLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheProfile(ProfileModel model) async {
    await _prefs.setString(cachedProfileKey, jsonEncode(model.toJson()));
  }

  @override
  Future<ProfileModel?> getCachedProfile() async {
    final jsonString = _prefs.getString(cachedProfileKey);
    if (jsonString != null) {
      return ProfileModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearProfile() async {
    await _prefs.remove(cachedProfileKey);
  }
}
