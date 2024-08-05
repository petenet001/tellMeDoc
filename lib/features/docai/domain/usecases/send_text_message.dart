import 'package:tell_me_doctor/core/usecase/usecase.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendTextMessage implements UseCase<ChatMessage, String> {
  final ChatRepository repository;

  SendTextMessage(this.repository);

  @override
  Future<ChatMessage> call(String params) async {
    return await repository.sendTextMessage(params);
  }
}