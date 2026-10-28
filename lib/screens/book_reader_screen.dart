import 'package:flutter/material.dart';
import '../models/book.dart';

/// Starter reading screen with adjustable text size.
/// Actual chapters and verified multilingual content will be added next.
class BookReaderScreen extends StatefulWidget {
  final Book book;
  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  double _fontSize = 18; // State remembers the reader's current text size.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(widget.book.arabicTitle,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _fontSize + 6, height: 2)),
          const Divider(height: 32),
          Text(widget.book.title,
            style: TextStyle(fontSize: _fontSize + 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            'Welcome to the reading area. This is starter placeholder text. '
            'The full manuscript, chapter navigation, Arabic text with tashkeel, '
            'English translation, and Luganda translation will be connected here.',
            style: TextStyle(fontSize: _fontSize, height: 1.8),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                const Icon(Icons.text_fields),
                const SizedBox(width: 12),
                const Text('Text size'),
                Expanded(
                  // Slider changes _fontSize; setState rebuilds the reading text.
                  child: Slider(
                    min: 14,
                    max: 30,
                    divisions: 8,
                    value: _fontSize,
                    label: _fontSize.round().toString(),
                    onChanged: (value) => setState(() => _fontSize = value),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
