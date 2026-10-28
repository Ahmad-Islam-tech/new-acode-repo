import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../data/sample_books.dart';
import '../widgets/book_card.dart';
import '../widgets/feature_card.dart';
import 'book_details_screen.dart';

/// Main home screen of Noor Library.
///
/// This screen displays library features, featured books,
/// and authentication buttons for guests.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top navigation bar.
      appBar: AppBar(
        title: const Text(
          'Noor Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // Search and Settings buttons.
        actions: [
          // Opens Universal Search.
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search Noor Library',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.search,
              );
            },
          ),

          // Opens Settings.
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.settings,
              );
            },
          ),
        ],
      ),

      // Keeps content clear of system interface areas.
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Welcome banner with authentication buttons.
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF155D43),
                    Color(0xFF23835E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic Basmala.
                  const Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Welcome message.
                  const Text(
                    'Knowledge that brings us closer to Allah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Read, learn, reflect, and grow.',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Authentication buttons.
                  //
                  // Wrap allows the buttons to move onto
                  // separate lines on narrow phone screens.
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // Opens the existing Sign In screen.
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                        icon: const Icon(
                          Icons.login_rounded,
                        ),
                        label: const Text('Sign In'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color(0xFF155D43),
                        ),
                      ),

                      // Opens the existing registration screen.
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.register,
                          );
                        },
                        icon: const Icon(
                          Icons.person_add_alt_1_rounded,
                        ),
                        label: const Text('Register'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Explore section heading.
            Text(
              'Explore',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            // Grid of the main library features.
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.16,
              children: [
                // Books.
                FeatureCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Books',
                  description: 'Browse Islamic books',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.books,
                    );
                  },
                ),

                // Hadith.
                FeatureCard(
                  icon: Icons.format_quote_rounded,
                  title: 'Hadith',
                  description: 'Study Prophetic narrations',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.hadith,
                    );
                  },
                ),

                // Qur'an.
                FeatureCard(
                  icon: Icons.auto_stories_rounded,
                  title: 'Qur’an',
                  description: 'Qur’an learning area',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quran,
                    );
                  },
                ),

                // Noor Q&A.
                FeatureCard(
                  icon: Icons.forum_rounded,
                  title: 'Questions & Answers',
                  description:
                      'Ask, learn and share Islamic knowledge.',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.questions,
                    );
                  },
                ),

                // Bookmarks.
                FeatureCard(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Bookmarks',
                  description: 'Return to saved items',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.bookmarks,
                    );
                  },
                ),
              ],
            ),
              
              // Temporary button for testing the Admin Dashboard.
ElevatedButton.icon(
  onPressed: () {
    // Navigate to the Admin Dashboard.
    Navigator.pushNamed(
      context,
      '/admin-dashboard',
    );
  },
  icon: const Icon(Icons.admin_panel_settings),
  label: const Text('Admin Dashboard'),
),
              

            const SizedBox(height: 24),

            // Featured books heading.
            Text(
              'Featured books',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            // Displays the first two sample books.
            ...sampleBooks.take(2).map(
              (book) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: BookCard(
                  book: book,

                  // Opens the selected book's details.
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}