import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:whatsapp_clone/chat/data/models/typing_event_model.dart';
import 'package:whatsapp_clone/chat/data/models/user_model.dart';

import '../../../domain/entities/typing_event_entity.dart';
import '../../../domain/entities/user_entity.dart';
import 'package:whatsapp_clone/core/superbase_service.dart';

abstract class TypingEventRemotedataSource {
  Future<bool> sendTypingEvent(TypingEventEntity typingEventEntity);
  Stream<TypingEventModel> getAllTypingEvents(
      UserEntity userEntity, List<String> userIds);
  dispose();
}

class TypingEventRemoteDataSourceImpl implements TypingEventRemotedataSource {
  final firestore = FirebaseFirestore.instance;
  // late RealtimeSubscription? streamSubscription;
  var _controller = StreamController<TypingEventModel>.broadcast();

  TypingEventRemoteDataSourceImpl();
  @override
  dispose() {
    // streamSubscription?.unsubscribe();
    _controller.close();
  }

  @override
  Stream<TypingEventModel> getAllTypingEvents(
      UserEntity userEntity, List<String> userIds) {
    _controller = StreamController<TypingEventModel>.broadcast(
        onCancel: () => print('typing event stream canceled'));
    _startReceivingTypingEvents(userEntity, userIds);

    return _controller.stream;
  }

  @override
  Future<bool> sendTypingEvent(TypingEventEntity typingEventEntity) async {
    var event = TypingEventModel(
        from: typingEventEntity.from,
        to: typingEventEntity.to,
        event: typingEventEntity.event);

    var data = event.toJson();
    // Map record = await r
    //     .table('typing_events')
    //     .insert(event.toJson(), {'conflict': 'update'}).run(_connection);
    // return record['inserted'] == 1;
    // final result = await SupabseCredentials.supabaseClient
    //     .from('typing_events')
    //     .insert([data]).execute();
    // if (result.data != null) {
    //   return true;
    // }
    // return false;
    var newdocRef = firestore.collection('typing_events').doc();
    await newdocRef.set(data);
    if (newdocRef.id.isEmpty) {
      return false;
    }
    return true;
  }

  _startReceivingTypingEvents(UserEntity userEntity, List<String> userIds) {
    // r
    //     .table('typing_events')
    //     .filter((event) {
    //       return event('to')
    //           .eq(userEntity.id)
    //           .and(r.expr(userIds).contains(event('from')));
    //     })
    //     .changes({'include_initial': true})
    //     .run(_connection)
    //     .asStream()
    //     .cast<Feed>()
    //     .listen((event) {
    //       event.forEach((feedData) {
    //         if (feedData['new_val'] == null) return;
    //         final typing = _evenFromFeed(feedData);
    //         _controller.sink.add(typing);
    //         _removeEvent(typing);
    //       });
    //     });
    // streamSubscription = SupabseCredentials.supabaseClient
    //     .from('typing_events:to=eq.${userEntity.phoneNumber}')
    //     .stream(['id'])
    //     .execute()
    //     .listen((event) {
    //       event.forEach((element) {
    //         if (userIds.contains(element['from'])) {
    //           final typing = _evenFromFeed(element);
    //           _controller.sink.add(typing);
    //           // _removeEvent(typing);
    //         }
    //       });
    //     });

    // streamSubscription = SupabseCredentials.supabaseClient
    //     .from('typing_events:to=eq.${userEntity.phoneNumber}')
    //     .on(SupabaseEventTypes.insert, (payload) {
    //   print('new typing event');
    //   var event = _evenFromFeed(payload.newRecord);
    //   _controller.sink.add(event);
    //   // _removeEvent(event);
    // }).subscribe();

    var snapshots = firestore
        .collection('typing_events')
        .where('to', isEqualTo: userEntity.phoneNumber)
        .snapshots();
    firestore.settings.copyWith(persistenceEnabled: false);
    snapshots.listen((event) {
      event.docChanges.forEach((element) {
        print('hello typing event');
        print(element.doc.data());
        var typing_event = element.doc.data();
        typing_event?.addAll({'id': element.doc.id});
        var typing_event_model = _evenFromFeed(typing_event);
        _controller.sink.add(typing_event_model);
        _removeEvent(typing_event_model);
      });
    });
  }

  TypingEventModel _evenFromFeed(feedData) {
    return TypingEventModel.fromJson(feedData);
  }

  _removeEvent(TypingEventModel event) {
    // SupabseCredentials.supabaseClient
    //     .from('typing_events')
    //     .delete()
    //     .match({'id': event.id});
    firestore.collection("typing_event").doc(event.id).delete();
  }
}
