import '../repositories/chat_repository.dart';

class EditMessage {
  final ChatRepository repository;

  EditMessage(this.repository);

  Future<void> call({
    required String otherUserId,
    required String messageId,
    required String newText,
  }) async {
    return await repository.editMessage(
      otherUserId: otherUserId,
      messageId: messageId,
      newText: newText,
    );
  }
}