//class handle for exceptions
class SignupEmailFailure {
  final String message;
  const SignupEmailFailure([this.message = 'An unknown error occure']);
  factory SignupEmailFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupEmailFailure('Please Enter a Strong Password');
      case 'invalid-email':
        return const SignupEmailFailure(
            'Please Enter a valid email or email is not formated');
      case 'email-already-in-user':
        return const SignupEmailFailure(
            'Account is already exist againts this email');

      case 'operation-not-allowed':
        return const SignupEmailFailure(
            'Operation is not allowed. Please contact to customer support');
      case 'user-disabled':
        return const SignupEmailFailure('This user has been disabled');

      default:
        return const SignupEmailFailure('');
    }
  }
}
