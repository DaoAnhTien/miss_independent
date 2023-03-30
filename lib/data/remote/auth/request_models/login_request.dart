class LoginRequest {
  LoginRequest({this.fcmToken, this.email, this.password});

  final String? email;
  final String? password;
  final String? fcmToken;

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "fcpm_token": fcmToken ?? 'abc',
    };
  }
}
