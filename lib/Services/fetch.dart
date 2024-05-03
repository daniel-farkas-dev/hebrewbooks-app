import 'dart:convert';
import 'dart:io' show Platform;

import 'package:hebrewbooks/Shared/book.dart';
import 'package:hebrewbooks/Shared/subject.dart';
import 'package:http/http.dart' as http;

/// The api endpoint for fetching book information.
const _infoUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=book_info&callback=callback';

/// The api endpoint for fetching book page images.
///
/// This should only be used for fetching the cover image.
const imageUrl = 'https://beta.hebrewbooks.org/reader/pagepngs/';

/// The api endpoint for fetching the list of subjects.
const subjectsUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=subject_list&type=subject&callback=callback';

/// The api endpoint for fetching the list of books in a subject.
const topicsUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=title_list_for_subject&list_type=subject&callback=callback';

/// The api endpoint for searching for books.
const searchUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?author_search=&callback=callback';

/// The api key for iOS.
const iosKey = '/*ios api key*/';

/// The api key for Android and Fuchsia.
const androidKey = '/*android api key*/';

/// Extracts the JSON string from [jsonp].
String extractJsonFromJsonp(String jsonp) {
  // Define the regex pattern to match the JSON within setBookInfo callback
  final regex = RegExp(r'callback\((.*?)\);');

  // Find the first match of the pattern
  final match = regex.firstMatch(jsonp);

  if (match != null) {
    // Extract the JSON string from the match
    return match.group(1) != null ? match.group(1)! : '';
  } else {
    throw Exception('No match found; JSONP callback not removed');
  }
}

/// Fetches the book info with the given [id].
Future<Book> fetchInfo(int id) async {
  var url = _infoUrl;
  if (Platform.isAndroid || Platform.isFuchsia) {
    url += '$androidKey&id=$id';
  } else if (Platform.isIOS) {
    url += '$iosKey&id=$id';
  } else {
    throw Exception('Unsupported platform- API key unknown');
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final trueJson = extractJsonFromJsonp(response.body);
    try {
      return Book.fromJson(jsonDecode(trueJson) as Map<String, dynamic>);
    } on FormatException {
      throw FormatException('Failed to parse JSON: $trueJson');
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    if (response.statusCode == 500) {
      return fetchInfo(id);
    }
    throw Exception('Failed to load album');
  }
}

/// Fetches the list of subjects.
Future<List<Subject>> fetchSubjects() async {
  var url = subjectsUrl;
  if (Platform.isAndroid || Platform.isFuchsia) {
    url += androidKey;
  } else if (Platform.isIOS) {
    url += iosKey;
  } else {
    throw Exception('Unsupported platform- API key unknown');
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Subject.fromJsonList(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

/// Returns the URL for the cover image of the book with the given [id].
String coverUrl(int id, int width, int height) {
  var url = imageUrl;
  url += '${id}_1_${width}_$height.png?';
  if (Platform.isAndroid || Platform.isFuchsia) {
    url += androidKey;
  } else if (Platform.isIOS) {
    url += iosKey;
  } else {
    throw Exception('Unsupported platform- API key unknown');
  }
  return url;
}

/// Fetches the list of books in the subject with the given [id].
Future<Map<String, dynamic>> fetchSubjectBooks(
  int id,
  int start,
  int length,
) async {
  var url = topicsUrl;
  url += '&id=$id&start=$start&length=$length';
  if (Platform.isAndroid || Platform.isFuchsia) {
    url += androidKey;
  } else if (Platform.isIOS) {
    url += iosKey;
  } else {
    throw Exception('Unsupported platform- API key unknown');
  }
  final res = await http.read(Uri.parse(url));
  return jsonDecode(extractJsonFromJsonp(res)) as Future<Map<String, dynamic>>;
}

/// Fetches the list of books with the given search [query].
Future<Map<String, dynamic>> fetchSearchBooks(
  String query,
  int start,
  int length,
) async {
  var url = searchUrl;
  url += '&title_search=$query&start=$start&length=$length';
  if (Platform.isAndroid || Platform.isFuchsia) {
    url += androidKey;
  } else if (Platform.isIOS) {
    url += iosKey;
  } else {
    throw Exception('Unsupported platform- API key unknown');
  }
  final res = await http.read(Uri.parse(url));
  final json = extractJsonFromJsonp(res);
  if (json == '') {
    return {};
  }
  return jsonDecode(json) as Future<Map<String, dynamic>>;
}
