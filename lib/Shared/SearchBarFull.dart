import 'package:flutter/material.dart';
class SearchBarFull extends StatelessWidget {
  final String hintText;

  const SearchBarFull({Key? key, required this.hintText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}