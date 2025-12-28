import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import '../../../auth/domain/usecases/get_current_user.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/delete_message.dart';
import '../../domain/usecases/edit_message.dart';
import '../../domain/entities/message_entity.dart';

class ChatController extends GetxController {
  final SendMessage sendMessage;
  final GetMessages getMessages;
  final GetCurrentUser getCurrentUser;
  final DeleteMessage deleteMessage;
  final EditMessage editMessage;

  ChatController(
    this.sendMessage,
    this.getMessages,
    this.getCurrentUser,
    this.deleteMessage,
    this.editMessage,
  );

  final textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<MessageEntity> messages = [];
  bool isLoading = false;
  bool isUploadingImage = false;
  String? errorMessage;
  StreamSubscription? _subscription;
  String? otherUserId;
  String? currentUserId;
  String? selectedMessageId;
  String? editingMessageId;

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

  void selectMessage(String? messageId) {
    selectedMessageId = messageId;
    update();
  }

  void startEditing(String messageId, String currentText) {
    editingMessageId = messageId;
    textController.text = currentText;
    selectedMessageId = null;
    update();
  }

  void cancelEditing() {
    editingMessageId = null;
    textController.clear();
    update();
  }

  Future<void> confirmEdit() async {
    if (editingMessageId == null || otherUserId == null) return;
    if (textController.text.trim().isEmpty) return;

    final newText = textController.text.trim();
    final messageId = editingMessageId!;

    try {
      await editMessage(
        otherUserId: otherUserId!,
        messageId: messageId,
        newText: newText,
      );

      cancelEditing();
    } catch (e) {
      errorMessage = 'Failed to edit message: ${e.toString()}';
      update();
    }
  }

  Future<void> confirmDelete(String messageId) async {
    if (otherUserId == null) return;

    try {
      await deleteMessage(
        otherUserId: otherUserId!,
        messageId: messageId,
      );

      selectedMessageId = null;
      update();
    } catch (e) {
      errorMessage = 'Failed to delete message: ${e.toString()}';
      update();
    }
  }

  Future<String> _imageToBase64(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      throw Exception('Failed to encode image: $e');
    }
  }

  Future<void> pickAndSendImage() async {
    if (otherUserId == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image == null) return;

      isUploadingImage = true;
      update();

      final base64Image = await _imageToBase64(image.path);
      
      final sizeInKB = (base64Image.length * 0.75) / 1024;
      print('Image size: ${sizeInKB.toStringAsFixed(2)} KB');
      
      if (sizeInKB > 500) {
        errorMessage = 'Warning: Image is large (${sizeInKB.toStringAsFixed(0)} KB). Consider reducing quality.';
        update();
      }

      await sendMessage(
        receiverId: otherUserId!,
        text: textController.text.trim(),
        type: MessageType.image,
        imageBase64: base64Image,
      );

      textController.clear();
      isUploadingImage = false;
      errorMessage = null;
      update();
    } catch (e) {
      errorMessage = 'Failed to send image: ${e.toString()}';
      isUploadingImage = false;
      update();
    }
  }

  Future<void> send() async {
    if (textController.text.trim().isEmpty || otherUserId == null) return;

    // Check if editing
    if (editingMessageId != null) {
      await confirmEdit();
      return;
    }

    final text = textController.text.trim();
    textController.clear();

    try {
      await sendMessage(
        receiverId: otherUserId!,
        text: text,
        type: MessageType.text,
      );
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