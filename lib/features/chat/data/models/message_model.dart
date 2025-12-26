import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.timestamp,
  });

  factory MessageModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return MessageModel(
      id: id,
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}