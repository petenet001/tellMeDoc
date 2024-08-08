import 'package:flutter/foundation.dart';
import 'package:tell_me_doctor/core/error/exceptions.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote/gemini_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GeminiRemoteDataSource remoteDataSource;
  final List<ChatMessage> _messages = [];

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatMessage>> getChatMessages() async {
    return _messages;
  }

  @override
  Future<ChatMessage> sendTextMessage(String content) async {
    try {
      final userMessage = ChatMessage(
          content: content,
          type: MessageType.user,
          contentType: ContentType.text
      );
      _messages.add(userMessage);

      // Pass the entire message history to the remote data source
      final aiResponse = await remoteDataSource.generateTextResponse(content, _messages);
      _messages.add(aiResponse);

      return aiResponse;
    } on ServerException {
      throw ServerException('Failed to send text message');
    }
  }

  @override
  Future<ChatMessage> sendImageMessage(Uint8List imageData, String description) async {
    try {
      final userMessage = ChatMessage(
          content: description,
          type: MessageType.user,
          contentType: ContentType.image,
          imageData: imageData
      );
      _messages.add(userMessage);

      final aiResponse = await remoteDataSource.generateImageResponse(imageData, description);
      _messages.add(aiResponse);

      return aiResponse;
    } on ServerException {
      throw ServerException('Failed to send image message');
    }
  }

  // You might want to add a method to clear the chat history
/*  void clearChatHistory() {
    _messages.clear();
  }*/
}