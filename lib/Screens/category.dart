import 'package:flutter/material.dart';
import 'package:hebrewbooks/Shared/back_to_top.dart';
import 'package:hebrewbooks/Shared/book_list.dart';

class Category extends StatefulWidget {
  const Category({required this.id, required this.name, super.key});

  final int id;
  final String name;

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
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 4,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shadowColor: Theme.of(context).colorScheme.shadow,
          title: Text(
            widget.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BookList(
                type: 'subject',
                scrollController: scrollController,
                subjectId: widget.id,
              ),
            ],
          ),
        ),
        floatingActionButton: const BackToTop(),
      ),
    );
  }
}
