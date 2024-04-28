import 'package:flutter/material.dart';
import 'package:hebrewbooks/Providers/BackToTopProvider.dart';
import 'package:hebrewbooks/Providers/SearchQueryProvider.dart';
import 'package:hebrewbooks/Shared/BookList.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  ScrollController scrollController = ScrollController();
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  final String? hintText = 'Search Data';
  final FocusNode _focusNode= FocusNode();

  static const history = [
    'אגרות משה',
    'לקוטי אמרים תניא',
    'גור אריה יהודה',
    'רבינו בחיי',
    'אורחות חיים',
  ];

  @override
  void dispose() {
    scrollController.dispose();
    _searchQueryController.dispose();
    super.dispose();
  }
  //TODO: Dispose of BookLst; currently if you switch back, the list is still there

  @override
  void initState() {
    super.initState();
      Provider.of<BackToTopProvider>(context, listen: false).setEnabled(false);
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
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query, context),
    );
  }

  void updateSearchQuery(String newQuery, BuildContext context) {
    Provider.of<SearchQueryProvider>(context, listen: false)
        .setSearchQuery(newQuery);
  }

  Widget _buildPageView(BuildContext context) {
    return Consumer<SearchQueryProvider>(
      builder: (context, searchQueryProvider, child) {
        final searchQuery = searchQueryProvider.searchQuery;
        if (searchQuery.length < 3) {
          return SizedBox(
            height: history.length * 56.0,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(history[index]),
                          onTap: () {
                            setState(() {
                              _searchQueryController.text = history[index];
                              updateSearchQuery(history[index], context);
                              _startSearch(context, false);
                            });
                          },
                          trailing: const Icon(Icons.history),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 1,
                        )
                      ],
                    );
                  },
                  itemCount: history.length),
            ),
          );
        }
        debugPrint('Rebuilding search list $searchQuery');
        return BookList(
          type: 'search',
          scrollController: scrollController,
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
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: () => _stopSearching(context)));

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

  _buildTitle(BuildContext context) {
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