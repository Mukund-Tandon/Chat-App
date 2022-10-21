import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
part 'profile_image_select_state.dart';

class ProfileImageSelectCubit extends Cubit<ProfileImageSelectState> {
  ProfileImageSelectCubit() : super(ProfileImageSelectInitial());
  final _picker = ImagePicker();
  Future<void> getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File imagefile = File(image!.path);
    if (imagefile == null) {
      return;
    }

    emit(imageUploaded(imagefile: imagefile, filename: image.name));
  }
}
