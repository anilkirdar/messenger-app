class ErrorException {
  static showError(String? errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Email address already in use!';
      case 'invalid-email':
        return 'Invalid email address!!';
      case 'invalid-credential':
        return "This credential wasn't found! Please sign up.";
      default:
        'An error occurred';
    }
  }
}
