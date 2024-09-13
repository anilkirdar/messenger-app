import '../widgets/platform_sensitive_alert_dialog.dart';

class ErrorException {
  static showError(String? errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email address already in use!';
      case 'username-already-in-use':
        return const PlatformSensitiveAlertDialog(
          title: 'Alert',
          content: "This username already in use!",
          mainButtonText: 'Done',
        );
      case 'invalid-credential':
        return "This credential wasn't found! Please sign up.";
      default:
        'An error occurred';
    }
  }
}
