import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/message_bubble.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/recommandations_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    print('Building ChatMessageWidget for: ${message.content}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: message.type == MessageType.user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          MessageBubble(message: message),
          if (message.recommendations != null && message.recommendations!.isNotEmpty)
            RecommandationsWidget(doctors: message.recommendations!)
        ],
      ),
    );
  }
}
