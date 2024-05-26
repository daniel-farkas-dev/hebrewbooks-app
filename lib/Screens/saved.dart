import 'package:flutter/material.dart';
import 'package:hebrewbooks/Providers/saved_books_provider.dart';
import 'package:hebrewbooks/Screens/info.dart';
import 'package:provider/provider.dart';

/// The saved books screen.
class Saved extends StatelessWidget {
  const Saved({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedBooksProvider>(
      builder: (context, savedBooksProvider, child) {
        final saved = savedBooksProvider.savedBooks;
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  scrolledUnderElevation: 4,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  title: Text(
                    'Saved',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  centerTitle: true,
                ),
                if (saved.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        "You don't have any saved books.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: saved.length * 72.0,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(saved[index].title),
                                subtitle: Text(
                                  saved[index].year == null
                                      ? saved[index].author
                                      : '${saved[index].author} • ${saved[index].year}',
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<Widget>(
                                      builder: (context) => Info(
                                        id: saved[index].id,
                                      ),
                                    ),
                                  );
                                },
                                trailing: Wrap(
                                  children: [
                                    if (saved[index].downloaded)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.download_for_offline_outlined,
                                        ),
                                        onPressed: () {},
                                      )
                                    else
                                      IconButton(
                                        icon: const Icon(
                                          Icons.offline_pin_outlined,
                                        ),
                                        onPressed: () {},
                                      ),
                                    IconButton(
                                      icon: const Icon(Icons.star),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 0,
                                thickness: 1,
                              ),
                            ],
                          );
                        },
                        itemCount: saved.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
