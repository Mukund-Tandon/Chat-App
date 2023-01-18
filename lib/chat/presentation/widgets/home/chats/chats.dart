import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Chats/chats_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_thread_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Receipt/receipt_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Typing/typing_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/pages/chat_screen.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/home/chats/cachedChatTile.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/home/chats/chats_tile.dart';
import 'package:whatsapp_clone/injection_container.dart';
import '../profile_image.dart';

class Chats extends StatefulWidget {
  final UserEntity user;
  const Chats({required this.user});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();
    // context.read<ChatsCubit>().getAllChats();
    _updatechatsOnMessageReceived();
  }

  @override
  Widget build(BuildContext context) {
    MessageBloc mb = context.read<MessageBloc>();
    ChatsCubit cb = context.read<ChatsCubit>();
    return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
      if (state is ChatsLoaded) {
        print('Chats Loaded state');
        // context.read<TypingBloc>().add(SubscribedTyping(
        //     widget.user, chats.map<String>((el) => el.from.id).toList()));
        if (state.chats.isEmpty) {
          print('chat list empty');
        }
        return ListView.builder(
            itemBuilder: (_, indx) => GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(value: cb),
                                  BlocProvider(
                                      create: (context) =>
                                          sl<MessageThreadCubit>()),
                                  BlocProvider(
                                      create: (context) => sl<ReceiptBloc>()),
                                  BlocProvider(
                                      create: (context) => sl<TypingBloc>()),
                                  BlocProvider.value(value: mb),
                                ],
                                child: ChatScreen(
                                  receiver: state.chats[indx].from,
                                  chatId: state.chats[indx].id,
                                  me: widget.user,
                                ),
                              )));

                  context.read<ChatsCubit>().getAllChats();
                  // // final user = UserEntity(
                  // //     username: "t6vt6v and ",
                  // //     photoUrl:
                  // //         "https://ogmsbwsgbdktddsmptgq.supabase.co/storage/v1/object/public/profile-photos/t6vt6vandimage_picker2824000778677661414.jpg",
                  // //     active: true,
                  // //     lastseen: DateTime.parse("2022-07-09 22:30:42.896322"));
                  // // user.id = "39fc8e16-5662-4ca8-ba0b-f32fe77b9faa";
                  // // final user = widget.user;
                  // // context.read<MessageBloc>().add(Subscribed(user));
                  // _updatechatsOnMessageReceived();
                },
                child: ChatTile(chat: state.chats[indx])),
            itemCount: state.chats.length);
      } else if (state is CachedChatState) {
        print('Chats Chahed state');
        if (state.chatList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemBuilder: (_, indx) => GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: cb,
                                    ),
                                    BlocProvider(
                                        create: (context) =>
                                            sl<MessageThreadCubit>()),
                                    BlocProvider(
                                        create: (context) => sl<ReceiptBloc>()),
                                    BlocProvider(
                                        create: (context) => sl<TypingBloc>()),
                                    BlocProvider.value(
                                      value: mb,
                                    ),
                                  ],
                                  child: ChatScreen(
                                    receiver: state.chatList[indx].receiver,
                                    chatId: state
                                        .chatList[indx].receiver.phoneNumber,
                                    me: widget.user,
                                  ),
                                )));

                    context.read<ChatsCubit>().getAllChats();
                    // // final user = UserEntity(
                    // //     username: "t6vt6v and ",
                    // //     photoUrl:
                    // //         "https://ogmsbwsgbdktddsmptgq.supabase.co/storage/v1/object/public/profile-photos/t6vt6vandimage_picker2824000778677661414.jpg",
                    // //     active: true,
                    // //     lastseen: DateTime.parse("2022-07-09 22:30:42.896322"));
                    // // user.id = "39fc8e16-5662-4ca8-ba0b-f32fe77b9faa";
                    // // final user = widget.user;
                    // // context.read<MessageBloc>().add(Subscribed(user));
                    // _updatechatsOnMessageReceived();
                  },
                  child: CachedChatTile(chat: state.chatList[indx])),
              itemCount: state.chatList.length);
        }
      } else {
        print('OH NO');
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  _updatechatsOnMessageReceived() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.messageReceived(state.message);
        if (state.message.isImage) {
          context
              .read<MessageBloc>()
              .add(MessageImageReceivedEvent(state.message));
        }
        await chatsCubit.getAllChats();
      }
    });
  }
}
