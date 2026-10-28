import 'package:flutter/material.dart';

/// Hadith area placeholder. Verified narrations and sources will be added later.
class HadithScreen extends StatelessWidget {
  const HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hadith Library')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Hadith collections will be organized here by topic and source.\n\n'
            'Each entry should include Arabic, translation, narrator, collection, '
            'reference, and a carefully verified authenticity grade where applicable.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
