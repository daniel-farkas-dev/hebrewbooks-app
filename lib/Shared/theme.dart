import 'package:flutter/material.dart';

var seed = const Color.fromRGBO(252, 88, 5, 1.0);
var lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
  useMaterial3: true,
);