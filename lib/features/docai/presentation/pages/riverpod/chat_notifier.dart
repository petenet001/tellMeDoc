import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/core/usecase/usecase.dart';
import 'package:tell_me_doctor/features/docai/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:tell_me_doctor/features/docai/data/repository/chat_repository_impl.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/docai/domain/usecases/get_chat_messages.dart';
import 'package:tell_me_doctor/features/docai/domain/usecases/send_image_message.dart';
import 'package:tell_me_doctor/features/docai/domain/usecases/send_text_message.dart';
import 'dart:typed_data';

final chatProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(
      () => ChatNotifier(),
);

class ChatNotifier extends Notifier<List<ChatMessage>> {
  late final GetChatMessages _getChatMessages;
  late final SendTextMessage _sendTextMessage;
  late final SendImageMessage _sendImageMessage;

  @override
  List<ChatMessage> build() {
    final repository = ref.read(chatRepositoryProvider);
    _getChatMessages = GetChatMessages(repository);
    _sendTextMessage = SendTextMessage(repository);
    _sendImageMessage = SendImageMessage(repository);
    _initializeMessages();
    return [];
  }

  Future<void> _initializeMessages() async {
    try {
      final messages = await _getChatMessages(const NoParams());
      state = messages;
    } catch (e) {
      _handleError(e, 'Failed to load chat messages.');
    }
  }

  Future<void> sendTextMessage(String content) async {
    try {
      final userMessage = ChatMessage(
        content: content,
        type: MessageType.user,
        contentType: ContentType.text,
      );

      // Add user message to state
      state = [...state, userMessage];

      final aiMessage = await _sendTextMessage(content);

      // Add AI message to state
      state = [...state, aiMessage];
    } catch (e) {
      _handleError(e, 'Failed to send text message.');
    }
  }

  Future<void> sendImageMessage(Uint8List imageData, String description) async {
    try {
      final message = await _sendImageMessage(
        ImageMessageParams(imageData: imageData, description: description),
      );
      state = [...state, message];
    } catch (e) {
      _handleError(e, 'Failed to send image message.');
    }
  }

  void _handleError(Object error, String message) {
    print('Error: $message');
    print('Details: $error');
  }
}

final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  final remoteDataSource = GeminiRemoteDataSourceImpl(
    ref.read(apiKeyProvider),
    ref.read(firestoreProvider),
  );
  return ChatRepositoryImpl(remoteDataSource);
});

final apiKeyProvider = Provider<String>((ref) {
  const apiKeyKey = 'API_KEY';
  final apiKey = dotenv.get(apiKeyKey, fallback: '');
  if (apiKey.isEmpty) {
    throw Exception('API Key not found in environment variables: $apiKeyKey');
  }
  return apiKey;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});
