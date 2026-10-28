import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/books_screen.dart';
import '../screens/book_details_screen.dart';
import '../screens/book_reader_screen.dart';
import '../screens/hadith_screen.dart';
import '../screens/quran_screen.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/settings_screen.dart';
// Noor Q&A screen.
import '../screens/questions_screen.dart';

// Import the new Universal Search screen.
import '../screens/universal_search_screen.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

import '../screens/forgot_password_screen.dart';
import '../screens/reset_password_screen.dart';
/// Stores route names in one place.
///
/// This prevents spelling mistakes when navigating between screens.
class AppRoutes {
  static const home = '/';
  static const books = '/books';
  static const bookDetails = '/book-details';
  static const reader = '/reader';
  static const hadith = '/hadith';
  static const quran = '/quran';
  static const bookmarks = '/bookmarks';
  static const settings = '/settings';
    // Route for the Noor Q&A section.
  static const questions = '/questions';

  // New route for searching the entire library.
  static const search = '/search';
  static const login = '/login';
  static const register = '/register';
    // Password recovery routes.
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  /// Registers screens that do not require extra arguments.
  ///
  /// Detail and reader screens can still receive book data
  /// through MaterialPageRoute or another suitable navigation method.
  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const HomeScreen(),
        books: (_) => const BooksScreen(),
        hadith: (_) => const HadithScreen(),
        quran: (_) => const QuranScreen(),
        bookmarks: (_) => const BookmarksScreen(),
        settings: (_) => const SettingsScreen(),

        // Opens Noor Library's Universal Search.
        search: (_) => const UniversalSearchScreen(),
      // Opens the Noor Q&A home screen.
        questions: (_) => const QuestionsScreen(),
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      forgotPassword: (_) => const ForgotPasswordScreen(),
      resetPassword: (_) => const ResetPasswordScreen(),
      };
}