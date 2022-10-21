import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

abstract class LoggedInUserLocalCacheDataSource {
  Future<void> save(String key, Map<String, dynamic> json);
  Map<String, dynamic>? fetch(String key);
}

class LoggedInUserLocalCacheDataSourceImpl
    implements LoggedInUserLocalCacheDataSource {
  final SharedPreferences sharedPreferences;
  LoggedInUserLocalCacheDataSourceImpl({required this.sharedPreferences});
  @override
  Map<String, dynamic>? fetch(String key) {
    var jsonString = sharedPreferences.getString(key);

    if (jsonString == null) {
      return null;
    }
    return jsonDecode(jsonString);
  }

  @override
  Future<void> save(String key, Map<String, dynamic> json) async {
    await sharedPreferences.setString(key, jsonEncode(json));
  }
}
