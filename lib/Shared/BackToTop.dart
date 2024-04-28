import 'package:flutter/material.dart';
import 'package:hebrewbooks/Providers/BackToTopProvider.dart';
import 'package:provider/provider.dart';

class BackToTop extends StatefulWidget {
  int? route;

  BackToTop({
    super.key,
    this.route,
  });

  @override
  State<StatefulWidget> createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop> {
  static const searchRoute = 1;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<BackToTopProvider>().enabled &&
          (widget.route == null || widget.route == searchRoute),
      child: FloatingActionButton(
        onPressed: () {
          context.read<BackToTopProvider>().press();
        },
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        autofocus: true,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
