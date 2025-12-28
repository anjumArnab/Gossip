import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/message_entity.dart';
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
                    final isSelected = ctrl.selectedMessageId == message.id;

                    return Column(
                      children: [
                        MessageBubble(
                          message: message.text,
                          isMe: isMe,
                          timestamp: message.timestamp,
                          type: message.type,
                          imageBase64: message.imageBase64,
                          isEdited: message.isEdited,
                          isSelected: isSelected,
                          onTap: isMe
                              ? () => ctrl.selectMessage(
                                    isSelected ? null : message.id,
                                  )
                              : null,
                        ),
                        if (isSelected && isMe)
                          Container(
                            margin: const EdgeInsets.only(top: 4, bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (message.type == MessageType.text)
                                  TextButton(
                                    onPressed: () => ctrl.startEditing(
                                      message.id,
                                      message.text,
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                    ),
                                    
                                    child: Text('Edit'),
                                  ),
                                TextButton(
                                  onPressed: () => _showDeleteConfirmation(
                                    context,
                                    ctrl,
                                    message.id,
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                      ],
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
                  if (ctrl.editingMessageId != null)
                    Container(
                      padding: const EdgeInsets.all(3),
                      color: Colors.blue[50],
                      child: Row(
                        children: [
                          const Text(
                            'Editing message',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: ctrl.cancelEditing,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
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
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      if (ctrl.editingMessageId == null)
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
                          decoration: InputDecoration(
                            hintText: ctrl.editingMessageId != null
                                ? 'Edit message...'
                                : 'Type a message...',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: (_) => ctrl.send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          ctrl.editingMessageId != null
                              ? Icons.check
                              : Icons.send,
                        ),
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

  void _showDeleteConfirmation(
    BuildContext context,
    ChatController ctrl,
    String messageId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ctrl.confirmDelete(messageId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}