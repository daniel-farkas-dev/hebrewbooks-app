import 'dart:convert';
import 'dart:io' show Platform;

import 'package:hebrewbooks/Shared/book.dart';
import 'package:http/http.dart' as http;

const bookUrl =
    'https://beta.hebrewbooks.org/api/api.ashx?req=book_info&callback=callback';
const imageUrl = 'https://beta.hebrewbooks.org/reader/pagepngs/';
const iosKey = '/*ios api key*/';
const androidKey = '/*android api key*/';

String extractJsonFromJsonp(String jsonp) {
  // Define the regex pattern to match the JSON within setBookInfo callback
  final regex = RegExp(r'callback\((.*?)\);');

  // Find the first match of the pattern
  final match = regex.firstMatch(jsonp);

  if (match != null) {
    // Extract the JSON string from the match
    return match.group(1) != null ? match.group(1)! : '';
  } else {
    return '';
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
    if (trueJson == '') {
      throw Exception('No match found; JSONP callback not removed');
    }
    return Book.fromJson(jsonDecode(trueJson) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

String coverUrl(int id, int width, int height) {
  var url = imageUrl;
  url += '$id\_1\_$width\_$height\.png';
  /*if (Platform.isAndroid || Platform.isFuchsia) {
    url += androidKey;
  } else if (Platform.isIOS) {
    url += iosKey;
  } else {
    throw Exception('Unsupported platform- API key unknown');
  }*/
  return url;
}
