import 'package:flutter/material.dart';
import 'package:hebrewbooks/Screens/Home.dart';
import 'package:hebrewbooks/Screens/Saved.dart';
import 'package:hebrewbooks/Screens/Search.dart';
import 'package:hebrewbooks/Shared/Theme.dart';

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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const Home(),
        const Search(),
        const Saved(),
      ][_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.tertiaryContainer,
        selectedIndex: _selectedIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.onTertiaryContainer),
            icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onTertiaryContainer),
            icon: Icon(Icons.search_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.star, color: Theme.of(context).colorScheme.onTertiaryContainer),
            icon: Icon(Icons.star_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
