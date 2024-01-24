import 'package:flutter/material.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  static const saved = [
    (
      title: 'ערוך השלחן – חושן משפט ב',
      author: 'יחיאל מיכל בן אריה יצחק עפשטיין',
      published: 1884,
      downloaded: false
    ),
    (
      title: 'קיצור שולחן ערוך',
      author: 'שלמה בן יוסף גנצפריד',
      published: 1802,
      downloaded: true
    ),
    (
      title: 'ערוך לנר – סנהדרין',
      author: 'יעקב יוקב בן אהרן עטלינגר',
      published: 1931,
      downloaded: false
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              scrolledUnderElevation: 4.0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              shadowColor: Theme.of(context).colorScheme.shadow,
              title:
                  Text('Saved', style: Theme.of(context).textTheme.titleLarge),
              centerTitle: true,
            ),
            Container(
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
                                '${saved[index].author} • ${saved[index].published}'),
                            onTap: () {},
                            trailing: Wrap(
                              children: [
                                if (saved[index].downloaded)
                                  const Icon(
                                      Icons.download_for_offline_outlined)
                                else
                                  const Icon(Icons.offline_pin_outlined),
                                const Icon(Icons.star_outline),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                            thickness: 1,
                          )
                        ],
                      );
                    },
                    itemCount: saved.length),
              ),
            )
          ],
        ),
      ),
    );
  }
}
