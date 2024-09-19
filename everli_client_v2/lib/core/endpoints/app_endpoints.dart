class AppEndpoints {
  static const String test = '/';

  static const String registerUser = '/auth/register';
  static const String authenticateUser = '/auth/login';
  static const String sendPassResetCode = '/auth/forgot_password';
  static const String checkResetPassCode = '/auth/check_code';
  static const String updatePass = '/auth/update_pass';
  static const String refreshToken = '/auth/refresh';

  static const String createUser = '/users'; // POST
  static const String getUser = '/users';    // GET
  static const String updateUser = '/users'; // PATCH
  static const String deleteUser = '/users'; // DELETE
}
