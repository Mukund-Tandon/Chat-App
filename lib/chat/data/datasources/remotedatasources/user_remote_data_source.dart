import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/Global_ENV.dart';
import 'package:whatsapp_clone/chat/data/models/user_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:supabase/supabase.dart';
import 'package:whatsapp_clone/core/superbase_service.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> connect(UserEntity userEntity);
  Future<List<UserModel>> getOnlineUsers();
  Future<void> disconnect(UserEntity userEntity);
  Future<UserModel?> fetch(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  UserRemoteDataSourceImpl();
  @override
  Future<UserModel> connect(UserEntity userEntity) async {
    print('connecting user');
    final user = UserModel(
        username: userEntity.username,
        photoUrl: userEntity.photoUrl,
        phoneNumber: userEntity.phoneNumber);
    var data = user.toJson();
    data = {
      'username': userEntity.username,
      'photo_url': userEntity.photoUrl,
    };

    // final result = await SupabseCredentials.supabaseClient
    //     .from('users')
    //     .insert([data])
    //     .execute()
    //     .catchError((error) {});
    //
    // return UserModel.fromJson(result.data[0]);
    var newdocRef = firestore.collection('users').doc(userEntity.phoneNumber);
    await newdocRef.set(data).onError((error, stackTrace) => print(error));

    return user;
  }

  @override
  Future<List<UserModel>> getOnlineUsers() async {
    // Cursor users =
    //     await r.table('users').filter({'active': true}).run(_connection);
    // final userList = await users.toList();
    // return userList.map((e) => UserModel.fromJson(e)).toList();
    final result = await SupabseCredentials.supabaseClient
        .from('users')
        .select()
        .eq('active', true)
        .execute();
    final data = result.data;
    List<UserModel> list = [];
    for (var i in data) {
      list.add(UserModel.fromJson(i));
    }
    return list;
  }

  @override
  Future<void> disconnect(UserEntity userEntity) async {
    // await r.table('users').update({
    //   'id': userEntity.id,
    //   'active': false,
    //   'last_seen': DateTime.now()
    // }).run(_connection);

    await SupabseCredentials.supabaseClient.from('users').update({
      'phoneNumber': userEntity.phoneNumber,
      'active': false,
      'last_seen': DateTime.now()
    }).execute();
  }

  @override
  Future<UserModel?> fetch(String phoneNumber) async {
    // PostgrestResponse<dynamic> user = await SupabseCredentials.supabaseClient
    //     .from('users')
    //     .select('*')
    //     .eq('phoneNumber', phoneNumber)
    //     .execute();
    // var data;
    //
    // try {
    //   data = user.data[0];
    //
    //   return UserModel.fromJson(user.data[0]);
    // } on RangeError catch (e) {
    //   return null;
    // } on NoSuchMethodError catch (e) {
    //   return null;
    // }
    var doc = await firestore.collection('users').doc(phoneNumber).get();
    // print('user fetch ${doc.data()}');
    if (!doc.exists) {
      return null;
    }
    var userjson = doc.data();
    userjson?.addAll({'phoneNumber': phoneNumber});
    print('user fetch updated ${userjson}');
    return UserModel.fromJson(userjson!);
  }
}
