import 'package:flutter/foundation.dart';

/// Provider that provides the search query.
class SearchQueryProvider extends ChangeNotifier {
  String _searchQuery = '';

  /// The current search query.
  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }
}
