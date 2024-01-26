import 'package:flutter/material.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/CenteredSpinner.dart';

class Category extends StatefulWidget {
  final int id;
  final String name;

  const Category({super.key, required this.id, required this.name});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late Future<Map<String, dynamic>> items;
  late List<dynamic> d;
  static const perPage = 10;

  @override
  void initState() {
    super.initState();
    items = fetchSubjectBooks(widget.id, 1, perPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: FutureBuilder<Map<String, dynamic>>(
        future: items,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            d = snapshot.data!['data'];
            return SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(
                      scrolledUnderElevation: 4.0,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      title: Text(widget.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      centerTitle: false,
                    ),
                    //TODO: Build a reusable widget that takes a book object and returns a ListTile; can be used for search results and category
                  ]),
            );
          } else {
            return const CenteredSpinner();
          }
        },
      ),
    );
  }
}
