import 'package:hebrewbooks/Shared/book.dart';

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

  SavedBook.fromJson(Map<String, dynamic> json)
      : downloaded = json['downloaded'] as bool,
        super(
          id: json['id'] as int,
          title: json['title'] as String,
          author: json['author'] as String,
          city: json['city'] as String,
          rawYear: json['year'] as String,
          pages: json['pages'] as int,
        );
  final bool downloaded;
}
