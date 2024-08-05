import 'package:equatable/equatable.dart';
import 'medical_provider.dart';

enum MessageType { user, ai }
enum ContentType { text, image }

class ChatMessage extends Equatable {
  final String content;
  final MessageType type;
  final ContentType contentType;
  final List<MedicalProvider>? recommendations;  // Assurez-vous que cette ligne est présente
  final List<int>? imageData;

  const ChatMessage({
    required this.content,
    required this.type,
    this.contentType = ContentType.text,
    this.recommendations,  // Assurez-vous que cette ligne est présente
    this.imageData,
  });

  @override
  List<Object?> get props => [
    content,
    type,
    contentType,
    recommendations,
    imageData,
  ];

  ChatMessage copyWith({
    String? content,
    MessageType? type,
    ContentType? contentType,
    covariant List<MedicalProvider>? recommendations,
    List<int>? imageData,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      type: type ?? this.type,
      contentType: contentType ?? this.contentType,
      recommendations: recommendations ?? this.recommendations,
      imageData: imageData ?? this.imageData,
    );
  }
}