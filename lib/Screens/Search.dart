import 'package:flutter/material.dart';

import '../Shared/SearchBarFull.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SearchBarFull(
              hintText: 'Search HebrewBooks',
            ),
            Container(
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
                            onTap: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
