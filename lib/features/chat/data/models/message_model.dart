import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.timestamp,
    required super.type,
    super.imageBase64,
    super.isEdited = false,
  });

  factory MessageModel.fromJson(String id, Map<dynamic, dynamic> json) {
    return MessageModel(
      id: id,
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      type: _parseMessageType(json['type']),
      imageBase64: json['imageBase64'],
      isEdited: json['isEdited'] ?? false,
    );
  }

  static MessageType _parseMessageType(dynamic type) {
    if (type == null) return MessageType.text;
    
    if (type is String) {
      return type == 'image' ? MessageType.image : MessageType.text;
    }
    
    return MessageType.text;
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'type': type.toString().split('.').last,
      'imageBase64': imageBase64,
      'isEdited': isEdited,
    };
  }
}