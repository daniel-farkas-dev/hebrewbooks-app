import 'package:flutter/material.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/BookTile.dart';
import 'package:hebrewbooks/Shared/CenteredSpinner.dart';

class BookList extends StatefulWidget {
  final String type;
  final ScrollController scrollController;
  final int? subjectId;
  final String? searchQuery;
  const BookList(
      {super.key,
      required this.type,
      required this.scrollController,
      this.subjectId,
      this.searchQuery})
      : assert((type == 'subject' && subjectId != null) ||
            (type == 'search' && searchQuery != null));

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final List<dynamic> _books = [];
  int _upTo = 1;
  bool _isError = false;
  bool _isLoading = true;
  bool _isOver = false;
  bool _noResults = false;
  static const int perReq = 15;

  @override
  void initState() {
    super.initState();
    fetchData();
    widget.scrollController.addListener(() {
      // nextPageTrigger will have a value equivalent to 80% of the list size.
      var nextPageTrigger =
          widget.scrollController.position.maxScrollExtent - 2000;
      // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
      if (widget.scrollController.position.pixels >= nextPageTrigger &&
          !_isOver) {
        _isLoading = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //TODO: Fix this
    //widget.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_books.isEmpty) {
      if (_isLoading) {
        return const CenteredSpinner();
      } else if (_isError) {
        return Center(child: errorDialog(size: 20));
      } else if (_noResults) {
        return const Center(child: Text('No Results'));
      }
    }
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 72 * _books.length.toDouble(),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _books.length + (_isOver ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _books.length) {
                  if (_isError) {
                    return Center(child: errorDialog(size: 15));
                  } else {
                    return null;
                  }
                }
                final int bookId = int.parse(_books[index]['id'].toString());
                if (bookId < 0) {
                  return null;
                }
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
                  _isLoading = true;
                  _isError = false;
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

  Future<void> fetchData() async {
    if (widget.type == 'search' &&
        (widget.searchQuery == null || widget.searchQuery!.length < 3)) return;
    try {
      final Map<String, dynamic> response;
      if (widget.type == 'subject') {
        int id = widget.subjectId ?? -1;
        response = await fetchSubjectBooks(id, _upTo, perReq);
      } else if (widget.type == 'search') {
        String query = widget.searchQuery ?? '';
        response = await fetchSearchBooks(query, _upTo, perReq);
      } else {
        throw 'Unimplemented BookList type';
      }
      if (response['data'] == null) {
        _noResults = true;
        _isLoading = false;
        return;
      }
      setState(() {
        _noResults = false;
        _isOver = response['data'].length < perReq;
        _isLoading = false;
        _upTo += perReq;
        _books.addAll(response['data']);
      });
    } catch (e) {
      debugPrint('error --> $e');
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }
}
