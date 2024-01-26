import 'package:flutter/material.dart';

class SearchBarFull extends StatefulWidget {
  const SearchBarFull({super.key, this.hintText});

  final String? hintText;
  @override
  State<SearchBarFull> createState() => _SearchBarFullState();
}

class _SearchBarFullState extends State<SearchBarFull> {
  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = 'Search query';
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching ? _buildSearchField() : _buildTitle(context),
      actions: _buildActions(),
    );
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
        widget.hintText ?? 'Search',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
//TODO: Fix this mess