import 'package:flutter/material.dart';

class CenteredSpinner extends StatelessWidget {
  final int size;
  const CenteredSpinner({
    super.key,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size.toDouble(),
            height: size.toDouble(),
            child: const CircularProgressIndicator(),
          ),
        ]);
  }
}