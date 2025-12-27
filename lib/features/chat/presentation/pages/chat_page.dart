import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/di/injection_container.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatelessWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(sl<ChatController>());
    controller.initChat(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${userId.substring(0, 8)}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetBuilder<ChatController>(
              builder: (ctrl) {
                if (ctrl.isLoading && ctrl.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (ctrl.messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                return ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.messages.length,
                  itemBuilder: (context, index) {
                    final message = ctrl.messages[index];
                    final isMe = message.senderId == ctrl.currentUserId;
                    return MessageBubble(
                      message: message.text,
                      isMe: isMe,
                      timestamp: message.timestamp,
                      type: message.type,
                      imageBase64: message.imageBase64,
                    );
                  },
                );
              },
            ),
          ),
          GetBuilder<ChatController>(
            builder: (ctrl) => Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (ctrl.isUploadingImage)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    ),
                  if (ctrl.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        ctrl.errorMessage!,
                        style: const TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: ctrl.isUploadingImage 
                            ? null 
                            : ctrl.pickAndSendImage,
                        color: Theme.of(context).primaryColor,
                      ),
                      Expanded(
                        child: TextField(
                          controller: ctrl.textController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: (_) => ctrl.send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: ctrl.send,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}