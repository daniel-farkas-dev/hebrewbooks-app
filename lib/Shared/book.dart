class Book {
  final int id;
  final String title;
  final String author;
  final String city;
  final String year;
  final int pages;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.city,
    required this.year,
    required this.pages,
  });

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        author = json['author'] as String,
        city = json['city'] as String,
        year = json['year'] as String,
        pages = json['pages'] as int;
}
//TODO: Auto reformat the author to remove the comma
//TODO: Convert the year
//TODO: Properly handle missing data