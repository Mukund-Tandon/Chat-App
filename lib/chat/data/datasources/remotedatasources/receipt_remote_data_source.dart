import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_clone/chat/data/models/receipt_model.dart';

import '../../../domain/entities/receipt_entity.dart';
import '../../../domain/entities/user_entity.dart';
import 'package:whatsapp_clone/core/superbase_service.dart';

abstract class ReceiptRemoteDataSource {
  Future<bool> sendReceipt(ReceiptEntity receiptEntity);
  Stream<ReceiptModel> getAllReceipt({required UserEntity userEntity});
  dispose();
}

class ReceiptRemoteDataSourceImpl implements ReceiptRemoteDataSource {
  // late StreamSubscription streamSubscription;
  final firestore = FirebaseFirestore.instance;
  var _controller = StreamController<ReceiptModel>.broadcast();
  ReceiptRemoteDataSourceImpl();
  @override
  dispose() {
    // streamSubscription.cancel();
    _controller.close();
  }

  @override
  Stream<ReceiptModel> getAllReceipt({required UserEntity userEntity}) {
    _controller = StreamController<ReceiptModel>.broadcast();
    _startRecievingReceipts(userEntity);
    return _controller.stream;
  }

  @override
  Future<bool> sendReceipt(ReceiptEntity receiptEntity) async {
    var receipt = ReceiptModel(
        recipient: receiptEntity.recipient,
        messageId: receiptEntity.messageId,
        status: receiptEntity.status,
        timestamp: receiptEntity.timestamp);
    var data = receipt.toJson();
    // Map record = await r.table('receipts').insert(data).run(_connection);
    // return record['inserted'] == 1;
    // final result = await SupabseCredentials.supabaseClient
    //     .from('receipts')
    //     .insert([data]).execute();
    // if (result.data != null) {
    //   return true;
    // }
    // return false;
    var newdocRef = firestore.collection('receipts').doc();
    await newdocRef.set(data);
    if (newdocRef.id.isEmpty) {
      return false;
    }
    return true;
  }

  _startRecievingReceipts(UserEntity userEntity) {
    // r
    //     .table('receipts')
    //     .filter({'recipient': userEntity.id})
    //     .changes({'include_initial': true})
    //     .run(_connection)
    //     .asStream()
    //     .cast<Feed>()
    //     .listen((event) {
    //       event.forEach((element) {
    //         if (element['new_val'] == null) return;
    //         final receipt = _receiptFromFeed(element);
    //         _controller.sink.add(receipt);
    //       });
    //     });

    // streamSubscription = SupabseCredentials.supabaseClient
    //     .from('receipts:recipient=eq.${userEntity.phoneNumber}')
    //     .stream(['id'])
    //     .execute()
    //     .listen((event) {
    //       print('new reciept event');
    //       event.forEach((element) {
    //         final receipt = _receiptFromFeed(element);
    //         _controller.sink.add(receipt);
    //         // _removeDiliveredMessage(receipt);
    //       });
    //     });

    var snapshots = firestore
        .collection('receipts')
        .where('recipient', isEqualTo: userEntity.phoneNumber)
        .snapshots();
    firestore.settings.copyWith(persistenceEnabled: false);
    snapshots.listen((event) {
      event.docChanges.forEach((element) {
        print('hello reciepts');
        print(element.doc.data());
        var reciepts = element.doc.data();
        reciepts?.addAll({'id': element.doc.id});
        var recieptsmodel = _receiptFromFeed(reciepts);
        _controller.sink.add(recieptsmodel);
        _removeDiliveredReceipts(recieptsmodel);
      });
    });
  }

  _removeDiliveredReceipts(ReceiptModel receiptModel) async {
    // var a = SupabseCredentials.supabaseClient
    //     .from('receipts')
    //     .delete()
    //     .match({'id': receiptModel.id}).execute();
    firestore.collection("receipts").doc(receiptModel.id).delete();
  }

  ReceiptModel _receiptFromFeed(element) {
    return ReceiptModel.fromJson(element);
  }
}
