part of 'receipt_bloc.dart';

@immutable
abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();
}

class SubscribedReceipt extends ReceiptEvent {
  final UserEntity user;
  const SubscribedReceipt(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  final ReceiptEntity receipt;
  const ReceiptSent(this.receipt);
  @override
  // TODO: implement props
  List<Object?> get props => [receipt];
}

class ReceiptReceived extends ReceiptEvent {
  final ReceiptEntity receipt;
  const ReceiptReceived(this.receipt);
  @override
  // TODO: implement props
  List<Object?> get props => [receipt];
}
