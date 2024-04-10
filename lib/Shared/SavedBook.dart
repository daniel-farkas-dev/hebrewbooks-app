import 'package:hebrewbooks/Shared/Book.dart';

class SavedBook extends Book {
  final bool downloaded;

  const SavedBook(
      {required super.id,
      required super.title,
      required super.author,
      required super.pages,
      super.city,
      super.year,
      required this.downloaded});

  SavedBook.fromJson(Map<String, dynamic> json)
      : downloaded = json['downloaded'] as bool,
        super(
          id: json['id'] as int,
          title: json['title'] as String,
          author: json['author'] as String,
          city: json['city'],
          year: json['year'],
          pages: json['pages'] as int,
        );
}
