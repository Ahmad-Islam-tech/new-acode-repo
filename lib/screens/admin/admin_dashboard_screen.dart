import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initial administrator dashboard for Noor Library.
///
/// This screen checks whether the current user is signed in
/// and whether their database role is admin.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  // Controls the loading indicator while checking permissions.
  bool _isLoading = true;

  // Stores whether the current user is an administrator.
  bool _isAdmin = false;

  // Displays any permission-checking error.
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Check the current user's administrator role.
    _checkAdminRole();
  }

 /// Securely checks whether the signed-in user is an administrator.
Future<void> _checkAdminRole() async {
  try {
    // Access the existing Supabase connection.
    final supabase = Supabase.instance.client;

    // Get the currently signed-in user.
    final user = supabase.auth.currentUser;

    // A signed-out user cannot access the admin dashboard.
    if (user == null) {
      if (!mounted) return;

      setState(() {
        _isAdmin = false;
        _isLoading = false;
        _errorMessage = 'Please sign in first.';
      });

      return;
    }

    // Ask Supabase to verify the user's administrator role.
    final result = await supabase.rpc('is_noor_admin');

    // The function returns true only for an administrator.
    final isAdmin = result == true;

    if (!mounted) return;

    setState(() {
      _isAdmin = isAdmin;
      _isLoading = false;
      _errorMessage = isAdmin
          ? null
          : 'Administrator access is required.';
    });
  } catch (error, stackTrace) {
    // Print the actual error so we can diagnose any failure.
    debugPrint('Admin verification error: $error');
    debugPrint('Admin verification stack: $stackTrace');

    if (!mounted) return;

    setState(() {
      _isAdmin = false;
      _isLoading = false;
      _errorMessage =
          'Could not verify administrator access. '
          'Please check the debug console.';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dashboard title bar.
      appBar: AppBar(
        title: const Text('Noor Library Admin'),
      ),

      // Show different content depending on the permission check.
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : !_isAdmin
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 56,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage ??
                              'Access denied.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _checkAdminRole,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildDashboard(),
    );
  }

  /// Builds the initial dashboard interface.
  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome heading.
        const Text(
          'Administrator Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Manage the Noor Library platform.',
        ),

        const SizedBox(height: 24),

        // Dashboard feature cards.
        _buildModuleCard(
          icon: Icons.menu_book,
          title: 'Book Management',
          description: 'Review and manage Islamic books.',
        ),

        _buildModuleCard(
          icon: Icons.question_answer,
          title: 'Q&A Moderation',
          description: 'Review submitted questions and answers.',
        ),

        _buildModuleCard(
          icon: Icons.people,
          title: 'Author Management',
          description: 'Manage author accounts and submissions.',
        ),

        _buildModuleCard(
          icon: Icons.people_alt,
          title: 'User Management',
          description: 'Manage library users.',
        ),

        _buildModuleCard(
          icon: Icons.payments,
          title: 'Payments & Subscriptions',
          description: 'Manage purchases and subscriptions.',
        ),

        _buildModuleCard(
          icon: Icons.analytics,
          title: 'Reports & Statistics',
          description: 'View platform activity and reports.',
        ),
      ],
    );
  }

  /// Creates a reusable dashboard module card.
  Widget _buildModuleCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        // Feature icon.
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF155D43),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        // Feature name.
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Short explanation.
        subtitle: Text(description),

        // Indicates that the card represents a module.
        trailing: const Icon(Icons.chevron_right),

        // These modules are interface placeholders for now.
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title will be connected next.'),
            ),
          );
        },
      ),
    );
  }
}