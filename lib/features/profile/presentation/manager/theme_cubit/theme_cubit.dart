import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_preference';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeValue = _prefs.getString(_themeKey);
    if (themeValue == 'light') {
      emit(ThemeMode.light);
    } else if (themeValue == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  void setThemeMode(ThemeMode mode) async {
    emit(mode);
    await _prefs.setString(_themeKey, mode.name);
  }
}
