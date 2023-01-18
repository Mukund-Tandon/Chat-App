import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Chats/chats_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/NewChat/new_chat_bloc.dart';

import '../../../../core/superbase_service.dart';
import '../../../../injection_container.dart';
import '../../widgets/home/chats/chats.dart';
import '../new_chat_from_contact_screen.dart';

class Home extends StatefulWidget {
  final UserEntity user;

  Home({required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Future<void> doStuff() async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // String? token = await messaging.getToken();
    // final firestore = FirebaseFirestore.instance;

    // if (token != null) {
    //   // await SupabseCredentials.supabaseClient.rpc('update_fcm_key', params: {
    //   //   'fkey': token,
    //   //   'ph': widget.user.phoneNumber,
    //   // }).execute();
    //   await firestore
    //       .collection('fcm_keys')
    //       .doc(widget.user.phoneNumber)
    //       .set({'fkey': token});
    // }
    Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    doStuff();
    context.read<ChatsCubit>().getAllChats();
    // final user = UserEntity(
    //     username: "t6vt6v and ",
    //     photoUrl:
    //         "https://ogmsbwsgbdktddsmptgq.supabase.co/storage/v1/object/public/profile-photos/t6vt6vandimage_picker2824000778677661414.jpg",
    //     active: true,
    //     lastseen: DateTime.parse("2022-07-09 22:30:42.896322"));
    // user.id = "39fc8e16-5662-4ca8-ba0b-f32fe77b9faa";
    final user = widget.user;
    context.read<MessageBloc>().add(Subscribed(user));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff128C7E),
      ),
      child: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xff00A884),
                child: const Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: Icon(
                    Icons.message,
                    size: 24,
                  ),
                ),
                onPressed: () async {
                  var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => sl<NewChatBloc>(),
                                child: NewChatFromContactScreen(
                                  me: widget.user,
                                ),
                              )));

                  context.read<ChatsCubit>().getAllChats();
                }),
            appBar: AppBar(
              backgroundColor: const Color(0xff128C7E),
              toolbarHeight: 60,
              title: const Text(
                'ChatApp',
                style: TextStyle(),
              ),
            ),
            body: Chats(
              user: widget.user,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
