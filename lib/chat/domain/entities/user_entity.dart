import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  String username;
  String phoneNumber;
  String photoUrl;

  UserEntity(
      {required this.username,
      required this.photoUrl,
      required this.phoneNumber});

  @override
  // TODO: implement props
  List<Object?> get props => [username, photoUrl, phoneNumber];
}
