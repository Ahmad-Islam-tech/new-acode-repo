import 'package:flutter/material.dart';

import '../data/sample_books.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

/// BooksScreen displays the books available in Noor Library.
///
/// We use StatefulWidget because the search query and selected
/// category can change while the screen is open.
class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  // Stores the words entered into the search field.
  String _searchQuery = '';

  // "All" means that no individual category is selected.
  String _selectedCategory = 'All';

  /// Builds a list of categories from our book data.
  ///
  /// Set removes duplicate category names.
  List<String> get _categories {
    final categories = sampleBooks
        .map((book) => book.category)
        .toSet()
        .toList();

    return ['All', ...categories];
  }

  /// Filters books using both the search query and selected category.
  List<Book> get _filteredBooks {
    return sampleBooks.where((book) {
      // Search in the title, subtitle, author, and category.
      final query = _searchQuery.toLowerCase();

      final matchesSearch =
          book.title.toLowerCase().contains(query) ||
          book.subtitle.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.category.toLowerCase().contains(query);

      // Show every category when "All" is selected.
      final matchesCategory =
          _selectedCategory == 'All' ||
          book.category == _selectedCategory;

      // A book must satisfy both conditions to appear.
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Islamic Books',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search books, authors, or topics...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),

              // Update the search query whenever the user types.
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category heading.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Categories',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // Horizontally scrollable category buttons.
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];

                return ChoiceChip(
                  label: Text(category),

                  // Highlights the category currently selected.
                  selected: _selectedCategory == category,

                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          // Results heading.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              '${books.length} books available',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          // Expanded allows the results list to use remaining space.
          Expanded(
            child: books.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No books found.\nTry another search.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      20,
                    ),

                    itemCount: books.length,

                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),

                    itemBuilder: (context, index) {
                      final book = books[index];

                      return BookCard(
                        book: book,

                        // Open the selected book's details screen.
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailsScreen(
                                book: book,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}