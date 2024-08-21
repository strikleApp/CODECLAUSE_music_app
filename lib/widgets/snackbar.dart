import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
