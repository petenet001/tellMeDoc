import '../../domain/entities/chat_message.dart';
import '../../../doctors/data/models/medical_provider_model.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.content,
    required super.type,
    super.contentType,
    List<MedicalProviderModel>? super.recommendations,
    super.imageData,
  });

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      content: entity.content,
      type: entity.type,
      contentType: entity.contentType,
      recommendations: entity.recommendations?.map((e) => MedicalProviderModel.fromEntity(e)).toList(),
      imageData: entity.imageData,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: json['content'] as String,
      type: MessageType.values[json['type'] as int],
      contentType: ContentType.values[json['contentType'] as int],
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) {
        // Ici, nous devons extraire l'ID et les données séparément
        final id = e['id'] as String;
        final data = Map<String, dynamic>.from(e);
        data.remove('id'); // Retirez l'ID des données car il sera passé séparément
        return MedicalProviderModel.fromJson(id, data);
      })
          .toList(),
      imageData: (json['imageData'] as List<dynamic>?)?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'type': type.index,
      'contentType': contentType.index,
      'recommendations': recommendations?.map((e) => (e as MedicalProviderModel).toJson()).toList(),
      'imageData': imageData,
    };
  }


  ChatMessageModel copyWith({
    String? content,
    MessageType? type,
    ContentType? contentType,
    List<MedicalProviderModel>? recommendations,
    List<int>? imageData,
  }) {
    return ChatMessageModel(
      content: content ?? this.content,
      type: type ?? this.type,
      contentType: contentType ?? this.contentType,
      recommendations: recommendations ?? (this.recommendations as List<MedicalProviderModel>?),
      imageData: imageData ?? this.imageData,
    );
  }
}