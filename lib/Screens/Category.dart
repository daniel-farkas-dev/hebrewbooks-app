import 'package:flutter/material.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/BookList.dart';
import 'package:hebrewbooks/Shared/BookTile.dart';
import 'package:hebrewbooks/Shared/CenteredSpinner.dart';

class Category extends StatefulWidget {
  final int id;
  final String name;

  const Category({super.key, required this.id, required this.name});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
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
            BookList(
              type: 'subject',
              scrollController: scrollController,
              subjectId: widget.id,
            ),
          ],
        ),
      ),
    );
  }
}
//TODO: Prune the non-loading books?
