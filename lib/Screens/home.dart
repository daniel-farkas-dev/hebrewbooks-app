import 'package:flutter/material.dart';
import 'package:hebrewbooks/Screens/category.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/centered_spinner.dart';
import 'package:hebrewbooks/Shared/subject.dart';

/// The home screen of the application.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Subject>> fullSubjects;
  late List<Subject> data;

  @override
  void initState() {
    super.initState();
    fullSubjects = fetchSubjects();
  }

  static const suggestedSubjects = [
    //Figure out a better system for this; maybe eventually Google Cloud Message
    Subject(id: 5002, name: 'תנ"ך', total: -1),
    Subject(id: 3094, name: 'משניות', total: -1),
    Subject(id: 1537, name: 'הלכה', total: -1),
    Subject(id: 2733, name: 'מועדים', total: -1),
    Subject(id: 2729, name: 'מוסר', total: -1),
    Subject(id: 1968, name: 'חסידות', total: -1),
    Subject(id: 4682, name: 'שו"ת', total: -1),
    Subject(id: -1, name: 'More', total: -1),
  ];
  var _subjects = suggestedSubjects;

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
              leading: SizedBox(
                width: 48,
                height: 48,
                child: Align(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              title: Column(
                children: <Widget>[
                  Text(
                    'HebrewBooks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '63,016 Hebrew Books',
                    style: Theme.of(context).textTheme.titleSmall,
                  ), //TODO: Pull number from API
                ],
              ),
              centerTitle: true,
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(48, 48),
                    textStyle: const TextStyle(
                      fontSize: 24,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  child: const Text('א', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Switch to עברית')),
                    );
                  },
                ),
              ],
            ),
            Container(
              //constraints: const BoxConstraints(minHeight: 700),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    'Browse',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('ש"ס'),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('רמב"ם'),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                  FutureBuilder(
                    future: fullSubjects,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        data = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              'Subjects',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 56 * _subjects.length.toDouble(),
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
                                          ),
                                        ],
                                        ListTile(
                                          title: Text(_subjects[index].name),
                                          onTap: _subjects[index].id == -1
                                              ? _swapSubjects
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute<Widget>(
                                                      builder: (context) =>
                                                          Category(
                                                        id: _subjects[index].id,
                                                        name: _subjects[index]
                                                            .name,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          trailing: _subjects[index].id == -1
                                              ? const Icon(
                                                  Icons.chevron_right,
                                                )
                                              : null,
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: _subjects.length,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        //TODO: Put real error handling here
                        //TODO lock down the app if no data
                        return Text('${snapshot.error}');
                      }
                      return const CenteredSpinner();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _swapSubjects() async {
    setState(() {
      if (_subjects == suggestedSubjects && data.isNotEmpty) {
        _subjects = data;
      } else {
        _subjects = suggestedSubjects;
      }
    });
  }
}
