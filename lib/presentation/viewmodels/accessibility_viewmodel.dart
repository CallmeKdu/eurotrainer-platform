import 'package:flutter/material.dart';

class AccessibilityViewModel extends ChangeNotifier {
  double _fontSizeFactor = 1.0;
  bool _isHighContrast = false;

  double get fontSizeFactor => _fontSizeFactor;
  bool get isHighContrast => _isHighContrast;

  void setFontSizeFactor(double factor) {
    if (_fontSizeFactor != factor) {
      _fontSizeFactor = factor.clamp(0.8, 1.5);
      notifyListeners();
    }
  }

  void toggleHighContrast(bool value) {
    if (_isHighContrast != value) {
      _isHighContrast = value;
      notifyListeners();
    }
  }
}
