import '../../domain/entities/chat_user_entity.dart';

class ChatUserModel extends ChatUserEntity {
  ChatUserModel({required super.id, required super.createdAt});

  factory ChatUserModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return ChatUserModel(
      id: id,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
    };
  }
}