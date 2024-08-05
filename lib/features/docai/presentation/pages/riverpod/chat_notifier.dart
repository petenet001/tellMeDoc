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

final chatProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(() {
  return ChatNotifier();
});

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
    _loadMessages();
    return [];
  }

  Future<void> _loadMessages() async {
    state = await _getChatMessages(const NoParams());
  }

  Future<void> sendTextMessage(String content) async {
    try {
      final message = await _sendTextMessage(content);
      state = [...state, message];
    } catch (e) {
      // Handle error
    }
  }

  Future<void> sendImageMessage(Uint8List imageData, String description) async {
    try {
      final message = await _sendImageMessage(ImageMessageParams(imageData: imageData, description: description));
      state = [...state, message];
    } catch (e) {
      // Handle error
    }
  }
}

final chatRepositoryProvider = Provider((ref) {
  final remoteDataSource = GeminiRemoteDataSourceImpl(ref.read(apiKeyProvider));
  return ChatRepositoryImpl(remoteDataSource);
});

final apiKeyProvider = Provider<String>((ref) {
  final apiKey = dotenv.get('API_KEY');
  return apiKey;
});

