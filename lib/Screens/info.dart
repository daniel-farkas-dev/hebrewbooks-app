import 'package:flutter/material.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/book.dart';
import 'package:hebrewbooks/Shared/centered_spinner.dart';
import 'package:share_plus/share_plus.dart';

/// The information page of a book.
class Info extends StatefulWidget {
  const Info({required this.id, super.key});

  /// The id of the book.
  ///
  /// The book is accessible at `https://beta.hebrewbooks.org/$id`.
  final int id;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late Future<Book> futureBook;

  static const imageHeight = 400;
  static const imageWidth = 300;

  @override
  void initState() {
    //TODO: Start downloading the book
    super.initState();
    futureBook = fetchInfo(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: FutureBuilder<Book>(
        future: futureBook,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  scrolledUnderElevation: 4,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    snapshot.data!.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Image.network(
                        coverUrl(
                          snapshot.data!.id,
                          imageWidth,
                          imageHeight,
                        ),
                        height: imageHeight.toDouble(),
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const CenteredSpinner();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error: $error');
                          return SizedBox(
                            height: imageHeight.toDouble(),
                            child: Text(
                              'Error: Image did not load',
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              snapshot.data!.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              snapshot.data!.author,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Published: ${snapshot.data!.year}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Pages: ${snapshot.data!.pages}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //TODO: Check if it is already saved
                          FloatingActionButton.extended(
                            heroTag: 'save',
                            label: const Text('Save'),
                            icon: const Icon(Icons.star_border_outlined),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: () {},
                          ),
                          FloatingActionButton.extended(
                            heroTag: 'share',
                            label: const Text('Share'),
                            icon: const Icon(Icons.share_outlined),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            onPressed: showShareOptions,
                          ),
                          FloatingActionButton.extended(
                            heroTag: 'read',
                            label: const Text('Read'),
                            icon: const Icon(Icons.book_outlined),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            //TODO: Check whose fault is the no-connection; fix error
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CenteredSpinner();
        },
      ),
    );
  }

  void showShareOptions() {
    showModalBottomSheet<Widget>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Share Link'),
              onTap: shareLink,
            ),
            const ListTile(
              leading: Icon(Icons.file_upload_outlined),
              title: Text('Share File'),
              //TODO: Add file sharing
            ),
          ],
        );
      },
    );
  }

  Future<void> shareLink() async {
    final link = Uri(
      scheme: 'https',
      host: 'beta.hebrewbooks.org',
      path: '/${widget.id}',
    );
    await Share.shareUri(link);
  }
}
