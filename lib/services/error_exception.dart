enum ErrorType { email, pass, both, general }

class ErrorException {
  static Map<String, dynamic> getError(String? errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return {
          'errorType': ErrorType.email,
          'error': 'Email address already in use!'
        };
      case 'invalid-email':
        return {
          'errorType': ErrorType.email,
          'error': 'Invalid email address!'
        };
      case 'invalid-credential':
        return {
          'errorType': ErrorType.both,
          'error': "Incorrect email or password!"
        };
      case 'network-request-failed':
        return {
          'errorType': ErrorType.general,
          'error': 'An internet error occurred',
        };
      default:
        return {
          'errorType': ErrorType.general,
          'error': 'An error occurred',
        };
    }
  }
}
