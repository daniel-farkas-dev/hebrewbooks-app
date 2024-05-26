import 'package:flutter/material.dart';
import 'package:hebrewbooks/Providers/back_to_top_provider.dart';
import 'package:hebrewbooks/Providers/saved_books_provider.dart';
import 'package:hebrewbooks/Providers/search_query_provider.dart';
import 'package:hebrewbooks/Screens/home.dart';
import 'package:hebrewbooks/Screens/saved.dart';
import 'package:hebrewbooks/Screens/search.dart';
import 'package:hebrewbooks/Shared/back_to_top.dart';
import 'package:hebrewbooks/Shared/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SavedBooksProvider()),
        ChangeNotifierProvider(create: (context) => BackToTopProvider()),
        ChangeNotifierProvider(create: (context) => SearchQueryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// The root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HebrewBooks',
      theme: lightTheme,
      home: const MainPage(),
    );
  }
}

/// The main page of [MyApp]- it contains home, search and saved routes.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
            selectedIcon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
            icon: Icon(
              Icons.home_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
            icon: Icon(
              Icons.search_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
            icon: Icon(
              Icons.star_outline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Saved',
          ),
        ],
      ),
      floatingActionButton: BackToTop(route: _selectedIndex),
    );
  }
}
