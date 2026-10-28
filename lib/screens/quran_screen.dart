import 'package:flutter/material.dart';

/// Qur'an section placeholder; do not populate it with unverified text.
class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qur’an')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'The Qur’an area will include surah selection, ayah display, '
            'translation options, and bookmarks.\n\n'
            'Qur’an Arabic text must be sourced from a reliable, verified edition.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
