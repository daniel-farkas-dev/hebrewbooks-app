import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hebrewbooks/Screens/info.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/book.dart';
import 'package:hebrewbooks/Shared/centered_spinner.dart';

class BookTile extends StatefulWidget {

  const BookTile({required this.id, required this.removeFromSet, super.key});
  final int id;
  final Function removeFromSet;

  @override
  State<BookTile> createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  late Future<Book>? book;
  bool _isError = false;
  int _reloaded = 0;

  static const int imageHeight = 56;

  @override
  void initState() {
    super.initState();
    book = _safeFetchBook(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      widget.removeFromSet(widget.id);
      return const SizedBox.shrink();
    }
    return FutureBuilder(
      future: book,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          _errorHandler(snapshot.error);
        }
        if (snapshot.hasData) {
          return Material(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              title: Text(
                snapshot.data!.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                snapshot.data!.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              //TODO: Make the overflow less ugly
              trailing: Image.network(
                coverUrl(snapshot.data!.id, 100, 100),
                height: imageHeight.toDouble(),
                fit: BoxFit.fitHeight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const CenteredSpinner(
                    size: imageHeight ~/ 2,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint('Error: $error');
                  return SizedBox(
                    height: imageHeight.toDouble(),
                    child: Text(
                      'Error: Image did not load',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              onTap: () {
                //TODO: Use a hero animation using the image
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (context) => Info(
                      id: widget.id,
                    ),
                  ),
                );
              },
              onLongPress: () {
                //TODO: Expand the image and stack it above the tile
              },
            ),
          );
        } else {
          return const CenteredSpinner();
        }
      },
    );
  }

  void _errorHandler(Object? error) {
    // TODO: Put real error handling here
    debugPrint('error --> $error');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_reloaded > 3) {
        setState(() {
          _isError = true;
        });
        return;
      }
      setState(() {
        book = fetchBook(widget.id);
        _reloaded++;
      });
    });
  }

  Future<Book>? _safeFetchBook(int id) {
    try {
      return fetchBook(id);
    } on FormatException {
      _isError = true;
    }
    return null;
  }
}
