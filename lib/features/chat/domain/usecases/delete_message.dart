import '../repositories/chat_repository.dart';

class DeleteMessage {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  Future<void> call({
    required String otherUserId,
    required String messageId,
  }) async {
    return await repository.deleteMessage(
      otherUserId: otherUserId,
      messageId: messageId,
    );
  }
}