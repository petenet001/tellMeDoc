import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/message_bubble.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/recommandations_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isLoading;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.isLoading = false, // Ajout d'un paramètre isLoading
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Image.asset(
          'assets/loading_image.png', // Remplacez par le chemin de votre image de chargement
          width: 150, // Vous pouvez ajuster la taille de l'image ici
          height: 150,
        ),
      );
    }

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
