import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/features/messages/presentation/widgets/message_tile.dart';

class MessagesView extends ConsumerWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return const MessageTile(
            name: "John Doe",
            message: "Hello, how are you?",
            imageUrl: "https://images.unsplash.com/photo-1612276529731-4b21494e6d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZG9jdG9yJTIwcG9ydHJhaXR8ZW58MHx8MHx8fDA%3D",
            time: "14:30",
            isRead: false,
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[200],
          );
        },
        itemCount: 10);
  }
}
