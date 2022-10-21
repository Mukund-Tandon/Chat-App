import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/Image/upload_image_usecase.dart';
import '../../../domain/usecases/localCache/fetch_logged_in_user_usecase.dart';
import '../../../domain/usecases/localCache/save_logged_in_user_usecase.dart';
import '../../../domain/usecases/user/save_user_to_database_usecase.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final SaveUserToDatabase saveUserToDatabase;
  final UploadImage uploadImage;
  final SaveLoggedInUser saveLoggedInUser;
  OnboardingCubit(
      {required this.saveUserToDatabase,
      required this.uploadImage,
      required this.saveLoggedInUser})
      : super(OnboardingInitial());
  Future<void> connectUser(
      String name, File imagefile, String fileName, String phoneNumber) async {
    emit(Loading());

    final url = await uploadImage.call(imagefile, name, fileName);
    final user =
        UserEntity(username: name, photoUrl: url!, phoneNumber: phoneNumber);
    final createdUser = await saveUserToDatabase.call(user);
    final userJson = {
      'username': createdUser.username,
      'photo_url': createdUser.photoUrl,
      'phoneNumber': createdUser.phoneNumber
    };
    await saveLoggedInUser.call('USER', userJson);
    emit(OnboardingSuccess(createdUser));
  }
}
