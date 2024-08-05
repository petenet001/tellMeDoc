import '../entities/chat_message.dart';
import 'dart:typed_data';

abstract class ChatRepository {
  Future<List<ChatMessage>> getChatMessages();
  Future<ChatMessage> sendTextMessage(String content);
  Future<ChatMessage> sendImageMessage(Uint8List imageData, String description);
}