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

class RegisterRequest {
  String username;
  String password;
  String countryCode;
  String email;
  String phone;
  String photo;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.countryCode,
    required this.email,
    required this.phone,
    required this.photo,
  });
}
