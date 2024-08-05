import 'dart:typed_data';
import 'package:tell_me_doctor/core/usecase/usecase.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendImageMessage implements UseCase<ChatMessage, ImageMessageParams> {
  final ChatRepository repository;

  SendImageMessage(this.repository);

  @override
  Future<ChatMessage> call(ImageMessageParams params) async {
    return await repository.sendImageMessage(params.imageData, params.description);
  }
}

class ImageMessageParams {
  final Uint8List imageData;
  final String description;

  ImageMessageParams({required this.imageData, required this.description});
}