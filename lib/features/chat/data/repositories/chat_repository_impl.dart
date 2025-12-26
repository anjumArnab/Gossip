import '../../domain/entities/chat_user_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message_entity.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<ChatUserEntity>> getUsers() {
    return remoteDataSource.getUsers();
  }

  @override
  Future<void> sendMessage(String receiverId, String text) async {
    return await remoteDataSource.sendMessage(receiverId, text);
  }

  @override
  Stream<List<MessageEntity>> getMessages(String otherUserId) {
    return remoteDataSource.getMessages(otherUserId);
  }
}