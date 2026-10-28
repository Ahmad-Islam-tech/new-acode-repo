// ============================================================
// NOOR LIBRARY
// Main application entry point
// ============================================================

// 1. Flutter framework imports.
import 'package:flutter/material.dart';

// 2. Supabase backend import.
import 'package:supabase_flutter/supabase_flutter.dart';

// 3. Application routes.
import 'app/routes.dart';

// 4. Admin dashboard screen.
import 'screens/admin/admin_dashboard_screen.dart';


// ============================================================
// APPLICATION ENTRY POINT
// ============================================================

/// Starts the Noor Library application.
///
/// This function:
/// 1. Prepares Flutter.
/// 2. Connects the application to Supabase.
/// 3. Launches the main application widget.
Future<void> main() async {
  // Ensures Flutter is ready before asynchronous initialization.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase so screens can access the backend.
  await Supabase.initialize(
    // Your existing Supabase project URL.
    url: 'https://nzklcfmkdsasryjjhqcu.supabase.co/',

    // Your existing publishable key.
    // Never place a Supabase service_role or secret key here.
    anonKey: 'sb_publishable_t4wsTHeILbuMboN-4-lwyg_9Q_KpNe0',
  );

  // Start the Noor Library application.
  runApp(const NoorLibraryApp());
}


// ============================================================
// MAIN APPLICATION WIDGET
// ============================================================

/// Root widget of the Noor Library application.
///
/// MaterialApp provides:
/// - Application navigation.
/// - Global theme and colours.
/// - Screen routing.
/// - Material Design components.
class NoorLibraryApp extends StatelessWidget {
  const NoorLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name.
      title: 'Noor Library',

      // Hide the debug banner.
      debugShowCheckedModeBanner: false,

      // Global application theme.
      theme: ThemeData(
        // Enable Material Design 3 components.
        useMaterial3: true,

        // Generate the colour scheme from Noor Library green.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF155D43),
          brightness: Brightness.light,
        ),

        // Default background for application screens.
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),

        // Global AppBar appearance.
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF155D43),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      // The first screen displayed when the application starts.
      initialRoute: AppRoutes.home,

      // Register existing routes and the admin dashboard route.
      routes: {
        // Preserve all routes already registered in your project.
        ...AppRoutes.routes,

        // Register the administrator dashboard.
        // This assumes the path is not already registered above.
        '/admin-dashboard': (context) =>
            const AdminDashboardScreen(),
      },
    );
  }
}