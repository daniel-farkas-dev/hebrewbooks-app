import 'package:flutter/foundation.dart';

/// Provider to handle the back to top button.
class BackToTopProvider extends ChangeNotifier {
  bool _enabled = false;
  bool _pressed = false;

  /// Weather the button should be shown or not.
  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;
    notifyListeners();
  }

  /// Weather the button is pressed or not.
  bool get pressed => _pressed;

  /// Update the button state to pressed, notify listeners, and reset the state.
  void press() {
    _pressed = true;
    notifyListeners();
    _pressed = false;
  }
}
