part of 'auth_check_cubit.dart';

abstract class AuthCheckState extends Equatable {
  const AuthCheckState();
}

class AuthCheckInitial extends AuthCheckState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthCheckState {
  final UserEntity user;
  Authenticated({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UnAutheticated extends AuthCheckState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
