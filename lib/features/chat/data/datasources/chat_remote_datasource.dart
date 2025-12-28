import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_user_model.dart';
import '../models/message_model.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatUserModel>> getUsers();
  Future<void> sendMessage({
    required String receiverId,
    required String text,
    required MessageType type,
    String? imageBase64,
  });
  Stream<List<MessageModel>> getMessages(String otherUserId);
  Future<void> deleteMessage({
    required String otherUserId,
    required String messageId,
  });
  Future<void> editMessage({
    required String otherUserId,
    required String messageId,
    required String newText,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseDatabase database;

  ChatRemoteDataSourceImpl(this.database);

  String _getConversationId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }


  @override
  Stream<List<ChatUserModel>> getUsers() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    return database.ref('users').onValue.map((event) {
      final users = <ChatUserModel>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          if (key != currentUserId) {
            users.add(ChatUserModel.fromJson(key, value as Map<dynamic, dynamic>));
          }
        });
      }
      
      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return users;
    });
  }

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String text,
    required MessageType type,
    String? imageBase64,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    final conversationId = _getConversationId(currentUserId, receiverId);
    
    final messageRef = database.ref('conversations/$conversationId/messages').push();
    
    final message = MessageModel(
      id: messageRef.key!,
      senderId: currentUserId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      type: type,
      imageBase64: imageBase64,
      isEdited: false,
    );

    await messageRef.set(message.toJson());
    
    final lastMessagePreview = type == MessageType.image 
        ? 'Image' 
        : (text.length > 50 ? '${text.substring(0, 50)}...' : text);
    
    await database.ref('conversations/$conversationId/metadata').set({
      'participants': [currentUserId, receiverId],
      'lastMessageTime': message.timestamp,
      'lastMessage': lastMessagePreview,
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String otherUserId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    final conversationId = _getConversationId(currentUserId, otherUserId);
    
    return database.ref('conversations/$conversationId/messages').onValue.map((event) {
      final messages = <MessageModel>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          final message = MessageModel.fromJson(key, value as Map<dynamic, dynamic>);
          messages.add(message);
        });
      }
      
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }
    @override
  Future<void> deleteMessage({
    required String otherUserId,
    required String messageId,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final conversationId = _getConversationId(currentUserId, otherUserId);
    
    await database
        .ref('conversations/$conversationId/messages/$messageId')
        .remove();
  }

  @override
  Future<void> editMessage({
    required String otherUserId,
    required String messageId,
    required String newText,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final conversationId = _getConversationId(currentUserId, otherUserId);
    
    await database
        .ref('conversations/$conversationId/messages/$messageId')
        .update({
      'text': newText,
      'isEdited': true,
    });
  }
}