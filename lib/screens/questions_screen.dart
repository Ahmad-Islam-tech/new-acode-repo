import 'package:flutter/material.dart';

import 'ask_question_screen.dart';

/// ============================================================
/// NOOR Q&A — QUESTIONS HOME SCREEN
/// ============================================================
/// This screen is the main entry point for Noor Q&A.
///
/// It provides:
/// 1. A welcome section.
/// 2. An Ask a Question button.
/// 3. A link to Universal Search.
/// 4. Islamic question categories.
/// 5. A Knowledge Archive placeholder.
///
/// IMPORTANT:
/// The online database has not yet been connected.
/// Questions and answers will be retrieved from the backend
/// after we implement the database and question service.
/// ============================================================

class QuestionsScreen extends StatelessWidget {
  const QuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the app's current theme for consistent styling.
    final theme = Theme.of(context);

    return Scaffold(
      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------
      appBar: AppBar(
        title: const Text('Noor Q&A'),
        centerTitle: true,
      ),

      // SafeArea prevents content from overlapping system areas.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ------------------------------------------------
              // 1. WELCOME SECTION
              // ------------------------------------------------
              _WelcomeCard(theme: theme),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // 2. ASK A QUESTION BUTTON
              // ------------------------------------------------
              FilledButton.icon(
                onPressed: () {
                  // Open the question submission form.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AskQuestionScreen(),
                    ),
                  );
                },

                icon: const Icon(Icons.add_circle_outline),

                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Ask a Question',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // 3. UNIVERSAL SEARCH BUTTON
              // ------------------------------------------------
              OutlinedButton.icon(
                onPressed: () {
                  // Open the existing Universal Search screen.
                  Navigator.pushNamed(context, '/search');
                },

                icon: const Icon(Icons.search),

                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Search Noor Library'),
                ),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------------
              // 4. CATEGORY SECTION HEADING
              // ------------------------------------------------
              Text(
                'Explore Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // 5. ISLAMIC QUESTION CATEGORIES
              // ------------------------------------------------
              const _CategoryTile(
                icon: Icons.mosque_outlined,
                title: 'Aqeedah & Tawheed',
                description:
                    'Islamic belief and worship of Allah alone.',
              ),

              const _CategoryTile(
                icon: Icons.menu_book_rounded,
                title: 'Qur’an & Tafseer',
                description:
                    'Understanding the Qur’an and its meanings.',
              ),

              const _CategoryTile(
                icon: Icons.auto_stories_outlined,
                title: 'Hadith & Sunnah',
                description:
                    'Prophetic teachings and their explanations.',
              ),

              const _CategoryTile(
                icon: Icons.volunteer_activism_outlined,
                title: 'Fiqh & Worship',
                description:
                    'Prayer, fasting, zakah, and other acts of worship.',
              ),

              const _CategoryTile(
                icon: Icons.favorite_outline,
                title: 'Character & Family',
                description:
                    'Manners, relationships, and family life.',
              ),

              const _CategoryTile(
                icon: Icons.business_center_outlined,
                title: 'Business & Daily Life',
                description:
                    'Islamic guidance for everyday matters.',
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // 6. KNOWLEDGE ARCHIVE
              // ------------------------------------------------
              const _KnowledgeArchiveCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// WELCOME CARD
// ============================================================

/// Displays the Noor Q&A introduction.
///
/// Keeping this section separate makes the main screen cleaner
/// and easier to maintain.
class _WelcomeCard extends StatelessWidget {
  final ThemeData theme;

  const _WelcomeCard({
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(22),

        child: Column(
          children: [
            // Main discussion icon.
            Icon(
              Icons.forum_rounded,
              size: 52,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 12),

            // Welcome heading.
            Text(
              'Ask, Learn and Share Knowledge',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Introduction to the Q&A platform.
            Text(
              'Explore Islamic questions, study their answers, '
              'and learn from carefully documented discussions.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY TILE
// ============================================================

/// Reusable tile representing an Islamic question category.
///
/// Category filtering will be connected when we implement
/// question storage and retrieval.
class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _CategoryTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Use the active app theme for the category icon.
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      child: ListTile(
        // Category icon.
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),

        // Category name.
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        // Short category description.
        subtitle: Text(description),

        // Indicates that a category can eventually be opened.
        trailing: const Icon(Icons.chevron_right),

        // Filtering has not been implemented yet.
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$title questions will be available '
                'when the question archive is connected.',
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// KNOWLEDGE ARCHIVE CARD
// ============================================================

/// Placeholder for the future searchable question archive.
///
/// This will eventually display real questions from the database.
class _KnowledgeArchiveCard extends StatelessWidget {
  const _KnowledgeArchiveCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Archive icon.
            Icon(
              Icons.library_books_outlined,
              size: 40,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 10),

            // Archive heading.
            Text(
              'Your Knowledge Archive',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Honest notice while the backend is pending.
            const Text(
              'Questions and answers will appear here after '
              'we connect the online database.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Current implementation status.
            Text(
              'Online storage: Not connected',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}