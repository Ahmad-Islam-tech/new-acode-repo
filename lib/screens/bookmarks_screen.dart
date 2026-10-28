import 'package:flutter/material.dart';

/// This screen will eventually display the user's saved books,
/// chapters, and reading passages.
///
/// For now, it provides the initial interface.
/// We will add persistent bookmark storage in a later stage.
class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The title appears in the top navigation bar.
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),

      // Center displays the initial empty-state message.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bookmark_border_rounded,
                size: 64,
              ),

              const SizedBox(height: 16),

              Text(
                'Your Library Bookmarks',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Books and passages you save will appear here.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}