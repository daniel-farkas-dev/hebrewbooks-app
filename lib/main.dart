import 'package:flutter/material.dart';
import 'package:hebrewbooks/Shared/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HebrewBooks',
      theme: lightTheme,
      home: const MainPage(title: 'HebrewBooks'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      scrolledUnderElevation: 4.0,
      shadowColor: lightTheme.colorScheme.shadow,
      leading: SizedBox(
        width: 48.0,
        height: 48.0,
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            'images/logo.png',
            width: 24.0,
            height: 24.0,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
      ),
      title: Column(
        children: <Widget>[
          Text('HebrewBooks', style: Theme.of(context).textTheme.titleLarge),
          Text('63,016 Hebrew Books',
              style: Theme.of(context).textTheme.titleSmall),
              //TODO: Pull number from API
        ],
      ),
      centerTitle: true,
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            fixedSize: const Size(48.0, 48.0),
            textStyle: const TextStyle(
              fontSize: 24.0,
              height: 1.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          child: Text('א',
              style: TextStyle(color: lightTheme.colorScheme.onSurfaceVariant)),
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Switch to עברית')));
          },
        ),
      ],
    ));
  }
}
