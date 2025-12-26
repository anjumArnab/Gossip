import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(String receiverId, String text) async {
    return await repository.sendMessage(receiverId, text);
  }
}