import 'package:flutter/material.dart';

class CenteredSpinner extends StatelessWidget {
  const CenteredSpinner({
    super.key,
    this.size = 100,
  });
  final int size;

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
        ],);
  }
}
