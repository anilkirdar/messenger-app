class ErrorException {
  static showError(String? errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email address is already in use!';
      case 'invalid-credential':
        return "This credential wasn't found! Please sign up.";
      default:
        'An error occurred';
    }
  }
}
