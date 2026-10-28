import 'package:flutter/material.dart';

/// Reusable feature card for the Noor Library home screen.
///
/// Displays an icon, title, and description inside a
/// responsive card with a tap animation.
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Gets the current theme colours and text styles.
    final theme = Theme.of(context);

    return Card(
      // Prevents the card from looking too bulky.
      margin: EdgeInsets.zero,

      // Gives the card rounded corners.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      // Uses the application's theme for the card colour.
      color: theme.colorScheme.surface,

      // A small shadow gives the card depth.
      elevation: 1,

      child: InkWell(
        // Keeps the tap animation within the rounded corners.
        borderRadius: BorderRadius.circular(18),

        // Runs the action supplied by the home screen.
        onTap: onTap,

        child: Padding(
          // Smaller padding gives the content more room.
          padding: const EdgeInsets.all(12),

          child: Column(
            // Aligns the icon and text to the left.
            crossAxisAlignment: CrossAxisAlignment.start,

            // Distributes available vertical space safely.
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              // Feature icon.
              Icon(
                icon,
                size: 27,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 8),

              // Feature title.
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Short description.
              Flexible(
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}