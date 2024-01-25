import 'dart:convert';

import 'package:hebrewbooks/Services/fetch.dart';

class Subject {
  final int id;
  final String name;
  final int total;

  const Subject({
    required this.id,
    required this.name,
    required this.total,
  });

  Subject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        total = json['total'] as int;

  static List<Subject> fromJsonList(String json) {
    final trueJson = extractJsonFromJsonp(json);
    final jsonList = jsonDecode(trueJson) as List<dynamic>;
    final subjects = <Subject>[];
    for (final json in jsonList) {
      subjects.add(Subject.fromJson(json as Map<String, dynamic>));
    }
    subjects.add(const Subject(id: -1, name: 'Less', total: -1));
    return subjects;
  }
}