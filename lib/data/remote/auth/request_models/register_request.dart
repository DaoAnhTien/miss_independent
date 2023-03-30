import 'package:miss_independent/common/utils/extensions/interable_extension.dart';

class RegisterRequest {
  RegisterRequest({this.fcmToken, this.email, this.password, this.dob});

  final String? email;
  final String? password;
  final String? fcmToken;
  final String? dob;

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "fcpm_token": fcmToken,
      "dob": dob
    }..removeNullAndEmpty();
  }
}
