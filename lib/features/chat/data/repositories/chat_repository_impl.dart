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
  Future<void> sendMessage({
    required String receiverId,
    required String text,
    required MessageType type,
    String? imageBase64,
  }) async {
    return await remoteDataSource.sendMessage(
      receiverId: receiverId,
      text: text,
      type: type,
      imageBase64: imageBase64,
    );
  }

  @override
  Stream<List<MessageEntity>> getMessages(String otherUserId) {
    return remoteDataSource.getMessages(otherUserId);
  }
}