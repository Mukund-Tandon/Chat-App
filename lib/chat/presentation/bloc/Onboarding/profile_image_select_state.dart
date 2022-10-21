part of 'profile_image_select_cubit.dart';

abstract class ProfileImageSelectState extends Equatable {
  const ProfileImageSelectState();
}

class ProfileImageSelectInitial extends ProfileImageSelectState {
  @override
  List<Object> get props => [];
}

class imageUploaded extends ProfileImageSelectState {
  File imagefile;
  String filename;
  imageUploaded({required this.imagefile, required this.filename});
  @override
  // TODO: implement props
  List<Object?> get props => [imagefile, filename];
}
