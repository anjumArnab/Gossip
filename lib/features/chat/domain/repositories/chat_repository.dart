import '../entities/chat_user_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatUserEntity>> getUsers();
  Future<void> sendMessage(String receiverId, String text);
  Stream<List<MessageEntity>> getMessages(String otherUserId);
}