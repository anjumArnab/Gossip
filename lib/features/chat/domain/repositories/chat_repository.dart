import '../entities/chat_user_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatUserEntity>> getUsers();
  Future<void> sendMessage({
    required String receiverId,
    required String text,
    required MessageType type,
    String? imageBase64,
  });
  Stream<List<MessageEntity>> getMessages(String otherUserId);
}