import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final int timestamp;
  final MessageType type;
  final String? imageBase64;
  final bool isEdited;
  final bool isSelected;
  final VoidCallback? onTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    required this.type,
    this.imageBase64,
    this.isEdited = false,
    this.isSelected = false,
    this.onTap,
  });

  Uint8List? _decodeBase64Image() {
    if (imageBase64 == null || imageBase64!.isEmpty) return null;
    
    try {
      return base64Decode(imageBase64!);
    } catch (e) {
      print('Error decoding base64 image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final timeStr = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isMe ? Colors.blue[700] : Colors.grey[400])
                    : (isMe ? Colors.blue[600] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: Colors.blue[900]!, width: 2)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (type == MessageType.image && imageBase64 != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildImage(context),
                    ),
                    if (message.isNotEmpty) const SizedBox(height: 8),
                  ],
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      if (isEdited) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(edited)',
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black54,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final imageBytes = _decodeBase64Image();
    
    if (imageBytes == null) {
      return Container(
        height: 200,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.error, color: Colors.red),
        ),
      );
    }

    return Image.memory(
      imageBytes,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.error, color: Colors.red),
          ),
        );
      },
    );
  }
}