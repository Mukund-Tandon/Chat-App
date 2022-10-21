import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/chat/data/models/message_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:supabase/supabase.dart';
import '../../../../Global_ENV.dart';
import '../../../../core/encryption/encryption.dart';
import 'package:whatsapp_clone/core/superbase_service.dart';
import 'dart:io';

abstract class MessageRemoteDataSource {
  Future<MessageModel> sendMessage(MessageEntity messageEntity);
  Stream<MessageModel> getAllMessages({required UserEntity userEntity});
  dispose();
  Future<String> uploadImage(MessageEntity messageEntity);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  final Encryption encryption;
  var _controller = StreamController<MessageModel>.broadcast();
  // StreamSubscription? streamSubscription;
  // RealtimeSubscription? streamSubscription;
  MessageRemoteDataSourceImpl(this.encryption);
  @override
  dispose() {
    print('disposing message stream');
    // streamSubscription?.cancel();
    _controller.close();
  }

  @override
  Stream<MessageModel> getAllMessages({required UserEntity userEntity}) {
    // _controller.close();
    _controller = StreamController<MessageModel>.broadcast(
        onCancel: () => print('message stream canceled'));

    _startRecievingMessages(userEntity);

    return _controller.stream;
  }

  @override
  Future<MessageModel> sendMessage(MessageEntity messageEntity) async {
    var message = MessageModel(
        sender: messageEntity.sender,
        receiver: messageEntity.receiver,
        timestamp: messageEntity.timestamp,
        contents: messageEntity.contents,
        isImage: messageEntity.isImage,
        imageStatus: messageEntity.imageStatus);
    var data = message.toJson();
    data['contents'] = encryption.encrypt(message.contents);
    // Map record = await r.table('messages').insert(data).run(_connection);
    // return record['inserted'] == 1;

    // final result = await SupabseCredentials.supabaseClient
    //     .from('messages')
    //     .insert([data]).execute();
    var newdocRef = firestore.collection('messages').doc();
    await newdocRef.set(data);
    message.id = newdocRef.id;
    return message;
  }

  _startRecievingMessages(UserEntity userEntity) async {
    // r
    //     .table('messages')
    //     .filter({'to': userEntity.id})
    //     .changes({'include_initial': true})
    //     .run(_connection)
    //     .asStream()
    //     .cast<Feed>()
    //     .listen((event) {
    //       event.forEach((element) {
    //         if (element['new_val'] == null) return;
    //         final message = _messageFromFeed(element);
    //         _controller.sink.add(message);
    //         _removeDiliveredMessage(message);
    //       });
    //     });
    print('start subscribtion');
    // streamSubscription = SupabseCredentials.supabaseClient
    //     .from('messages:receiver=eq.${userEntity.phoneNumber}')
    //     .stream(['id'])
    //     .execute()
    //     .listen((event) {
    //       event.forEach((element) {
    //         final message = _messageFromFeed(element);
    //         _controller.sink.add(message);
    //         // _removeDiliveredMessage(message);
    //       });
    //     });

    // Stream st = SupabseCredentials.supabaseClient
    //     .from('messages:receiver=eq.${userEntity.phoneNumber}')
    //     .stream(['id'])
    //     .execute()
    //     .asBroadcastStream();
    //
    // st.listen((event) {
    //   print('new message event');
    //   event.forEach((element) {
    //     final message = _messageFromFeed(element);
    //     _controller.sink.add(message);
    //     // _removeDiliveredMessage(message);
    //   });
    // }).onDone(() {
    //   print('done with sreaming in data source');
    // });

    // streamSubscription = SupabseCredentials.supabaseClient
    //     .from('messages:receiver=eq.${userEntity.phoneNumber}')
    //     .stream(['id'])
    //     .execute()
    //     .map((event) => ())

    // streamSubscription?.onDone(() {
    //   print("stream done");
    // });

    // streamSubscription = SupabseCredentials.supabaseClient
    //     .from('messages:receiver=eq.${userEntity.phoneNumber}')
    //     .on(SupabaseEventTypes.insert, (payload) {
    //   final message = _messageFromFeed(payload.newRecord);
    //   _controller.sink.add(message);
    // }).subscribe();

    var snapshots = firestore
        .collection('messages')
        .where('receiver', isEqualTo: userEntity.phoneNumber)
        .snapshots();
    firestore.settings.copyWith(persistenceEnabled: false);
    snapshots.listen((event) {
      event.docChanges.forEach((element) {
        print('hello');
        print(element.doc.data());
        var message = element.doc.data();
        message?.addAll({'id': element.doc.id});
        var messagemodel = _messageFromFeed(message);
        _controller.sink.add(messagemodel);
        _removeDiliveredMessage(messagemodel);
      });
    });
  }

  MessageModel _messageFromFeed(element) {
    element['contents'] = encryption.decrypt(element['contents']);
    return MessageModel.fromJson(element);
  }

  _removeDiliveredMessage(MessageModel messageModel) async {
    // var a = SupabseCredentials.supabaseClient
    //     .from('messages')
    //     .delete()
    //     .match({'id': messageModel.id}).execute();
    firestore.collection("messages").doc(messageModel.id).delete();
  }

  @override
  Future<String> uploadImage(MessageEntity messageEntity) async {
    dynamic file = File(messageEntity.contents);
    String filename =
        messageEntity.contents.substring(messageEntity.contents.length - 15);
    final res = await SupabseCredentials.supabaseClient.storage
        .from('profile-photos')
        .upload(filename, file);
    final url = await SupabseCredentials.supabaseClient.storage
        .from('profile-photos')
        .getPublicUrl(filename);
    return url.data!;
  }
}
