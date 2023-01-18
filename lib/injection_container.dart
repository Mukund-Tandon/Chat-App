import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/chat/data/datasources/localdatasources/local_chat_local_datasource.dart';
import 'package:whatsapp_clone/chat/data/datasources/localdatasources/logged_in_user_local_cache_datasource.dart';
import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/image_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/message_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/receipt_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/typing_event_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/user_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/repositories/image_upload_repository_impl.dart';
import 'package:whatsapp_clone/chat/data/repositories/local_chat_repository.dart';
import 'package:whatsapp_clone/chat/data/repositories/logged_in_user_local_cache_repository_impl.dart';
import 'package:whatsapp_clone/chat/data/repositories/message_repository_impl.dart';
import 'package:whatsapp_clone/chat/data/repositories/receipt_repository_impl.dart';
import 'package:whatsapp_clone/chat/data/repositories/typing_event_repository_impl.dart';
import 'package:whatsapp_clone/chat/data/repositories/user_repository_impl.dart';
import 'package:whatsapp_clone/chat/domain/repository/image_upload_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/logged_in_user_local_cache_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/message_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/receipt_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/typing_event_repository.dart';
import 'package:whatsapp_clone/chat/domain/repository/user_repository.dart';
import 'package:whatsapp_clone/chat/domain/usecases/Image/upload_image_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatCache/get_cached_chats.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/find_all_chats.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/get_message_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/save_message_locally.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/received_message_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/save_image_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/save_network_image.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/update_message_receipt.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/update_message_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/update_message_with_id_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/imputChecks/username_imput_check_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/localCache/fetch_logged_in_user_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/localCache/save_logged_in_user_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/dispose_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/get_all_message_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/send_message_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/upload_image_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/receipt/dispose_receipt_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/receipt/get_all_receipt_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/receipt/send_receipt_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/typingevent/dispose_typing_event.dart';
import 'package:whatsapp_clone/chat/domain/usecases/typingevent/get_typing_event_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/typingevent/send_typing_event_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/user/disconnect_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/user/fetch_user_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/user/get_online_users_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/user/save_user_to_database_usecase.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/AuthCheck/auth_check_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Chats/chats_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_thread_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/NewChat/new_chat_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Onboarding/onboarding_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Receipt/receipt_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Typing/typing_bloc.dart';
import 'package:whatsapp_clone/core/create_local_db.dart';
import 'package:whatsapp_clone/core/encryption/encryption.dart';
import 'package:whatsapp_clone/core/encryption/encryption_impl.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //Bloc
  sl.registerFactory(() => OnboardingCubit(
      saveUserToDatabase: sl(), uploadImage: sl(), saveLoggedInUser: sl()));
  sl.registerFactory(() => MessageBloc(
      updateMessageWithId: sl(),
      updateMessageUsecase: sl(),
      uploadImageUsecase: sl(),
      getAllMessages: sl(),
      sendMessage: sl(),
      dispose: sl(),
      saveImageUsecase: sl(),
      saveNetworkImage: sl(),
      saveMessageLocallyUsecase: sl()));
  sl.registerFactory(() => ReceiptBloc(
      sendReceipt: sl(), disposeReceipt: sl(), getAllReceipts: sl()));
  sl.registerFactory(() => TypingBloc(
      sendTypingEvents: sl(), disposeTypingEvent: sl(), getTypingEvents: sl()));
  sl.registerFactory(() => ChatsCubit(
      findAllChats: sl(), receivedMessage: sl(), getCachedChats: sl()));
  sl.registerFactory(() => AuthCheckCubit(fetchLoggedInUser: sl()));
  sl.registerFactory(() => NewChatBloc(fetchUserFromPhoneNumber: sl()));

  sl.registerFactory(() => MessageThreadCubit(
        getMessagesFromPhoneLocalWithChatId: sl(),
        receivedMessage: sl(),
        saveMessageLocallyUsecase: sl(),
        updateMessageReceipt: sl(),
        sendMessage: sl(),
      ));
  //usecases
  sl.registerLazySingleton<FindAllChats>(
      () => FindAllChats(localChatRepository: sl()));
  sl.registerLazySingleton<ReceivedMessage>(
      () => ReceivedMessage(localChatRepository: sl()));
  sl.registerLazySingleton<GetMessagesFromPhoneLocalWithChatId>(
      () => GetMessagesFromPhoneLocalWithChatId(localChatRepository: sl()));
  sl.registerLazySingleton<SaveMessageLocallyUsecase>(
      () => SaveMessageLocallyUsecase(localChatRepository: sl()));
  sl.registerLazySingleton<UpdateMessageReceipt>(
      () => UpdateMessageReceipt(localChatRepository: sl()));
  sl.registerLazySingleton<GetCachedChats>(
      () => GetCachedChats(localChatRepository: sl()));
  sl.registerLazySingleton<UploadImage>(() => UploadImage(sl()));
  sl.registerLazySingleton<SaveImageUsecase>(
      () => SaveImageUsecase(localChatRepository: sl()));
  sl.registerLazySingleton<UpdateMessageUsecase>(
      () => UpdateMessageUsecase(localChatRepository: sl()));
  sl.registerLazySingleton<UpdateMessageWithId>(
      () => UpdateMessageWithId(localChatRepository: sl()));
  sl.registerLazySingleton<SaveNetworkImage>(
      () => SaveNetworkImage(localChatRepository: sl()));

  sl.registerLazySingleton<Dispose>(() => Dispose(sl()));
  sl.registerLazySingleton<GetAllMessages>(() => GetAllMessages(sl()));
  sl.registerLazySingleton<SendMessage>(() => SendMessage(sl()));
  sl.registerLazySingleton<UploadImageUsecase>(
      () => UploadImageUsecase(messageRepository: sl()));

  sl.registerLazySingleton<DisposeReceipt>(() => DisposeReceipt(sl()));
  sl.registerLazySingleton<GetAllReceipts>(() => GetAllReceipts(sl()));
  sl.registerLazySingleton<SendReceipt>(() => SendReceipt(sl()));

  sl.registerLazySingleton<DisposeTypingEvent>(() => DisposeTypingEvent(sl()));
  sl.registerLazySingleton<GetTypingEvents>(() => GetTypingEvents(sl()));
  sl.registerLazySingleton<SendTypingEvents>(() => SendTypingEvents(sl()));

  sl.registerLazySingleton<SaveUserToDatabase>(() => SaveUserToDatabase(sl()));
  sl.registerLazySingleton<Disconnect>(() => Disconnect(sl()));
  sl.registerLazySingleton<UserNameInputCheck>(() => UserNameInputCheck());
  sl.registerLazySingleton<FetchUserFromPhoneNumber>(
      () => FetchUserFromPhoneNumber(userRepository: sl()));

  sl.registerLazySingleton<SaveLoggedInUser>(
      () => SaveLoggedInUser(loggedInUserLocalCacheRepository: sl()));
  sl.registerLazySingleton<FetchLoggedInUser>(
      () => FetchLoggedInUser(loggedInUserLocalCacheRepository: sl()));

  //repository
  sl.registerLazySingleton<ImageUploadRepository>(
      () => ImageUploadRepositoryImp(sl()));
  sl.registerLazySingleton<LocalChatRepository>(
      () => LocalChatRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(sl()));
  sl.registerLazySingleton<ReceiptRepository>(
      () => ReceiptRepositoryImpl(sl()));
  sl.registerLazySingleton<TypingEventRepository>(
      () => TypingEventRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<LoggedInUserLocalCacheRepository>(() =>
      LoggedInUserLocalCacheRepositoryImpl(
          loggedInUserLocalCacheDataSource: sl()));

  //datasources
  sl.registerLazySingleton<LocalChatLocalDataSource>(() =>
      LocalChatLocalDataSourceImpl(
          db: sl(), sharedPreferences: sl(), uuid: sl()));
  sl.registerLazySingleton<ImageRemoteDataSource>(
      () => ImageRemoteDataSourceImpl());
  sl.registerLazySingleton<MessageRemoteDataSource>(
      () => MessageRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ReceiptRemoteDataSource>(
      () => ReceiptRemoteDataSourceImpl());
  sl.registerLazySingleton<TypingEventRemotedataSource>(
      () => TypingEventRemoteDataSourceImpl());
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());
  sl.registerLazySingleton<LoggedInUserLocalCacheDataSource>(
      () => LoggedInUserLocalCacheDataSourceImpl(sharedPreferences: sl()));

  //external

  //Encryption
  sl.registerLazySingleton<Encryption>(() => EncryptionImpl(sl()));
  sl.registerLazySingleton(() => Encrypter(AES(Key.fromLength(32))));

  //database
  final database = await LocalDatabaseCreate().createDatabase();
  sl.registerLazySingleton(() => database);

  final sp = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sp);

  final uuid = Uuid();
  sl.registerLazySingleton(() => uuid);
}
