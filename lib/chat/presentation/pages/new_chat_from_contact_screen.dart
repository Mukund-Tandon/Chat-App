import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/NewChat/new_chat_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/pages/chat_screen.dart';

import '../../../injection_container.dart';
import '../bloc/Chats/chats_cubit.dart';
import '../bloc/Message/message_bloc.dart';
import '../bloc/Message/message_thread_cubit.dart';
import '../bloc/Receipt/receipt_bloc.dart';
import '../bloc/Typing/typing_bloc.dart';

class NewChatFromContactScreen extends StatelessWidget {
  final UserEntity me;
  const NewChatFromContactScreen({Key? key, required this.me})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneNumber = '';
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NewChatBloc, NewChatState>(
          builder: (_, state) {
            if (state is NewChatLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (state is NewChatUserNotFound) {
                const snackBar = SnackBar(
                    content: Text(
                  'Phone NUmber Not Found',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ));
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              }
              if (state is NewChatUserFound) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (context) => sl<ChatsCubit>()),
                          BlocProvider(
                              create: (context) => sl<MessageThreadCubit>()),
                          BlocProvider(create: (context) => sl<ReceiptBloc>()),
                          BlocProvider(create: (context) => sl<TypingBloc>()),
                          BlocProvider(create: (context) => sl<MessageBloc>()),
                        ],
                        child: ChatScreen(
                            receiver: state.user,
                            chatId: state.user.phoneNumber,
                            me: me),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                });
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      'Enter Phone Number',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      cursorColor: Colors.green,
                      cursorHeight: 25,
                      onChanged: (val) {
                        phoneNumber = val;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.black54))),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<NewChatBloc>().add(
                            NewChatFindUserEvent(phoneNumber: phoneNumber));
                      },
                      child: const Text(
                        'Go',
                        style: TextStyle(color: Colors.green),
                      ))
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
