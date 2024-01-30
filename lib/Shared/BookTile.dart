import 'package:flutter/material.dart';
import 'package:hebrewbooks/Screens/Info.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/CenteredSpinner.dart';
import 'package:hebrewbooks/Shared/book.dart';

class BookTile extends StatefulWidget {
  final int id;

  const BookTile({super.key, required this.id});

  @override
  State<BookTile> createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  late Future<Book> book;

  static const int imageHeight = 56;

  @override
  void initState() {
    super.initState();
    book = fetchBook(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: book,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                title: Text(
                  snapshot.data!.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(snapshot.data!.author,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
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
                      height:
                          imageHeight.toDouble(),
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
                    MaterialPageRoute(
                        builder: (context) => Info(
                              id: widget.id,
                            )),
                  );
                },
                onLongPress: () {
                  //TODO: Use provider to expand the image and stack it above the tile
                },
              ),
            );
          } else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          } else {
            return const CenteredSpinner();
          }
        });
  }
}
