import 'package:flutter/material.dart';
class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      color: Colors.green,
      child: Text('Saved'),
    );
  }
}
