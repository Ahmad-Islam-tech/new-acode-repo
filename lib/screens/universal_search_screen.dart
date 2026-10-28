import 'package:flutter/material.dart';

import '../models/search_result.dart';
import '../services/universal_search_service.dart';

class UniversalSearchScreen extends StatefulWidget {
  const UniversalSearchScreen({super.key});

  @override
  State<UniversalSearchScreen> createState() =>
      _UniversalSearchScreenState();
}

class _UniversalSearchScreenState
    extends State<UniversalSearchScreen> {
  // Controls the search input field.
  final TextEditingController _searchController =
      TextEditingController();

  // Categories available to the user.
  final List<String> _categories = const [
    'ALL',
    'QURAN',
    'HADITH',
    'BOOKS',
    'CHAPTERS',
    'LUGANDA',
  ];

  String _selectedCategory = 'ALL';
  String _query = '';

  // Requests matching results from the shared search service.
  List<SearchResult> get _results {
    return UniversalSearchService.instance.search(
      _query,
      category: _selectedCategory,
    );
  }

  @override
  void dispose() {
    // Releases the text controller when this screen closes.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universal Search'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Search field.
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,

              // Updates results as the user types.
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },

              decoration: InputDecoration(
                hintText:
                    'Search words, verses, hadiths, books...',
                prefixIcon: const Icon(Icons.search),

                // The clear button removes the current query.
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _query = '';
                    });
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // Horizontally scrollable category filters.
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,

                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Displays the number of matching results.
          if (_query.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_results.length} result(s) found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),

          // Search results occupy the remaining screen space.
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_query.trim().isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.manage_search,
                size: 64,
              ),
              SizedBox(height: 12),
              Text(
                'Search the Noor Library',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Find matching words and topics across '
                'the available library content.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final results = _results;

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No matching results found.\nTry another word.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,

      itemBuilder: (context, index) {
        final result = results[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),

            leading: CircleAvatar(
              child: Icon(_categoryIcon(result.category)),
            ),

            title: Text(
              result.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result.arabicText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        result.arabicText,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),

                  Text(result.content),

                  if (result.reference.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      result.reference,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  Text(
                    result.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // We will connect this action to the relevant
            // book, verse, or hadith reader in the next phase.
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Selected: ${result.title}. '
                    'Opening the full content will be connected next.',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Chooses an icon based on the result category.
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'QURAN':
        return Icons.menu_book;

      case 'HADITH':
        return Icons.format_quote;

      case 'BOOKS':
        return Icons.library_books;

      case 'CHAPTERS':
        return Icons.article;

      case 'LUGANDA':
        return Icons.translate;

      default:
        return Icons.search;
    }
  }
}