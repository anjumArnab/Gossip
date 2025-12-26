import '../entities/chat_user_entity.dart';
import '../repositories/chat_repository.dart';

class GetUsers {
  final ChatRepository repository;

  GetUsers(this.repository);

  Stream<List<ChatUserEntity>> call() {
    return repository.getUsers();
  }
}