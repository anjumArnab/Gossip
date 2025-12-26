class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final int timestamp;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });
}