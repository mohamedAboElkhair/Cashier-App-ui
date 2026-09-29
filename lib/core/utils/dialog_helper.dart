import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

import 'animated_snack_dialog.dart';

/// Shows a formatted error dialog with the error message
void showErrorDialog(BuildContext context, String message) {
  showAnimatedSnackDialog(
    context,
    message: _formatErrorMessage(message),
    type: AnimatedSnackBarType.error,
  );
}

/// Formats error message for better readability
String _formatErrorMessage(String message) {
  if (message.isEmpty) {
    return 'An error occurred. Please try again.';
  }

  // If it's already a well-formatted message from ErrorParser, use it as-is
  if (message.contains('is already registered') ||
      message.contains('is already exists') ||
      message.contains('already exists')) {
    return message;
  }

  // Handle null check operator errors
  if (message.contains('Null check operator used on null value')) {
    return 'An unexpected error occurred. Please try again.';
  }

  return message;
}

/// Shows a success message
void showSuccessMessage(BuildContext context, String message) {
  showAnimatedSnackDialog(
    context,
    message: message,
    type: AnimatedSnackBarType.success,
  );
}

/// Shows a warning message
void showWarningMessage(BuildContext context, String message) {
  showAnimatedSnackDialog(
    context,
    message: message,
    type: AnimatedSnackBarType.warning,
  );
}
