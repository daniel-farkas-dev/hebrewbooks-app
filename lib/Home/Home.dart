import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const topics = [
    'Tanach',
    'Mishnayos',
    'Gemara',
    'Halacha',
    'Mussar',
    'Chassidus',
    'Sha\'alos U\'Teshuvos',
    'MORE',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 700),
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Browse',
                    style: Theme.of(context).textTheme.headlineMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text('Shas'),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text('Rambam'),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text('Tur + Sh"a'),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                Text('Topics',
                    style: Theme.of(context).textTheme.headlineMedium),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 56 * topics.length.toDouble(),
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const Divider(
                              height: 0,
                            ),
                            ListTile(
                              title: Text(topics[index]),
                              onTap: () {},
                              trailing: index == topics.length-1 ? const Icon(Icons.chevron_right) : null,
                            ),
                          ],
                        );
                      },
                      itemCount: topics.length),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
