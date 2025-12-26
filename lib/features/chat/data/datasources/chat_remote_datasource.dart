import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_user_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatUserModel>> getUsers();
  Future<void> sendMessage(String receiverId, String text);
  Stream<List<MessageModel>> getMessages(String otherUserId);
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
  Future<void> sendMessage(String receiverId, String text) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    final conversationId = _getConversationId(currentUserId, receiverId);
    
    // Create a new message reference inside the conversation
    final messageRef = database.ref('conversations/$conversationId/messages').push();
    
    final message = MessageModel(
      id: messageRef.key!,
      senderId: currentUserId,
      receiverId: receiverId,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    // Store the message under conversations/{conversationId}/messages/{messageId}
    await messageRef.set(message.toJson());
    
    // Store conversation metadata
    await database.ref('conversations/$conversationId/metadata').set({
      'participants': [currentUserId, receiverId],
      'lastMessageTime': message.timestamp,
      'lastMessage': text.length > 50 ? '${text.substring(0, 50)}...' : text,
    });
  }

  @override
  Stream<List<MessageModel>> getMessages(String otherUserId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    // Get conversation ID
    final conversationId = _getConversationId(currentUserId, otherUserId);
    
    // Listen to messages under this specific conversation
    return database.ref('conversations/$conversationId/messages').onValue.map((event) {
      final messages = <MessageModel>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          final message = MessageModel.fromJson(key, value as Map<dynamic, dynamic>);
          messages.add(message);
        });
      }
      
      // Sort messages by timestamp
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }
}