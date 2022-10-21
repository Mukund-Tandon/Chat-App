import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/chat/domain/entities/typing_event_entity.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/typingevent/dispose_typing_event.dart';
import '../../../domain/usecases/typingevent/get_typing_event_usecase.dart';
import '../../../domain/usecases/typingevent/send_typing_event_usecase.dart';

part 'typing_event.dart';
part 'typing_state.dart';

class TypingBloc extends Bloc<TypingEvent, TypingState> {
  StreamSubscription? streamSubscription;
  final GetTypingEvents getTypingEvents;
  final SendTypingEvents sendTypingEvents;
  final DisposeTypingEvent disposeTypingEvent;
  TypingBloc(
      {required this.sendTypingEvents,
      required this.disposeTypingEvent,
      required this.getTypingEvents})
      : super(TypingInitial()) {
    on<SubscribedTyping>((event, emit) async {
      if (event.userWithChat.isEmpty) {
        add(NotSubscribed());
        return;
      }
      await streamSubscription?.cancel();
      streamSubscription = getTypingEvents
          .call(event.user, event.userWithChat)
          .listen((typingEvent) {
        add(TypingEventReceived(typingEvent));
      });
    });
    on<TypingEventReceived>((event, emit) {
      emit(TypingEventReceivedSuccess(event.typingEvent));
    });
    on<TypingEventSent>((event, emit) async {
      await sendTypingEvents.call(event.typingEvent);
      emit(TypingEventSentSuccess(event.typingEvent));
    });
    on<NotSubscribed>((event, emit) {
      emit(TypingInitial());
    });
  }
  @override
  Future<void> close() async {
    streamSubscription?.cancel();
    disposeTypingEvent.call();
    print('CALLING TYPING CLOSE ###');
    super.close();
  }
}
