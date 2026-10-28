import 'package:flutter/material.dart';
import '../models/book.dart';
import 'book_reader_screen.dart';

/// Gives a short overview of a book before the reader opens.
class BookDetailsScreen extends StatelessWidget {
  final Book book;
  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              Text(book.arabicTitle, textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, height: 1.8)),
              const SizedBox(height: 14),
              const Icon(Icons.menu_book_rounded, size: 54),
            ]),
          ),
          const SizedBox(height: 20),
          Text(book.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(book.subtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Text('By ${book.author} • ${book.category}'),
          const SizedBox(height: 20),
          Text(book.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.chrome_reader_mode_outlined),
            label: const Text('Open reader'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BookReaderScreen(book: book),
            )),
          ),
        ],
      ),
    );
  }
}