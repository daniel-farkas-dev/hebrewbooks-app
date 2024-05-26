import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hebrewbooks/Providers/back_to_top_provider.dart';
import 'package:hebrewbooks/Providers/search_query_provider.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/book_tile.dart';
import 'package:hebrewbooks/Shared/centered_spinner.dart';
import 'package:provider/provider.dart';

/// A list of [BookTile] widgets.
class BookList extends StatefulWidget {
  const BookList({
    required this.type,
    required this.scrollController,
    super.key,
    this.subjectId,
  }) : assert(
            (type == 'subject' && subjectId != null) || (type == 'search'), '''
subjectId must be provided when type is subject,
type must be search otherwise.''');

  /// The source of the listed books.
  ///
  /// If [type] is 'subject', [subjectId] must be provided.
  /// If [type] is 'search', [subjectId] must not be provided.
  final String type;

  /// The ScrollController of the parent widget.
  final ScrollController scrollController;

  /// The id of the subject.
  ///
  /// Must be provided when [type] is 'subject'.
  final int? subjectId;

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
  static const int _perReq = 15;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (!mounted) return;
      // nextPageTrigger will have a value equivalent to 80% of the list size.
      final nextPageTrigger =
          widget.scrollController.position.maxScrollExtent - 2000;
      if (widget.scrollController.position.pixels >= nextPageTrigger &&
          !_isOver) {
        _isLoading = true;
        _fetchData();
      }
      if (widget.scrollController.position.pixels > 100) {
        Provider.of<BackToTopProvider>(context, listen: false).enabled = true;
      } else {
        Provider.of<BackToTopProvider>(context, listen: false).enabled = false;
      }
    });
    Provider.of<BackToTopProvider>(context, listen: false).addListener(() {
      if (!mounted) return;
      if (Provider.of<BackToTopProvider>(context, listen: false).pressed) {
        widget.scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
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
        return Center(child: _errorDialog(size: 20));
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
                return Center(child: _errorDialog(size: 15));
              } else {
                return null;
              }
            }
            final bookId = _books.elementAt(index);
            if (bookId < 0) {
              return null;
            }
            return BookTile(id: bookId, removeFromSet: _removeFromSet);
          },
        ),
      ),
    );
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
    _fetchData();
  }

  Widget _errorDialog({required double size}) {
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
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _isError = false;
                _fetchData();
              });
            },
            child: const Text(
              'Retry',
              style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    if (_noResults || _isOver || !mounted) {
      debugPrint(
        '''
          fetchData: noResults: $_noResults,
          isOver: $_isOver,
          mounted: $mounted
          ''',
      );
      return;
    }

    var searchQuery = '';
    if (widget.type == 'search') {
      searchQuery =
          Provider.of<SearchQueryProvider>(context, listen: false).searchQuery;
      if (searchQuery.isEmpty || searchQuery.length < 3) return;
    }

    try {
      final List<int> response;
      if (widget.type == 'subject') {
        response =
            await fetchSubjectBooks(widget.subjectId ?? -1, _upTo, _perReq);
      } else {
        response = await fetchSearchBooks(searchQuery, _upTo, _perReq);
      }
      if (response.isEmpty) {
        debugPrint('No results found');
        _isError = true;
        return;
      }
      if (!mounted) return;
      setState((){
        _isError = false;
        _noResults = false;
        _isOver = response.length < _perReq; //TODO: make this fool proof
        _upTo += _perReq;
        for (final book in response) {
          _books.add(book);
        }
      });
    } catch (e) {
      debugPrint('fetchData() failed: $e}');
      if (!mounted) return;
      _isError = true;
    }
    _isLoading = false;
  }

  void _removeFromSet(int id) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _books.remove(id);
        debugPrint('Removed $id from the set');
      });
    });
  }
}
