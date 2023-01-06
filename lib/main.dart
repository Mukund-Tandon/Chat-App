import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/user_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/repositories/user_repository_impl.dart';
import 'package:whatsapp_clone/chat/domain/repository/image_upload_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/user_repository.dart';
import 'package:whatsapp_clone/chat/domain/usecases/Image/upload_image_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/user/save_user_to_database_usecase.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/AuthCheck/auth_check_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Chats/chats_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Onboarding/onboarding_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Onboarding/profile_image_select_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Typing/typing_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/pages/home/home.dart';
import 'package:whatsapp_clone/chat/presentation/pages/onboarding_screen.dart';
import 'package:whatsapp_clone/chat/presentation/pages/wigetTestScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/core/superbase_service.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'chat/domain/entities/user_entity.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<OnboardingCubit>()),
          BlocProvider(create: (context) => ProfileImageSelectCubit()),
          BlocProvider(create: (context) => sl<MessageBloc>()),
          BlocProvider(create: (context) => sl<ChatsCubit>()),
          BlocProvider(
              create: (context) =>
                  sl<AuthCheckCubit>()..checkIfAuthenticated()),
          // BlocProvider(create: (context) => sl<TypingBloc>()),
        ],
        child: BlocBuilder<AuthCheckCubit, AuthCheckState>(
          builder: (context, state) {
            if (state is UnAutheticated) {
              return OnboardingScreen();
            } else if (state is Authenticated) {
              return Home(
                user: state.user,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
