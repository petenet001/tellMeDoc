import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tell_me_doctor/features/docai/data/datasources/remote/firebase_medical_service.dart';
import 'dart:typed_data';

import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/medical_provider.dart';

abstract class GeminiRemoteDataSource {
  Future<ChatMessage> generateTextResponse(String prompt);
  Future<ChatMessage> generateImageResponse(Uint8List imageData, String description);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final GenerativeModel _model;
  final FirebaseMedicalService _medicalService;

  GeminiRemoteDataSourceImpl(String apiKey)
      : _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey),
        _medicalService = FirebaseMedicalService();

  @override
  Future<ChatMessage> generateTextResponse(String prompt) async {
    try {
      final language = _detectLanguage(prompt);
      final medicalContext = await _getMedicalContext(language);

      final fullPrompt = "$medicalContext\n\nUser question: $prompt";

      final response = await _model.generateContent([Content.text(fullPrompt)]);

      final responseText = response.text ?? "Sorry, I couldn't generate a response.";
      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
            content: _getNonMedicalResponse(language),
            type: MessageType.ai,
            contentType: ContentType.text
        );
      }

      final specialty = _identifyRequiredSpecialty(responseText);
      if (specialty != null) {
        final providers = await _medicalService.searchMedicalProviders(specialty);
        if (providers.isNotEmpty) {
          final recommendationsText = _formatProviderRecommendations(providers, language);
          return ChatMessage(
              content: "$responseText\n\n$recommendationsText",
              type: MessageType.ai,
              contentType: ContentType.text
          );
        }
      }

      return ChatMessage(
          content: responseText,
          type: MessageType.ai,
          contentType: ContentType.text
      );
    } catch (e) {
      throw ServerException('Error generating text response: ${e.toString()}');
    }
  }

  @override
  Future<ChatMessage> generateImageResponse(Uint8List imageData, String description) async {
    try {
      final language = _detectLanguage(description);
      final medicalPrompt = _getImageAnalysisPrompt(language, description);

      final prompt = TextPart(medicalPrompt);
      final imagePart = DataPart('image/jpeg', imageData);

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final responseText = response.text ?? _getDefaultImageAnalysisResponse(language);
      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
            content: _getNonMedicalImageResponse(language),
            type: MessageType.ai,
            contentType: ContentType.text
        );
      }

      return ChatMessage(
          content: responseText,
          type: MessageType.ai,
          contentType: ContentType.text);
    } catch (e) {
      throw ServerException("Error analyzing the image: ${e.toString()}");
    }
  }

  String _detectLanguage(String text) {
    final frenchWords = ['je', 'tu', 'il', 'elle', 'nous', 'vous', 'ils', 'elles', 'le', 'la', 'les', 'un', 'une', 'des', 'et', 'ou', 'mais'];
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final frenchCount = words.where((word) => frenchWords.contains(word)).length;
    return frenchCount > words.length * 0.2 ? 'fr' : 'en';
  }

  Future<String?> _getMedicalContext(String language) async {
    const contexts = {
      'fr': "Vous êtes un assistant médical virtuel bilingue (français et anglais). Vous pouvez répondre à des questions liées à la santé, à la médecine et au bien-être dans les deux langues. Si une question n'est pas liée à ces domaines, rappelez poliment à l'utilisateur que vous êtes spécialisé en santé et médecine. Répondez dans la langue de la question.",
      'en': "You are a bilingual (English and French) virtual medical assistant. You can answer questions related to health, medicine, and well-being in both languages. If a question is not related to these fields, politely remind the user that you specialize in health and medicine. Respond in the language of the question."
    };

    return contexts[language] ?? contexts['en'];
  }

  String _getImageAnalysisPrompt(String language, String description) {
    if (language == 'fr') {
      return """
      Vous êtes un assistant médical spécialisé dans l'analyse d'images médicales. Votre tâche est d'analyser l'image fournie et de donner une interprétation professionnelle, mais uniquement si l'image est de nature médicale.

      Règles à suivre strictement :
      1. N'analysez que les images liées à la médecine ou à la santé.
      2. Si l'image n'est pas de nature médicale, informez poliment l'utilisateur que vous ne pouvez pas l'analyser.
      3. Ne donnez jamais de diagnostic définitif. Suggérez toujours de consulter un professionnel de santé pour une interprétation précise.
      4. Décrivez ce que vous voyez dans l'image d'un point de vue médical.
      5. En cas de doute sur la nature médicale de l'image, exprimez votre incertitude et demandez des clarifications.

      Description de l'image fournie par l'utilisateur: $description

      Analyse de l'image (en respectant strictement les règles ci-dessus):
      """;
    } else {
      return """
      You are a medical assistant specializing in the analysis of medical images. Your task is to analyze the provided image and give a professional interpretation, but only if the image is medical in nature.

      Rules to strictly follow:
      1. Only analyze images related to medicine or health.
      2. If the image is not medical in nature, politely inform the user that you cannot analyze it.
      3. Never give a definitive diagnosis. Always suggest consulting a healthcare professional for an accurate interpretation.
      4. Describe what you see in the image from a medical point of view.
      5. If in doubt about the medical nature of the image, express your uncertainty and ask for clarifications.

      Description of the image provided by the user: $description

      Image analysis (strictly following the rules above):
      """;
    }
  }

  bool _isMedicalRelated(String text) {
    final medicalKeywords = [
      // French keywords
      'santé', 'médecine', 'maladie', 'symptôme', 'traitement', 'diagnostic',
      'médicament', 'thérapie', 'chirurgie', 'patient', 'docteur', 'hôpital',
      'clinique', 'virus', 'bactérie', 'infection', 'douleur', 'prévention',
      'guérison', 'rétablissement', 'bien-être', 'anatomie', 'physiologie',
      // English keywords
      'health', 'medicine', 'disease', 'symptom', 'treatment', 'diagnosis',
      'medication', 'therapy', 'surgery', 'patient', 'doctor', 'hospital',
      'clinic', 'virus', 'bacteria', 'infection', 'pain', 'prevention',
      'healing', 'recovery', 'well-being', 'anatomy', 'physiology'
    ];

    return medicalKeywords.any((keyword) => text.toLowerCase().contains(keyword));
  }

  String _getNonMedicalResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, mais je ne peux répondre qu'à des questions liées à la santé et à la médecine. Pourriez-vous reformuler votre question dans un contexte médical ?"
        : "I'm sorry, but I can only answer questions related to health and medicine. Could you rephrase your question in a medical context?";
  }

  String _getNonMedicalImageResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, mais je ne peux analyser que des images liées à la médecine et à la santé. L'image fournie ne semble pas être de nature médicale. Pouvez-vous confirmer qu'il s'agit bien d'une image médicale ?"
        : "I'm sorry, but I can only analyze images related to medicine and health. The provided image doesn't seem to be medical in nature. Can you confirm that it is indeed a medical image?";
  }

  String _getDefaultImageAnalysisResponse(String language) {
    return language == 'fr'
        ? "Désolé, je n'ai pas pu analyser l'image."
        : "Sorry, I couldn't analyze the image.";
  }

  String? _identifyRequiredSpecialty(String text) {
    final specialties = {
      'dentiste': ['dent', 'dentaire', 'tooth', 'dental'],
      'dermatologue': ['peau', 'skin', 'dermatolog'],
      'cardiologue': ['coeur', 'heart', 'cardiolog'],
      'ophtalmologue': ['oeil', 'yeux', 'eye', 'vision'],
      'pédiatre': ['enfant', 'child', 'pediatr'],
      'orthopédiste': ['os', 'articulation', 'bone', 'joint', 'orthoped'],
      // Ajoutez d'autres spécialités selon vos besoins
    };

    for (var entry in specialties.entries) {
      if (entry.value.any((keyword) => text.toLowerCase().contains(keyword))) {
        return entry.key;
      }
    }
    return null;
  }

  String _formatProviderRecommendations(List<MedicalProvider> providers, String language) {
    final intro = language == 'fr'
        ? "Voici quelques professionnels ou établissements qui pourraient vous aider :"
        : "Here are some professionals or facilities that could help you:";
    final recommendations = providers.map((provider) =>
    "${provider.name} (${provider.specialty})"
        "${provider.placeName != null ? ' - ${provider.placeName}' : ''}"
        "${provider.placeType != null ? ' (${provider.placeType})' : ''}"
        " - ${language == 'fr' ? 'Tél' : 'Phone'}: ${provider.phone}"
        " - ${language == 'fr' ? 'Adresse' : 'Address'}: ${provider.address}"
    ).join('\n');
    return "$intro\n$recommendations";
  }
}

