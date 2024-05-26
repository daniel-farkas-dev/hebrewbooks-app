import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hebrewbooks/Shared/saved_book.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider to handle the locally saved books.
class SavedBooksProvider extends ChangeNotifier {

  /// Initializes the saved books provider loading the books initially.
  SavedBooksProvider() {
    loadSavedBooks().then((_) {
      notifyListeners();
    });
  }

  List<SavedBook> _savedBooks = [];

  /// The list of saved books.
  List<SavedBook> get savedBooks => _savedBooks;

  /// Gets the list of saved books as strings from local storage.
  Future<List<String>> _getSavedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('savedBooks') ?? [];
  }

  /// Loads the saved books from local storage and notifies listeners.
  Future<void> loadSavedBooks() async {
    final savedBooks = await _getSavedBooks();
    _savedBooks = savedBooks.map((bookJson) {
      final book = jsonDecode(bookJson) as Map<String, dynamic>;
      return SavedBook.fromJson(book);
    }).toList();
    notifyListeners();
  }

  /// Saves a book to local storage.
  Future<void> saveBook(SavedBook book) async {
    final prefs = await SharedPreferences.getInstance();
    final savedBooks = await _getSavedBooks()
      ..add(jsonEncode(book.toJson()));
    await prefs.setStringList('savedBooks', savedBooks);
    await loadSavedBooks();
  }

  /// Removes a book from local storage.
  Future<void> removeBook(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final savedBooks = await _getSavedBooks();
    savedBooks.removeWhere((bookJson) {
      final book = jsonDecode(bookJson) as Map<String, dynamic>;
      return book['id'] == id;
    });
    await prefs.setStringList('savedBooks', savedBooks);
    await loadSavedBooks();
  }

  /// Checks if a book is saved.
  Future<bool> isBookSaved(int id) async {
    final savedBooks = await _getSavedBooks();
    return savedBooks.any((bookJson) {
      final book = jsonDecode(bookJson) as Map<String, dynamic>;
      return book['id'] == id;
    });
  }
}
