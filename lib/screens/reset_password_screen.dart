import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/routes.dart';

/// Allows a user with a valid recovery session to change
/// their Noor Library account password.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  // Controllers collect and confirm the new password.
  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Supabase client used for authentication.
  final SupabaseClient _supabase =
      Supabase.instance.client;

  // Listen for Supabase recovery events.
  StreamSubscription<AuthState>? _authSubscription;

  // Controls the loading indicator during a password update.
  bool _isLoading = false;

  // Prevents password changes until recovery is confirmed.
  bool _recoverySessionReady = false;

  // Controls password visibility.
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Shows errors when the page was opened without recovery.
  String? _recoveryError;

  @override
  void initState() {
    super.initState();

    // Listen for Supabase's password-recovery event.
    _authSubscription =
        _supabase.auth.onAuthStateChange.listen(
      (AuthState state) {
        if (!mounted) return;

        if (state.event == AuthChangeEvent.passwordRecovery) {
          setState(() {
            _recoverySessionReady = true;
            _recoveryError = null;
          });
        }
      },
    );

    // If a recovery session already exists, allow the form.
    //
    // This is a preliminary check. The recovery event and
    // redirect/session handling must still be configured.
    if (_supabase.auth.currentSession != null) {
      _recoverySessionReady = true;
    }
  }

  /// Validates and saves the new password.
  Future<void> _updatePassword() async {
    final password = _passwordController.text;
    final confirmPassword =
        _confirmPasswordController.text;

    // Require a valid recovery session.
    if (!_recoverySessionReady) {
      _showMessage(
        'Open the password-reset link from your email first.',
      );
      return;
    }

    // Require a password of at least eight characters.
    if (password.length < 8) {
      _showMessage(
        'Your new password must contain at least 8 characters.',
      );
      return;
    }

    // Both password entries must match.
    if (password != confirmPassword) {
      _showMessage('The passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Ask Supabase to save the new password.
      await _supabase.auth.updateUser(
        UserAttributes(password: password),
      );

      if (!mounted) return;

      _showMessage('Your password has been updated.');

      // End the recovery session so the user signs in again.
      await _supabase.auth.signOut();

      if (!mounted) return;

      // Return to the login screen.
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(
        'Unable to update your password. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Displays a short message.
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Stop listening when the screen is removed.
    _authSubscription?.cancel();

    // Release text controllers.
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.password_rounded,
                  size: 76,
                  color: Color(0xFF155D43),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Create a New Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Explain why the recovery link is necessary.
                Text(
                  _recoverySessionReady
                      ? 'Enter your new password below.'
                      : 'Open the password-reset link from '
                          'your email to continue.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                if (!_recoverySessionReady)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'A valid password-recovery session '
                        'has not been detected. Open the '
                        'link from your recovery email, '
                        'then return to this screen.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // New password input.
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled:
                      _recoverySessionReady && !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    prefixIcon:
                        const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Confirmation input prevents typing mistakes.
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  enabled:
                      _recoverySessionReady && !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Confirm new password',
                    prefixIcon:
                        const Icon(Icons.lock_reset_outlined),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Only allow submission after recovery is detected.
                FilledButton(
                  onPressed: _recoverySessionReady &&
                          !_isLoading
                      ? _updatePassword
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Update Password'),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.login,
                            (route) => false,
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