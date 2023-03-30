import 'package:equatable/equatable.dart';
import 'package:miss_independent/models/category.dart';

import '../../../common/enums/status.dart';
import '../../../models/user.dart';

class AuthState extends Equatable {
  const AuthState(
      {this.user,
      this.email,
      this.token,
      this.isInActive,
      this.isNotCreatedProfile,
      this.loginStatus,
      this.loginMessage,
      this.signUpStatus,
      this.signUpMessage,
      this.verifyStatus,
      this.verifyMessage,
      this.resendStatus,
      this.resendMessage,
      this.createProfileStatus,
      this.createProfileMessage,
      this.forgotPassStatus,
      this.forgotPassMessage,
      this.deactivateStatus,
      this.deactivateMessage,
      this.generalCategories,
      this.softCategories,
      this.serviceCategories,
      this.coachingCategories});

  final User? user;
  final String? email;
  final String? token;
  final bool? isInActive;
  final bool? isNotCreatedProfile;
  final RequestStatus? loginStatus;
  final String? loginMessage;

  final RequestStatus? signUpStatus;
  final String? signUpMessage;

  final RequestStatus? verifyStatus;
  final String? verifyMessage;

  final RequestStatus? resendStatus;
  final String? resendMessage;

  final RequestStatus? createProfileStatus;
  final String? createProfileMessage;

  final RequestStatus? forgotPassStatus;
  final String? forgotPassMessage;

  final RequestStatus? deactivateStatus;
  final String? deactivateMessage;

  final List<Category>? generalCategories;
  final List<Category>? softCategories;
  final List<Category>? serviceCategories;
  final List<Category>? coachingCategories;

  factory AuthState.initState() => const AuthState();

  AuthState copyWith({
    User? user,
    String? email,
    String? token,
    bool? isInActive,
    bool? isNotCreatedProfile,
    RequestStatus? loginStatus,
    String? loginMessage,
    RequestStatus? signUpStatus,
    String? signUpMessage,
    RequestStatus? verifyStatus,
    String? verifyMessage,
    RequestStatus? resendStatus,
    String? resendMessage,
    RequestStatus? createProfileStatus,
    String? createProfileMessage,
    RequestStatus? forgotPassStatus,
    String? forgotPassMessage,
    RequestStatus? deactivateStatus,
    String? deactivateMessage,
    List<Category>? generalCategories,
    List<Category>? softCategories,
    List<Category>? serviceCategories,
    List<Category>? coachingCategories,
  }) {
    return AuthState(
      user: user ?? this.user,
      email: email ?? this.email,
      token: token ?? this.token,
      isInActive: isInActive ?? this.isInActive,
      isNotCreatedProfile: isNotCreatedProfile ?? this.isNotCreatedProfile,
      loginStatus: loginStatus ?? this.loginStatus,
      loginMessage: loginMessage ?? this.loginMessage,
      signUpStatus: signUpStatus ?? this.signUpStatus,
      signUpMessage: signUpMessage ?? this.signUpMessage,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      verifyMessage: verifyMessage ?? this.verifyMessage,
      resendStatus: resendStatus ?? this.resendStatus,
      resendMessage: resendMessage ?? this.resendMessage,
      createProfileStatus: createProfileStatus ?? this.createProfileStatus,
      createProfileMessage: createProfileMessage ?? this.createProfileMessage,
      forgotPassStatus: forgotPassStatus ?? this.forgotPassStatus,
      forgotPassMessage: forgotPassMessage ?? this.forgotPassMessage,
      deactivateStatus: deactivateStatus ?? this.deactivateStatus,
      deactivateMessage: deactivateMessage ?? this.deactivateMessage,
      generalCategories: generalCategories ?? this.generalCategories,
      softCategories: softCategories ?? this.softCategories,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      coachingCategories: coachingCategories ?? this.coachingCategories,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        user,
        email,
        token,
        isInActive,
        isNotCreatedProfile,
        loginStatus,
        loginMessage,
        signUpStatus,
        signUpMessage,
        verifyStatus,
        verifyMessage,
        resendStatus,
        resendMessage,
        createProfileStatus,
        createProfileMessage,
        forgotPassStatus,
        forgotPassMessage,
        deactivateStatus,
        deactivateMessage,
        generalCategories,
        softCategories,
        serviceCategories,
        coachingCategories
      ];
}
