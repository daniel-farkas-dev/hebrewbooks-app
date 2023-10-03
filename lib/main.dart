import 'package:flutter/material.dart';
import 'package:hebrewbooks/Home/Home.dart';
import 'package:hebrewbooks/Saved/Saved.dart';
import 'package:hebrewbooks/Search/Search.dart';
import 'package:hebrewbooks/Shared/theme.dart';
import 'package:hebrewbooks/Services/icomoon_icons.dart';

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
      appBar: AppBar(
        scrolledUnderElevation: 4.0,
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        shadowColor: Theme.of(context).colorScheme.shadow,
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
                style: Theme.of(context)
                    .textTheme
                    .titleSmall), //TODO: Pull number from API
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
                style:
                    TextStyle(color: lightTheme.colorScheme.onSurfaceVariant)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Switch to עברית')));
            },
          ),
        ],
      ),
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
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        selectedIndex: _selectedIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.onTertiaryContainer),
            icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icomoon.search_filled, color: Theme.of(context).colorScheme.onTertiaryContainer),
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
