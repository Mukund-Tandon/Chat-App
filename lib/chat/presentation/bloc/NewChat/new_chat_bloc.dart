import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

import '../../../domain/usecases/user/fetch_user_usecase.dart';

part 'new_chat_event.dart';
part 'new_chat_state.dart';

class NewChatBloc extends Bloc<NewChatEvent, NewChatState> {
  final FetchUserFromPhoneNumber fetchUserFromPhoneNumber;
  NewChatBloc({required this.fetchUserFromPhoneNumber})
      : super(NewChatInitial()) {
    on<NewChatLoadingEvent>((event, emit) {
      emit(NewChatLoading());
    });
    on<NewChatFindUserEvent>((event, emit) async {
      add(NewChatLoadingEvent());
      var user = await fetchUserFromPhoneNumber.call(event.phoneNumber);
      if (user != null) {
        emit(NewChatUserFound(user: user));
      } else {
        emit(NewChatUserNotFound());
      }
    });
    on<NewChatGetContactListFromPhone>((event, emit) async {
      emit(NewChatLoading());
      var status = await Permission.contacts.status;
    });
  }
}
