import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/routes.dart';

/// Allows Noor Library users to request a password-reset email.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  // Collects the email address entered by the user.
  final TextEditingController _emailController =
      TextEditingController();

  // Controls the loading indicator while sending the email.
  bool _isLoading = false;

  /// Requests a password-reset email from Supabase.
  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    // Make sure an email address has been entered.
    if (email.isEmpty) {
      _showMessage('Please enter your email address.');
      return;
    }

    // Perform a basic email-format check.
    final emailPattern =
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(email)) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Send the recovery email.
      //
      // Supabase redirects the user to the configured
      // FlutLab preview address after the link is opened.
      await Supabase.instance.client.auth
          .resetPasswordForEmail(
        email,
        redirectTo:
            'https://preview.flutlab.io/ahmad_islam/noor-library/',
      );

      if (!mounted) return;

      // Use neutral wording to avoid revealing whether
      // an email address has a registered account.
      _showMessage(
        'If an account exists for that email, '
        'a password-reset link will be sent.',
      );
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(
        'Unable to request a reset email. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Displays feedback in a SnackBar.
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Release the email controller when this screen closes.
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Password recovery icon.
                const Icon(
                  Icons.lock_reset_rounded,
                  size: 76,
                  color: Color(0xFF155D43),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Reset Your Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Enter the email address associated with '
                  'your account. We will help you reset '
                  'your password.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                // Email address used for account recovery.
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 22),

                // Sends the recovery request to Supabase.
                FilledButton(
                  onPressed:
                      _isLoading ? null : _sendResetEmail,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Send Reset Email'),
                ),

                const SizedBox(height: 12),

                // Returns to the existing login screen.
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        },
                  child: const Text('Back to Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}