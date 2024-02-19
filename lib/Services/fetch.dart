import 'dart:convert';
import 'dart:io' show Platform;

import 'package:hebrewbooks/Shared/book.dart';
import 'package:hebrewbooks/Shared/subject.dart';
import 'package:http/http.dart' as http;

const bookUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=book_info&callback=callback';
const imageUrl = 'https://beta.hebrewbooks.org/reader/pagepngs/';
const subjectsUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=subject_list&type=subject&callback=callback';
const topicsUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=title_list_for_subject&list_type=subject&callback=callback';
const searchUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?author_search=&callback=callback';

const iosKey = '/*ios api key*/';
const androidKey = '/*android api key*/';

//TODO: Become consistent about passing json (String v Map)

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

Future<Book> fetchBook(int id) async {
  var url = bookUrl;
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
      final json = jsonDecode(trueJson) as Map<String, dynamic>;
      return Book.fromJson(jsonDecode(trueJson) as Map<String, dynamic>);
    } on FormatException {
      throw FormatException('Failed to parse JSON: $trueJson');
    }
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    if (response.statusCode == 500) {
      return fetchBook(id);
    }
    throw Exception('Failed to load album');
  }
}

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

Future<Map<String, dynamic>> fetchSubjectBooks(
    int id, int start, int length) async {
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
  return jsonDecode(extractJsonFromJsonp(res));
}

Future<Map<String, dynamic>> fetchSearchBooks(
    String query, int start, int length) async {
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
  return jsonDecode(json);
}
