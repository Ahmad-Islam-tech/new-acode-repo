import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// ============================================================
/// NOOR LIBRARY — ASK A QUESTION
/// ============================================================
/// This screen validates and submits Islamic questions to Supabase.
///
/// Security:
/// 1. The user must be signed in.
/// 2. The question is associated with the authenticated user.
/// 3. New questions receive "pending" status.
/// 4. Supabase Row-Level Security (RLS) validates the insertion.
/// ============================================================

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() =>
      _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  // Validates required form fields.
  final _formKey = GlobalKey<FormState>();

  // Controllers read text entered into the form.
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _referencesController = TextEditingController();

  // Prevents duplicate submissions while a request is running.
  bool _isSubmitting = false;

  // Available question categories.
  final List<String> _categories = [
    'Aqeedah & Tawheed',
    'Qur’an & Tafseer',
    'Hadith & Sunnah',
    'Fiqh & Worship',
    'Character & Purification of the Heart',
    'Marriage & Family',
    'Business & Finance',
    'Arabic & Islamic Studies',
    'Daily Muslim Life',
  ];

  // Languages supported by this form.
  final List<String> _languages = [
    'English',
    'Arabic',
    'Luganda',
  ];

  // Default selections.
  String _selectedCategory = 'Fiqh & Worship';
  String _selectedLanguage = 'English';

  // Public questions are intended for the reviewed knowledge archive.
  bool _isPublic = true;

  // Access the configured Supabase client.
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  void dispose() {
    // Release text controllers when the screen closes.
    _titleController.dispose();
    _detailsController.dispose();
    _referencesController.dispose();

    super.dispose();
  }

  /// Shows a message without using a disposed screen.
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Validates the form and submits the question to Supabase.
  Future<void> _submitQuestion() async {
    // Stop if the user has not completed the required fields.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Do not allow multiple simultaneous submissions.
    if (_isSubmitting) {
      return;
    }

    // Obtain the currently authenticated user.
    final user = _supabase.auth.currentUser;

    // A question must be associated with a signed-in user.
    if (user == null) {
      _showMessage('Please sign in before submitting a question.');
      return;
    }

    // Read and trim the form values.
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    final references = _referencesController.text.trim();

    // Display the loading state.
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Insert the question into the public.questions table.
      //
      // Supabase RLS must permit this authenticated user to insert
      // a row with these values.
      await _supabase.from('questions').insert({
        'user_id': user.id,
        'title': title,
        'details': details,
        'category': _selectedCategory,
        'language': _selectedLanguage,
        'references_text':
            references.isEmpty ? null : references,
        'is_public': _isPublic,
        'status': 'pending',
      });

      // Do not use the screen context if the screen has closed.
      if (!mounted) return;

      // Tell the user the database accepted the submission.
      _showMessage(
        'Question submitted successfully. It is awaiting review.',
      );

      // Clear the form after a successful insert.
      _titleController.clear();
      _detailsController.clear();
      _referencesController.clear();

      // Reset the default selections.
      setState(() {
        _selectedCategory = 'Fiqh & Worship';
        _selectedLanguage = 'English';
        _isPublic = true;
      });

      // Return to the previous screen.
      Navigator.pop(context, true);
    } on PostgrestException catch (error) {
      // Supabase rejected the database operation.
      debugPrint('Question submission database error: ${error.message}');
      debugPrint('Database error code: ${error.code}');
      debugPrint('Database error details: ${error.details}');
      debugPrint('Database error hint: ${error.hint}');

      _showMessage(
        'Database rejected the question. Check the submission '
        'policy and required database fields.',
      );
    } on AuthException catch (error) {
      // Handle authentication-related errors.
      debugPrint('Question submission authentication error: '
          '${error.message}');

      _showMessage('Authentication error: ${error.message}');
    } catch (error) {
      // Handle unexpected errors without exposing technical details.
      debugPrint('Unexpected question submission error: $error');

      _showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      // Remove the loading state if this screen is still open.
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the active app theme for consistent styling.
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask a Question'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Introduction card.
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.volunteer_activism_outlined,
                          size: 40,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Seek Knowledge with Sincerity',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Write your question clearly. Include relevant '
                          'details and references when available.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Question title.
                const Text(
                  'Question Title *',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  maxLength: 120,
                  decoration: const InputDecoration(
                    hintText: 'e.g. What invalidates fasting?',
                    prefixIcon: Icon(Icons.help_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a question title.';
                    }
                    if (value.trim().length < 8) {
                      return 'Please provide a more descriptive title.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Detailed question.
                const Text(
                  'Explain Your Question *',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  minLines: 5,
                  maxLines: 9,
                  maxLength: 4000,
                  decoration: const InputDecoration(
                    hintText:
                        'Explain what you want to understand. '
                        'Include relevant circumstances without '
                        'sharing unnecessary private information.',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please explain your question.';
                    }
                    if (value.trim().length < 15) {
                      return 'Please provide more detail.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Question category.
                const Text(
                  'Category',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                ),

                const SizedBox(height: 20),

                // Question language.
                const Text(
                  'Question Language',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: _languages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: _isSubmitting
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLanguage = value;
                            });
                          }
                        },
                ),

                const SizedBox(height: 20),

                // Optional references.
                const Text(
                  'References (Optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _referencesController,
                  minLines: 2,
                  maxLines: 4,
                  maxLength: 1500,
                  decoration: const InputDecoration(
                    hintText:
                        'Add a verse, Hadith reference, book title, '
                        'or scholarly quotation if you know one.',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.menu_book_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // Public/private visibility setting.
                Card(
                  child: SwitchListTile(
                    value: _isPublic,
                    title: Text(
                      _isPublic
                          ? 'Public Question'
                          : 'Private Question',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _isPublic
                          ? 'Visible publicly after approval.'
                          : 'Restricted question awaiting review.',
                    ),
                    secondary: Icon(
                      _isPublic ? Icons.public : Icons.lock_outline,
                    ),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _isPublic = value;
                            });
                          },
                  ),
                ),

                const SizedBox(height: 8),

                // Privacy reminder.
                const Text(
                  'Please do not include passwords, account details, '
                  'or other unnecessary sensitive information.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                // Submit the question to Supabase.
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submitQuestion,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      _isSubmitting
                          ? 'Submitting Question...'
                          : 'Submit Question',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Explain that all submissions require review.
                const Text(
                  'Your question will be stored as pending and will '
                  'not appear in the public archive until approved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}