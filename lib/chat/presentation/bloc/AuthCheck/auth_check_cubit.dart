import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/usecases/localCache/fetch_logged_in_user_usecase.dart';

part 'auth_check_state.dart';

class AuthCheckCubit extends Cubit<AuthCheckState> {
  AuthCheckCubit({required this.fetchLoggedInUser}) : super(AuthCheckInitial());
  final FetchLoggedInUser fetchLoggedInUser;

  void checkIfAuthenticated() {
    UserEntity? user = fetchLoggedInUser.call('USER');

    if (user == null) {
      emit(UnAutheticated());
    } else {
      emit(Authenticated(user: user));
    }
  }
}
