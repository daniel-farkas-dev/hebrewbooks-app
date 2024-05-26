import 'package:hebrewbooks/Shared/book.dart';

/// A class that represents a book that has been saved for easy access.
class SavedBook extends Book {
  const SavedBook({
    required super.id,
    required super.title,
    required super.author,
    required super.pages,
    required this.downloaded,
    super.city,
    super.rawYear,
  });

  /// Creates a [SavedBook] from json.
  SavedBook.fromJson(Map<String, dynamic> json)
      : downloaded = json['downloaded'] as bool,
        super(
          id: json['id'] as int,
          title: json['title'] as String,
          author: json['author'] as String,
          city: json['city'] as String?,
          rawYear: json['year'] as String?,
          pages: json['pages'] as int,
        );

  /// Creates a [SavedBook] from a [Book].
  SavedBook.fromBook(Book book, {required this.downloaded})
        : super(
          id: book.id,
          title: book.title,
          author: book.author,
          city: book.city,
          rawYear: book.rawYear,
          pages: book.pages,
        );


  /// Whether the book has been downloaded to the device.
  final bool downloaded;

  /// Converts this [SavedBook] to json.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'city': city,
        'year': rawYear,
        'pages': pages,
        'downloaded': downloaded,
      };
}
