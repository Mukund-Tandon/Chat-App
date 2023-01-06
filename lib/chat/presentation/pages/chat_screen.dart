import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Chats/chats_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Message/message_thread_cubit.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Receipt/receipt_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/bloc/Typing/typing_bloc.dart';
import 'package:whatsapp_clone/chat/presentation/pages/image_preview_screen.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/receiver_message_bubble.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/sender_message_bubble.dart';
import 'dart:io';
import '../../domain/entities/local_message_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/typing_event_entity.dart';
import '../widgets/chat_screen/headerStatus.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({
    required this.receiver,
    required this.chatId,
    required this.me,
  });
  final UserEntity receiver;
  final UserEntity me;
  final String chatId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  String chatId = '';
  late UserEntity receiver;
  StreamSubscription? _streamSubscription;
  List<LocalMessageEntity> messages = [];
  Timer? _startTypingTimer;
  Timer? _stopTypingTimer;
  List<MessageEntity> temporary_messages = [];
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      chatId = widget.chatId;
      receiver = widget.receiver;
      context.read<ReceiptBloc>().add(SubscribedReceipt(widget.me));
      context
          .read<TypingBloc>()
          .add(SubscribedTyping(widget.me, [receiver.phoneNumber]));
      // context.read<MessageBloc>().add(Subscribed(widget.me));
      _updateOnMessageReceived();
      _updateonReceiptReceived();
    } else if (state == AppLifecycleState.paused) {}
  }

  void dostuff() {
    // context.read<MessageBloc>().add(Subscribed(widget.me));
  }

  @override
  void initState() {
    super.initState();

    chatId = widget.chatId;
    receiver = widget.receiver;
    dostuff();
    context.read<ReceiptBloc>().add(SubscribedReceipt(widget.me));
    context
        .read<TypingBloc>()
        .add(SubscribedTyping(widget.me, [receiver.phoneNumber]));
    // context.read<MessageBloc>().stream.forEach((element) {
    //   print(element);
    // });
    _updateOnMessageReceived();
    _updateonReceiptReceived();

    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE6DF),
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 60,
        backgroundColor: const Color(0xff128C7E),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_rounded),
              color: Colors.white,
            ),
            Expanded(child: BlocBuilder<TypingBloc, TypingState>(
              builder: (context, state) {
                bool typing = false;
                if (state is TypingEventReceivedSuccess &&
                    state.typingEvent.event == Typing.start &&
                    state.typingEvent.from == receiver.phoneNumber) {
                  typing = true;
                } else {
                  typing = false;
                }
                return HeaderStatus(
                  username: receiver.username,
                  imgurl: receiver.photoUrl,
                  typing: typing,
                );
              },
            ))
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Container(
                color: const Color(0xffEAE6DF),
                child: BlocBuilder<MessageThreadCubit, MessageThreadState>(
                  builder: (context, state) {
                    if (state is MessageThreadLoaded) {
                      messages = state.messages;
                      if (messages.isEmpty) {
                        return Container(color: Colors.transparent);
                      }
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _scrollToEnd());
                      return Column(
                        children: [
                          Expanded(
                            child: Container(child: _buildListOfMessages()),
                          ),
                          Expanded(
                              child: Container(
                                  //TODO: add temp chat
                                  ))
                        ],
                      );
                    }
                    // else if( state is Messa)
                    else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Expanded(
                child: Container(
              height: 50,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      child: RawMaterialButton(
                          fillColor: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          onPressed: () {
                            _imagebuttonSelect();
                          }),
                    ),
                  ),
                  Expanded(
                    child: _buildMessageInput(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Container(
                      height: 45.0,
                      width: 45.0,
                      child: RawMaterialButton(
                          fillColor: const Color(0xff00A884),
                          shape: const CircleBorder(),
                          elevation: 5.0,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _sendMessage();
                          }),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _imagebuttonSelect() async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    File imagefile = File(image!.path);
    final message = MessageEntity(
        sender: widget.me.phoneNumber,
        receiver: receiver.phoneNumber,
        timestamp: DateTime.now(),
        contents: imagefile.path,
        isImage: true,
        imageStatus: ImageStatus.saving);
    message.id = image.name + receiver.phoneNumber.toString();
    context.read<MessageBloc>().add(MessageImageSend(message));
  }

  _buildListOfMessages() => ListView.builder(
        padding: EdgeInsets.only(top: 16, left: 16.0, bottom: 20),
        itemBuilder: (__, idx) {
          if (messages[idx].message.sender == receiver.phoneNumber) {
            _sendReceipt(messages[idx]);
            return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ReceiverMessageBubble(
                  localMessageEntity: messages[idx],
                  receiverUsername: receiver.username,
                ));
          } else {
            return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SenderMessageBubble(
                  localMessageEntity: messages[idx],
                ));
          }
        },
        itemCount: messages.length,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
      );

  _buildMessageInput(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(90),
      ),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
    );
    return Focus(
      onFocusChange: (focus) {
        if (_startTypingTimer == null || (_startTypingTimer != null && focus))
          return;
        _stopTypingTimer?.cancel();
        _dispatchTyping(Typing.stop);
      },
      child: TextFormField(
        controller: _textEditingController,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: Theme.of(context).textTheme.caption,
        cursorColor: Colors.red,
        onChanged: _sendTypingNotification,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          enabledBorder: border,
          filled: true,
          fillColor: Colors.white,
          focusedBorder: border,
        ),
      ),
    );
  }

  _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();

    if (chatId.isNotEmpty) {
      messageThreadCubit.getMessagesFromPhoneusingchatId(chatId);
    }
    _streamSubscription =
        context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await messageThreadCubit.receivedMessage.call(state.message);

        final receipt = ReceiptEntity(
          recipient: state.message.sender,
          messageId: state.message.id,
          status: ReceiptStatus.read,
          timestamp: DateTime.now(),
        );
        context.read<ReceiptBloc>().add(ReceiptSent(receipt));
        if (chatId.isEmpty) chatId = state.message.sender;
      } else if (state is MessageImageDownloadStarted) {
        await messageThreadCubit.receivedMessage.call(state.message);
        final receipt = ReceiptEntity(
          recipient: state.message.sender,
          messageId: state.message.id,
          status: ReceiptStatus.read,
          timestamp: DateTime.now(),
        );
        context.read<ReceiptBloc>().add(ReceiptSent(receipt));
        if (chatId.isEmpty) chatId = state.message.sender;
      } else if (state is MessageSentSuccess) {
        await messageThreadCubit.saveMessageLocallyUsecase.call(state.message);
        dostuff();
        if (chatId.isEmpty) chatId = state.message.receiver;
      } else if (state is MessageImageFromTempDirecctorySendState) {
        await messageThreadCubit.saveMessageLocallyUsecase.call(state.message);

        if (chatId.isEmpty) chatId = state.message.receiver;
      } else if (state is MessageImageUploadingState) {
      } else if (state is MessageImageSentSuccessState) {
        print('MessageImageSentSuccessState');
      }
      context.read<ChatsCubit>().getAllChats();
      await messageThreadCubit.getMessagesFromPhoneusingchatId(chatId);
    });
  }

  _updateonReceiptReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.updateMessageReceipt.call(state.receipt);
        await messageThreadCubit.getMessagesFromPhoneusingchatId(chatId);
        // await context.read<ChatsCubit>().getAllChats();
      } else {}
    });
  }

  _sendMessage() {
    if (_textEditingController.text.trim().isEmpty) return;

    final message = MessageEntity(
        sender: widget.me.phoneNumber,
        receiver: receiver.phoneNumber,
        timestamp: DateTime.now(),
        contents: _textEditingController.text,
        isImage: false,
        imageStatus: ImageStatus.notPresent);

    context.read<MessageBloc>().add(MessageSent(message));

    _textEditingController.clear();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();

    _dispatchTyping(Typing.stop);
  }

  void _dispatchTyping(Typing event) {
    final typing = TypingEventEntity(
        from: widget.me.phoneNumber, to: receiver.phoneNumber, event: event);
    context.read<TypingBloc>().add(TypingEventSent(typing));
  }

  void _sendTypingNotification(String text) {
    if (text.trim().isEmpty || messages.isEmpty) return;

    if (_startTypingTimer?.isActive ?? false) return;

    if (_stopTypingTimer?.isActive ?? false) _stopTypingTimer?.cancel();

    _dispatchTyping(Typing.start);

    _startTypingTimer =
        Timer(Duration(seconds: 5), () {}); //send one event every 5 seconds

    _stopTypingTimer =
        Timer(Duration(seconds: 6), () => _dispatchTyping(Typing.stop));
  }

  _scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  _sendReceipt(LocalMessageEntity localMessageEntity) async {
    if (localMessageEntity.receiptStatus == ReceiptStatus.read) return;
    final receipt = ReceiptEntity(
      recipient: localMessageEntity.message.sender,
      messageId: localMessageEntity.id,
      status: ReceiptStatus.read,
      timestamp: DateTime.now(),
    );
    context.read<ReceiptBloc>().add(ReceiptSent(receipt));
    await context.read<MessageThreadCubit>().updateMessageReceipt.call(receipt);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _streamSubscription?.cancel();
    _stopTypingTimer?.cancel();
    _startTypingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
