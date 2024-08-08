import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: isUser ? 64 : 0, right: isUser ? 0 : 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.shade100 : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isUser ? Colors.blue.shade800 : Colors.purple.shade700,
          fontSize: 16,
        ),
      ),
    );
  }
}