class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Minimum 8 chars, 1 upper, 1 lower, 1 digit or symbol
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d!@#\$&*~]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }
}