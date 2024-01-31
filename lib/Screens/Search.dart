import 'package:flutter/material.dart';
import 'package:hebrewbooks/Shared/BookList.dart';

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
  String searchQuery = '';

  //TODO: Pull from history
  static const history = [
    'אגרות משה',
    'לקוטי אמרים תניא',
    'גור אריה יהודה',
    'רבינו בחיי',
    'אורחות חיים',
  ];

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
              title: _isSearching ? _buildSearchField() : _buildTitle(context),
              actions: _buildActions(),
            ),
            _buildPageView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
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
                        //TODO: Go to search mode; set text to query
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
    return BookList(type: 'search', scrollController: scrollController, searchQuery: searchQuery);
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search Data...',
        border: InputBorder.none,
        hintStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  _buildTitle(BuildContext context) {
    return InkWell(
      onTap: () {
        _startSearch();
      },
      child: Text(
        'Search HebrewBooks',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
