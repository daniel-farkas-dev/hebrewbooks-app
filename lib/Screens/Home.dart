import 'package:flutter/material.dart';
import 'package:hebrewbooks/Screens/Category.dart';
import 'package:hebrewbooks/Services/fetch.dart';
import 'package:hebrewbooks/Shared/CenteredSpinner.dart';
import 'package:hebrewbooks/Shared/subject.dart';

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
    //Figure out a better system for this; maybe, eventualy Google Cloud Messages
    Subject(id: 5002, name: 'תנ"ך', total: -1),
    Subject(id: 3094, name: 'משניות', total: -1),
    Subject(id: 1537, name: 'הלכה', total: -1),
    Subject(id: 2733, name: 'מועדים', total: -1),
    Subject(id: 2729, name: 'מוסר', total: -1),
    Subject(id: 1968, name: 'חסידות', total: -1),
    Subject(id: 4682, name: 'שו"ת', total: -1),
    Subject(id: -1, name: 'More', total: -1),
  ];
  var subjects = suggestedSubjects;

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
              leading: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
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
                  FutureBuilder(
                      future: fullSubjects,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          data = snapshot.data as List<Subject>;
                          return Column(children: [
                            Text('Subjects',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 56 * subjects.length.toDouble(),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                            title: Text(subjects[index].name),
                                            onTap: subjects[index].id == -1
                                                ? () {
                                                    _swapSubjects();
                                                  }
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Category(
                                                                id: subjects[index].id,
                                                                name: subjects[index].name,
                                                              )),
                                                    );
                                                  },
                                            trailing: subjects[index].id == -1
                                                ? const Icon(
                                                    Icons.chevron_right)
                                                : null,
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: subjects.length),
                              ),
                            ),
                          ]);
                        } else if (snapshot.hasError) {
                          //TODO: Put a real offline indicator here- provider if fancy
                          return Text('${snapshot.error}');
                        }
                        return const CenteredSpinner();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _swapSubjects() async {
    setState(() {
      if (subjects == suggestedSubjects && data.isNotEmpty) {
        subjects = data;
      } else {
        subjects = suggestedSubjects;
      }
    });
  }
}
