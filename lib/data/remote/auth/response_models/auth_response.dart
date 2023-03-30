import 'package:miss_independent/common/utils/utils.dart';

class AuthResponse {
  AuthResponse(
      {this.id,
      this.name,
      this.token,
      this.isInActive,
      this.isNotCreatedProfile});

  final int? id;
  final String? name;
  final String? token;
  final bool? isInActive;
  final bool? isNotCreatedProfile;

  factory AuthResponse.fromJson(Map<String?, dynamic>? json) => AuthResponse(
        id: parseInt(json?['id']),
        name: json?["name"],
        token: json?["token"],
      );

  AuthResponse copyWith({bool? isInActive, bool? isNotCreatedProfile}) {
    return AuthResponse(
        isInActive: isInActive ?? this.isInActive,
        isNotCreatedProfile: isNotCreatedProfile ?? this.isNotCreatedProfile,
        id: id,
        name: name,
        token: token);
  }
}
