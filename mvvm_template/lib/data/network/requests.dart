class LoginRequest {
  String email;
  String password;

  LoginRequest({
    required this.email,
    required this.password,
  });
}

class ForgotPasswordRequest {
  String email;

  ForgotPasswordRequest({
    required this.email,
  });
}
