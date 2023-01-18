import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_clone/chat/domain/usecases/receipt/dispose_receipt_usecase.dart';

import '../../../domain/entities/receipt_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/receipt/get_all_receipt_usecase.dart';
import '../../../domain/usecases/receipt/send_receipt_usecase.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  StreamSubscription? streamSubscription;
  final GetAllReceipts getAllReceipts;
  final SendReceipt sendReceipt;
  final DisposeReceipt disposeReceipt;

  ReceiptBloc(
      {required this.sendReceipt,
      required this.disposeReceipt,
      required this.getAllReceipts})
      : super(ReceiptInitial()) {
    on<SubscribedReceipt>((event, emit) async {
      // await streamSubscription?.cancel();
      streamSubscription =
          getAllReceipts.call(userEntity: event.user).listen((receipt) {
        print('Receipt recieved Blc');
        add(ReceiptReceived(receipt));
      });
    });
    on<ReceiptReceived>((event, emit) {
      emit(ReceiptReceivedSuccess(event.receipt));
    });
    on<ReceiptSent>((event, emit) async {
      await sendReceipt.call(event.receipt);
      emit(ReceiptSentSuccess(event.receipt));
    });
  }
  @override
  Future<void> close() async {
    streamSubscription?.cancel();
    disposeReceipt.call();
    print('CALLING RECEIPT CLOSE ###');
    super.close();
  }
}
