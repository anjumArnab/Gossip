enum MessageType {
  text,
  image,
}

class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final int timestamp;
  final MessageType type;
  final String? imageBase64;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.type,
    this.imageBase64,
  });
}