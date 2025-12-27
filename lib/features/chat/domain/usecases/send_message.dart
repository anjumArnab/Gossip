import '../repositories/chat_repository.dart';
import '../entities/message_entity.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call({
    required String receiverId,
    required String text,
    required MessageType type,
    String? imageBase64,
  }) async {
    return await repository.sendMessage(
      receiverId: receiverId,
      text: text,
      type: type,
      imageBase64: imageBase64,
    );
  }
}