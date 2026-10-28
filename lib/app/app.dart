import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

/// The root widget configures the app-wide theme and navigation.
class NoorLibraryApp extends StatelessWidget {
  const NoorLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor Library',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Named routes keep navigation in one central place.
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
