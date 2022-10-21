import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required String username,
      required String photoUrl,
      required String phoneNumber})
      : super(username: username, photoUrl: photoUrl, phoneNumber: phoneNumber);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = UserModel(
        username: json['username'],
        photoUrl: json['photo_url'],
        phoneNumber: json['phoneNumber']);
    return user;
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'photo_url': photoUrl,
      'phoneNumber': phoneNumber
    };
  }
}
