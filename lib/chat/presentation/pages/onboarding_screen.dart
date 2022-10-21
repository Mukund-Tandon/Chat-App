import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_clone/chat/domain/usecases/imputChecks/username_imput_check_usecase.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Onboarding/onboarding_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Onboarding/profile_image_select_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/pages/home/home.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/Onboarbing/profile_image_add.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/Onboarbing/username_textfield.dart';
import 'package:whatsapp_clone/injection_container.dart';

import '../bloc/AuthCheck/auth_check_cubit.dart';
import '../bloc/Chats/chats_cubit.dart';
import '../bloc/Message/message_bloc.dart';
import '../bloc/Typing/typing_bloc.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen();
  String userName = '';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    MessageBloc mb = context.read<MessageBloc>();
    ChatsCubit cb = context.read<ChatsCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 100,
            ),
            const Spacer(),
            const ProfileUpload(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                cursorColor: Colors.black54,
                onChanged: (val) {
                  userName = val;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black54)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black54))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                cursorColor: Colors.black54,
                onChanged: (val) {
                  phoneNumber = val;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black54)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.black54))),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ElevatedButton(
                onPressed: () async {
                  final error = sl<UserNameInputCheck>().call(userName);
                  if (error.isNotEmpty) {
                    final snackBar = SnackBar(
                        content: Text(
                      error,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    final profileImageSelectState =
                        context.read<ProfileImageSelectCubit>().state;
                    late final profileimage;
                    late final fileName;
                    if (profileImageSelectState is imageUploaded) {
                      profileimage = profileImageSelectState.imagefile;
                      fileName = profileImageSelectState.filename;
                    } else {
                      profileimage = File('assets/images/download.jpeg');
                      fileName = userName;
                    }
                    await context.read<OnboardingCubit>().connectUser(
                        userName, profileimage, fileName, phoneNumber);
                  }
                },
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    elevation: MaterialStateProperty.all(5),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ))),
              ),
            ),
            Spacer(),
            BlocConsumer<OnboardingCubit, OnboardingState>(
              builder: (context, state) => state is Loading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(),
              listener: (_, state) {
                if (state is OnboardingSuccess) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) => sl<OnboardingCubit>()),
                            BlocProvider(
                                create: (context) => ProfileImageSelectCubit()),
                            BlocProvider.value(
                              value: mb,
                            ),
                            BlocProvider.value(
                              value: cb,
                            ),
                            BlocProvider(
                                create: (context) => sl<AuthCheckCubit>()
                                  ..checkIfAuthenticated()),
                          ],
                          child: Home(user: state.user),
                        ),
                      ),
                      (Route<dynamic> route) => false);
                }
              },
            ),
            Spacer()
          ],
        ),
      )),
    );
  }
}
