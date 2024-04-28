import 'package:flutter/foundation.dart';

class BackToTopProvider extends ChangeNotifier {
  bool _enabled = false;
  bool _pressed = false;

  bool get enabled => _enabled;
  bool get pressed => _pressed;

  void setEnabled(bool enabled) {
    _enabled = enabled;
    notifyListeners();
  }

  void press() {
    _pressed = true;
    notifyListeners();
    _pressed = false;
  }
}
