import 'package:flutter/material.dart';

class CenteredSpinner extends StatelessWidget {
  const CenteredSpinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          ),
        ]);
  }
}