import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hebrewbooks/Providers/BackToTopProvider.dart';
import 'package:hebrewbooks/Providers/SearchQueryProvider.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/BookTile.dart';
import 'package:hebrewbooks/Shared/CenteredSpinner.dart';
import 'package:provider/provider.dart';

class BookList extends StatefulWidget {
  final String type;
  final ScrollController scrollController;
  final int? subjectId;
  const BookList({
    super.key,
    required this.type,
    required this.scrollController,
    this.subjectId,
  }) : assert((type == 'subject' && subjectId != null) || (type == 'search'));

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final Set<int> _books = {};
  int _upTo = 1;
  bool _isError = false;
  bool _isLoading = true;
  bool _isOver = false;
  bool _noResults = false;
  static const int perReq = 15;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (!mounted) return;
      // nextPageTrigger will have a value equivalent to 80% of the list size.
      var nextPageTrigger =
          widget.scrollController.position.maxScrollExtent - 2000;
      // _scrollController fetches the next paginated data when the current postion of the user on the screen has surpassed
      if (widget.scrollController.position.pixels >= nextPageTrigger &&
          !_isOver) {
        _isLoading = true;
        fetchData();
      }
      if (widget.scrollController.position.pixels > 100) {
        Provider.of<BackToTopProvider>(context, listen: false).setEnabled(true);
      } else {
        Provider.of<BackToTopProvider>(context, listen: false).setEnabled(false);
      }
    });
    // When pressed changes to true, the scrollController will animate to the top of the list.
    Provider.of<BackToTopProvider>(context, listen: false).addListener(() {
      if (!mounted) return;
      if (Provider.of<BackToTopProvider>(context, listen: false).pressed) {
        widget.scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'search') context.watch<SearchQueryProvider>();
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
                final int bookId = _books.elementAt(index);
                if (bookId < 0) {
                  return null;
                }
                return BookTile(id: bookId, removeFromSet: removeFromSet);
              }),
        ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isOver = false;
    _noResults = false;
    _isLoading = true;
    _isError = false;
    _books.clear();
    _upTo = 1;
    fetchData();
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

  void fetchData() async {
    if (_noResults || _isOver || !mounted) {
      debugPrint(
          'fetchData: noResults: $_noResults, isOver: $_isOver, mounted: $mounted');
      return;
    }

    String searchQuery = '';
    if (widget.type == 'search') {
      searchQuery = Provider.of<SearchQueryProvider>(context, listen: false)
              .searchQuery ??
          '';
      if (searchQuery.isEmpty || searchQuery.length < 3) return;
    }

    try {
      final Map<String, dynamic> response = widget.type == 'subject'
          ? await fetchSubjectBooks(widget.subjectId ?? -1, _upTo, perReq)
          : await fetchSearchBooks(searchQuery, _upTo, perReq);

      if (response['data'] == null) {
        _noResults = true;
      } else {
        if (!mounted) return;
        setState(() {
          _noResults = false;
          _isOver = response['data'].length < perReq;
          _upTo += perReq;
          for (var book in response['data']) {
            _books.add(int.parse(book['id'].toString()));
          }
        });
      }
    } catch (e) {
      debugPrint('fetchData() failed: $e');
      if (!mounted) return;
      _isError = true;
    }
    _isLoading = false;
  }

  void removeFromSet(int id) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _books.remove(id);
        debugPrint('Removed $id from the set');
      });
    });
  }
}
