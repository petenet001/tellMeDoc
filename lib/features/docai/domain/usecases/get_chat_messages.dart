import 'package:tell_me_doctor/core/usecase/usecase.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages implements UseCase<List<ChatMessage>, NoParams> {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  @override
  Future<List<ChatMessage>> call(NoParams params) async {
    return await repository.getChatMessages();
  }
}