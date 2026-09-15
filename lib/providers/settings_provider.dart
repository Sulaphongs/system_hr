import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _keyFontScale = 'font_scale';
  static const double _default = 1.0;
  static const double minScale = 0.75;
  static const double maxScale = 1.50;

  double _fontScale = _default;

  double get fontScale => _fontScale;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getDouble(_keyFontScale) ?? _default;
    _fontScale = saved.clamp(minScale, maxScale);
    notifyListeners();
  }

  Future<void> setFontScale(double scale) async {
    _fontScale = scale.clamp(minScale, maxScale);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontScale, _fontScale);
  }

  Future<void> reset() => setFontScale(_default);
}
