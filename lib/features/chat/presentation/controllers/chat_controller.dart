import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/entities/message_entity.dart';

class ChatController extends GetxController {
  final SendMessage sendMessage;
  final GetMessages getMessages;
  final GetCurrentUser getCurrentUser;

  ChatController(this.sendMessage, this.getMessages, this.getCurrentUser);

  final textController = TextEditingController();
  List<MessageEntity> messages = [];
  bool isLoading = false;
  String? errorMessage;
  StreamSubscription? _subscription;
  String? otherUserId;
  String? currentUserId;

  void initChat(String userId) {
    otherUserId = userId;
    currentUserId = getCurrentUser()?.id;
    loadMessages();
  }

  void loadMessages() {
    if (otherUserId == null) return;

    isLoading = true;
    update();

    _subscription = getMessages(otherUserId!).listen(
      (messagesList) {
        messages = messagesList;
        isLoading = false;
        errorMessage = null;
        update();
      },
      onError: (error) {
        errorMessage = error.toString();
        isLoading = false;
        update();
      },
    );
  }

  Future<void> send() async {
    if (textController.text.trim().isEmpty || otherUserId == null) return;

    final text = textController.text.trim();
    textController.clear();

    try {
      await sendMessage(otherUserId!, text);
    } catch (e) {
      errorMessage = e.toString();
      update();
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    textController.dispose();
    super.onClose();
  }
}