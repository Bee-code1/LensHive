import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController()..load(),
);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController(): super(ThemeMode.system);
  static const _k = 'theme_mode';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(_k);
    state = switch (v) { 
      'light' => ThemeMode.light, 
      'dark' => ThemeMode.dark, 
      _ => ThemeMode.system 
    };
  }

  Future<void> set(ThemeMode m) async {
    state = m;
    final p = await SharedPreferences.getInstance();
    await p.setString(_k, switch (m) { 
      ThemeMode.light => 'light', 
      ThemeMode.dark => 'dark', 
      _ => 'system' 
    });
  }

  Future<void> toggle() => set(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}

