import 'package:flutter/material.dart';
import 'package:hebrewbooks/Screens/Info.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/book.dart';
import 'package:hebrewbooks/Shared/subject.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Book> futureBook;

  @override
  void initState() {
    super.initState();
    futureBook = fetchBook(677);
  }

  static const suggestedTopics = [
    Subject(id: 5002, name: 'תנ"ך', total: -1),
    Subject(id: 3094, name: 'משניות', total: -1),
    Subject(id: 1537, name: 'הלכה', total: -1),
    Subject(id: 2733, name: 'מועדים', total: -1),
    Subject(id: 2729, name: 'מוסר', total: -1),
    Subject(id: 1968, name: 'חסידות', total: -1),
    Subject(id: 4682, name: 'שו"ת', total: -1),
    Subject(id: -1, name: 'More', total: -1),
  ];
  var topics = suggestedTopics;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              leading: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/logo.png',
                    width: 24.0,
                    height: 24.0,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
              ),
              title: Column(
                children: <Widget>[
                  Text('HebrewBooks',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('63,016 Hebrew Books',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall), //TODO: Pull number from API
                ],
              ),
              centerTitle: true,
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(48.0, 48.0),
                    textStyle: const TextStyle(
                      fontSize: 24.0,
                      height: 1.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  child: const Text('א', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Switch to עברית')));
                  },
                ),
              ],
            ),
            FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Info(
                              id: 677,
                            )),
                  );
                },
                child: const Icon(Icons.book)),
            Container(
              //constraints: const BoxConstraints(minHeight: 700),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text('Browse',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: 8,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('ש"ס'),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('רמב"ם'),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('הלכה'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 16,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Topics',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 56 * topics.length.toDouble(),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                if (index != 0) ...[
                                  const Divider(
                                    height: 0,
                                    thickness: 1,
                                  )
                                ],
                                ListTile(
                                  title: Text(topics[index].name),
                                  onTap: topics[index].id == -1
                                      ? () {
                                          if (topics == suggestedTopics) {
                                              fetchSubjects()
                                                  .then((value) => setState(
                                                      () => topics = value));
                                              //TODO: Add loading indicator
                                            //TODO: Add error handling
                                            //TODO: Add caching
                                            //TODO: Add offline mode/detection
                                          } else {
                                            setState(() {
                                              topics = suggestedTopics;
                                            });
                                          }
                                        }
                                      : null,
                                  trailing: topics[index].id == -1
                                      ? const Icon(Icons.chevron_right)
                                      : null,
                                ),
                              ],
                            );
                          },
                          itemCount: topics.length),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
