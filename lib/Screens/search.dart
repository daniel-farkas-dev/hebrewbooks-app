import 'package:flutter/material.dart';
import 'package:hebrewbooks/Providers/back_to_top_provider.dart';
import 'package:hebrewbooks/Providers/search_query_provider.dart';
import 'package:hebrewbooks/Shared/book_list.dart';
import 'package:provider/provider.dart';

/// The search screen of the application.
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  final FocusNode _focusNode = FocusNode();

  static const _history = [
    'אגרות משה',
    'לקוטי אמרים תניא',
    'גור אריה יהודה',
    'רבינו בחיי',
    'אורחות חיים',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchQueryController.dispose();
    super.dispose();
  }

  //TODO: Dispose of BookLst; rn if you switch back, the list is still there

  @override
  void initState() {
    super.initState();
    Provider.of<BackToTopProvider>(context, listen: false).enabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              title: _isSearching
                  ? _buildSearchField(context)
                  : _buildTitle(context),
              actions: _buildActions(context),
            ),
            _buildPageView(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: _searchQueryController,
      decoration: InputDecoration(
        hintText: 'Search Data...',
        border: InputBorder.none,
        hintStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      onChanged: (query) => updateSearchQuery(query, context),
    );
  }

  void updateSearchQuery(String newQuery, BuildContext context) {
    Provider.of<SearchQueryProvider>(context, listen: false).searchQuery =
        newQuery;
  }

  Widget _buildPageView(BuildContext context) {
    return Consumer<SearchQueryProvider>(
      builder: (context, searchQueryProvider, child) {
        final searchQuery = searchQueryProvider.searchQuery;
        if (searchQuery.length < 3) {
          return SizedBox(
            height: _history.length * 56.0,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_history[index]),
                        onTap: () {
                          setState(() {
                            _searchQueryController.text = _history[index];
                            updateSearchQuery(_history[index], context);
                            _startSearch(context, false);
                          });
                        },
                        trailing: const Icon(Icons.history),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 1,
                      ),
                    ],
                  );
                },
                itemCount: _history.length,
              ),
            ),
          );
        }
        debugPrint('Rebuilding search list $searchQuery');
        return BookList(
          type: 'search',
          scrollController: _scrollController,
        );
      },
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
            _clearSearchQuery(context);
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => _startSearch(context),
      ),
    ];
  }

  void _startSearch(BuildContext context, [bool focus = true]) {
    ModalRoute.of(context)?.addLocalHistoryEntry(
      LocalHistoryEntry(
        onRemove: () => _stopSearching(context),
      ),
    );

    setState(() {
      _isSearching = true;
    });
    if (focus) _focusNode.requestFocus();
  }

  void _stopSearching(BuildContext context) {
    _clearSearchQuery(context);

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery(BuildContext context) {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('', context);
    });
  }

  Widget _buildTitle(BuildContext context) {
    return InkWell(
      onTap: () {
        _startSearch(context);
      },
      child: Text(
        'Search HebrewBooks',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
