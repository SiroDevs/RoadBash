// Flutter imports:
import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String feedback, {
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool isSuccess = false,
    Duration duration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: isSuccess ? Colors.green : Colors.red,
          content: Text(
            feedback,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
  }
}

class NoActiveTasks extends StatelessWidget {
  const NoActiveTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.check_circle_outline,
            size: 48, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 16),
        Text(
          "You don't have any tasks at the moment.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}
