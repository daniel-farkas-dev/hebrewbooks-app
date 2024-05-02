import 'package:flutter/material.dart';
import 'package:hebrewbooks/Providers/back_to_top_provider.dart';
import 'package:provider/provider.dart';

class BackToTop extends StatelessWidget {
  const BackToTop({
    super.key,
    this.route,
  });

  final int? route;

  static const searchRoute = 1;

  @override
  Widget build(BuildContext context) {
    final routeNotifier = ValueNotifier<int?>(route);

    return ValueListenableBuilder<int?>(
      valueListenable: routeNotifier,
      builder: (context, route, child) {
        return Visibility(
          visible: context.watch<BackToTopProvider>().enabled &&
              (route == null || route == searchRoute),
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
      },
    );
  }
}
