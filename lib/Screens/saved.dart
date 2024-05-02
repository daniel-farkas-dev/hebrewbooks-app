import 'package:flutter/material.dart';
import 'package:hebrewbooks/Shared/saved_book.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  //TODO: Pull these from local storage
  //TODO: Make a data object for these which has all the info
  static var saved = [
    SavedBook.fromJson({
      'title': 'ערוך השלחן – חושן משפט א',
      'author': 'יחיאל מיכל בן אריה יצחק עפשטיין',
      'published': 1884,
      'id': 9103,
      'pages': 521,
      'downloaded': false,
    }),
    SavedBook.fromJson({
      'title': 'קיצור שולחן ערוך',
      'author': 'שלמה בן יוסף גנצפריד',
      'published': 1802,
      'id': 49252,
      'pages': 30,
      'downloaded': true,
    }),
    SavedBook.fromJson({
      'title': 'ערוך לנר – סנהדרין',
      'author': 'יעקב יוקב בן אהרן עטלינגר',
      'published': 1931,
      'id': 14415,
      'pages': 171,
      'downloaded': false,
    }),
  ];

  @override
  Widget build(BuildContext context) {
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
              title:
                  Text('Saved', style: Theme.of(context).textTheme.titleLarge),
              centerTitle: true,
            ),
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
                            '${saved[index].author} • ${saved[index].year}',
                          ),
                          onTap: () {},
                          trailing: Wrap(
                            //TODO: Change the local history
                            children: [
                              if (saved[index].downloaded)
                                const Icon(
                                  Icons.download_for_offline_outlined,
                                )
                              else
                                const Icon(Icons.offline_pin_outlined),
                              const Icon(Icons.star_outline),
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
  }
}
