import 'package:flutter/material.dart';
import 'package:hebrewbooks/Services/fetch.dart';
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
  bool loading = true;
  late bool isLastPage;
  late int upTo = 1;
  late bool isError = false;
  late bool isLoading = true;
  late bool isOver = false;
  static const int perReq = 15;
  late List<dynamic> books = [];
  final int trigger = 3;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {
      // nextPageTrigger will have a value equivalent to 80% of the list size.
      var nextPageTrigger = 0.8 * scrollController.position.maxScrollExtent;
      // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
      if (scrollController.position.pixels >= nextPageTrigger &&
          !isLoading &&
          !isOver) {
        isLoading = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SingleChildScrollView(
        controller: scrollController,
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
            BuildPostsView(),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await fetchSubjectBooks(widget.id, upTo, perReq);

      setState(() {
        isOver = response['data'].length < perReq;
        isLoading = false;
        upTo += perReq;
        books.addAll(response['data']);
      });
    } catch (e) {
      debugPrint('error --> $e');
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Widget BuildPostsView() {
    if (books.isEmpty) {
      if (isLoading) {
        return const CenteredSpinner();
      } else if (isError) {
        return Center(child: errorDialog(size: 20));
      }
    }
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 82 * books.length.toDouble(),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: books.length + (isOver ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == books.length) {
                  if (isError) {
                    return Center(child: errorDialog(size: 15));
                  } else {
                    return const CenteredSpinner(size: 82);
                  }
                }
                final int bookId = books[index]['id'] as int;
                return BookTile(id: bookId);
              }),
        ));
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the books.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  isError = false;
                  fetchData();
                });
              },
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }
}
//TODO: Check that the end detection works
//TODO: Prune the non-loading books