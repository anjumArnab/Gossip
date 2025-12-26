import '../repositories/chat_repository.dart';
import '../entities/message_entity.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<MessageEntity>> call(String otherUserId) {
    return repository.getMessages(otherUserId);
  }
}