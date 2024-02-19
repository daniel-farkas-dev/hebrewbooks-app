import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchQueryProvider(),
      child: Builder(
        builder: (contextWithProvider) {
          return Container(
            height: MediaQuery.of(contextWithProvider).size.height,
            color: Theme.of(contextWithProvider).colorScheme.secondaryContainer,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppBar(
                    title: _isSearching
                        ? _buildSearchField(contextWithProvider)
                        : _buildTitle(contextWithProvider),
                    actions: _buildActions(contextWithProvider),
                  ),
                  _buildPageView(contextWithProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(BuildContext contextWithProvider) {
    return TextField(
      focusNode: _focusNode,
      controller: _searchQueryController,
      decoration: InputDecoration(
        hintText: 'Search Data...',
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Theme.of(contextWithProvider).colorScheme.onSurfaceVariant),
      ),
      style: TextStyle(
          color: Theme.of(contextWithProvider).colorScheme.onSurface,
          fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query, contextWithProvider),
    );
  }

  void updateSearchQuery(String newQuery, BuildContext context) {
    Provider.of<SearchQueryProvider>(context, listen: false)
        .setSearchQuery(newQuery);
  }

  Widget _buildPageView(BuildContext contextWithProvider) {
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
                              updateSearchQuery(history[index], contextWithProvider);
                              _startSearch(contextWithProvider, false);
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

  List<Widget> _buildActions(BuildContext contextWithProvider) {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
            _clearSearchQuery(contextWithProvider);
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => _startSearch(contextWithProvider),
      ),
    ];
  }

  void _startSearch(BuildContext contextWithProvider, [bool focus = true]) {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: () => _stopSearching(contextWithProvider)));

    setState(() {
      _isSearching = true;
    });
    if (focus) _focusNode.requestFocus();
  }

  void _stopSearching(BuildContext contextWithProvider) {
    _clearSearchQuery(contextWithProvider);

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery(BuildContext contextWithProvider) {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('', contextWithProvider);
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