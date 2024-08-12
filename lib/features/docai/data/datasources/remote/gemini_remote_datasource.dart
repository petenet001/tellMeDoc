import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/health_center.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

/// Interface pour le GeminiRemoteDataSource, qui inclut la génération de réponses textuelles et d'images.
abstract class GeminiRemoteDataSource {
  Future<ChatMessage> generateTextResponse(
      String prompt, List<ChatMessage> history);
  Future<ChatMessage> generateImageResponse(
      Uint8List imageData, String description);
}

/// Implémentation de l'interface GeminiRemoteDataSource pour l'intégration avec le modèle Google Generative AI.
class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final GenerativeModel _model;
  final FirebaseFirestore _firestore;

  GeminiRemoteDataSourceImpl(String apiKey, this._firestore)
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            temperature: 0.7,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 1024,
          ),
        );

  /// Génère une réponse textuelle basée sur un prompt et un historique de conversation.
  @override
  Future<ChatMessage> generateTextResponse(
      String prompt, List<ChatMessage> history) async {
    try {
      final language = _detectLanguage(prompt);
      final fullPrompt = _buildPrompt(prompt, history, language);
      final response = await _model.generateContent([Content.text(fullPrompt)]);

      var responseText = response.text ?? _getDefaultResponse(language);
      responseText = _removeRepetitions(responseText);

      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
          content: _getNonMedicalResponse(language),
          type: MessageType.ai,
          contentType: ContentType.text,
        );
      }

      final specialty = _determineSpecialty(responseText);
      List<MedicalProvider> doctors = [];
      if (specialty != null) {
        doctors = await _getRecommendedDoctors(specialty);
      }

      String finalResponse = responseText;
      if (doctors.isNotEmpty) {
        finalResponse += "\n\n${_getRecommendationIntro(language)}";
        finalResponse +=
            "\n${_formatProviderRecommendations(doctors, language)}";
      }

      return ChatMessage(
        content: finalResponse,
        type: MessageType.ai,
        contentType: ContentType.text,
        recommendations: doctors.isNotEmpty ? doctors : null,
      );
    } catch (e) {
      throw Exception('Error generating text response: ${e.toString()}');
    }
  }

  /// Génère une réponse textuelle basée sur une analyse d'image.
  @override
  Future<ChatMessage> generateImageResponse(
      Uint8List imageData, String description) async {
    try {
      final language = _detectLanguage(description);
      final medicalPrompt = _getImageAnalysisPrompt(language, description);

      final prompt = TextPart(medicalPrompt);
      final imagePart = DataPart('image/jpeg', imageData);

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final responseText = _removeRepetitions(
          response.text ?? _getDefaultImageAnalysisResponse(language));
      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
          content: _getNonMedicalImageResponse(language),
          type: MessageType.ai,
          contentType: ContentType.text,
        );
      }

      return ChatMessage(
        content: responseText,
        type: MessageType.ai,
        contentType: ContentType.text,
      );
    } catch (e) {
      throw Exception("Error analyzing the image: ${e.toString()}");
    }
  }

  /// Détecte la langue d'une entrée textuelle (anglais ou français).
  String _detectLanguage(String text) {
    final isFrench =
        RegExp(r'^\p{Script=Latin}+$', unicode: true).hasMatch(text);
    return isFrench ? 'fr' : 'en';
  }

  /// Construit le prompt complet basé sur l'entrée de l'utilisateur, l'historique de la conversation et la langue.
  String _buildPrompt(
      String userInput, List<ChatMessage> history, String language) {
    final basePrompt = language == 'fr'
        ? "Vous êtes un assistant médical virtuel amical et compétent. Répondez aux questions de santé de manière concise et précise. Assurez-vous de bien comprendre la question avant de répondre."
        : "You are a friendly and knowledgeable virtual medical assistant. Answer health questions concisely and accurately. Ensure you understand the question before responding.";

    final conversationHistory = history
        .take(5)
        .map((msg) =>
            "${msg.type == MessageType.user ? 'User' : 'Assistant'}: ${msg.content}")
        .join("\n");

    final exampleConversations = language == 'fr'
        ? """
        Exemples de conversations:
        Utilisateur: Bonjour, je me sens pas très bien depuis un moment.
        Assistant: Bonjour! Désolé d'apprendre cela. Pouvez-vous m'en dire un peu plus sur ce que vous ressentez?

        Utilisateur: Je crois que j'ai des yeux qui me brûlent depuis un moment.
        Assistant: Cela semble inconfortable. Les yeux brûlants peuvent être dus à plusieurs raisons comme la fatigue oculaire, une allergie, ou une infection. Voici quelques conseils :
        - Reposez vos yeux en les fermant régulièrement.
        - Évitez de toucher vos yeux avec des mains non lavées.
        - Utilisez des gouttes pour les yeux en vente libre pour soulager l'irritation.

        Je recommande de consulter un ophtalmologue pour un diagnostic précis. Voici quelques spécialistes que je recommande:
        """
        : """
        Example conversations:
        User: Hello, I haven't been feeling well for a while.
        Assistant: Hello! I'm sorry to hear that. Could you tell me more about what you're experiencing?

        User: I think my eyes have been burning for a while.
        Assistant: That sounds uncomfortable. Burning eyes can be caused by several reasons like eye strain, an allergy, or an infection. Here are some tips:
        - Rest your eyes by closing them periodically.
        - Avoid touching your eyes with unwashed hands.
        - Use over-the-counter eye drops to relieve irritation.

        I recommend seeing an ophthalmologist for an accurate diagnosis. Here are some specialists I recommend:
        """;

    return "$basePrompt\n\n$conversationHistory\n\n$exampleConversations\n\nUser: $userInput\n\nAssistant:";
  }

  /// Supprime les répétitions d'une réponse générée pour améliorer la lisibilité.
  String _removeRepetitions(String response) {
    final sentences = response.split('. ');
    final uniqueSentences = sentences.toSet().toList();
    return uniqueSentences.join('. ');
  }

  /// Génère un prompt d'analyse d'image basé sur la langue et la description fournie.
  String _getImageAnalysisPrompt(String language, String description) {
    return language == 'fr'
        ? """
    Vous êtes un assistant médical expérimenté spécialisé dans l'analyse d'images médicales. Votre tâche est d'analyser l'image fournie et de fournir une interprétation professionnelle et informée. Veuillez répondre de manière claire et précise.

    Directives :
    1. N'analyser que les images liées à la médecine ou à la santé.
    2. Si l'image ne semble pas être de nature médicale, informez l'utilisateur avec courtoisie.
    3. Évitez de fournir un diagnostic définitif. Recommandez de consulter un professionnel de santé pour une interprétation précise.
    4. Décrivez ce que vous observez dans l'image d'un point de vue médical en utilisant un langage simple et compréhensible.
    5. Si vous avez des doutes sur la nature médicale de l'image, exprimez votre incertitude et demandez des clarifications supplémentaires.

    Description de l'image fournie : $description

    Analyse de l'image :
    """
        : """
    You are a seasoned medical assistant specializing in analyzing medical images. Your task is to analyze the provided image and offer a professional and informed interpretation. Please respond clearly and accurately.

    Guidelines:
    1. Only analyze images that are related to medicine or health.
    2. If the image does not appear to be medical in nature, politely inform the user.
    3. Avoid providing a definitive diagnosis. Recommend consulting a healthcare professional for an accurate interpretation.
    4. Describe what you observe in the image from a medical perspective using simple and understandable language.
    5. If you are unsure about the medical nature of the image, express your uncertainty and request further clarification.

    Description of the provided image: $description

    Image analysis:
    """;
  }

  /// Détermine si une réponse est liée à la médecine.
  bool _isMedicalRelated(String text) {
    return true; // Cette méthode pourrait être enrichie selon les besoins.
  }

  /// Obtient une réponse par défaut pour une analyse d'image non médicale.
  String _getNonMedicalResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, mais je suis ici pour vous aider uniquement avec des questions de santé et de médecine. Pouvez-vous reformuler votre question dans un contexte médical ? Merci de votre compréhension ! 😊"
        : "I'm sorry, but I'm here to assist with health and medical questions only. Could you please rephrase your question in a medical context? Thank you for understanding! 😊";
  }

  /// Obtient une réponse par défaut pour une image non médicale.
  String _getNonMedicalImageResponse(String language) {
    return language == 'fr'
        ? "Oups ! Il semble que l'image fournie ne soit pas de nature médicale. Pourriez-vous vérifier et confirmer qu'il s'agit bien d'une image médicale ? Merci pour votre aide !"
        : "Oops! It seems that the provided image might not be medical in nature. Could you please check and confirm if it's indeed a medical image? Thank you for your assistance!";
  }

  /// Réponse par défaut en cas d'échec de l'analyse d'image.
  String _getDefaultImageAnalysisResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, je n'ai pas pu analyser l'image cette fois-ci. Pourriez-vous essayer à nouveau ou fournir plus de détails ? Je suis là pour vous aider !"
        : "I'm sorry, I couldn't analyze the image this time. Could you please try again or provide more details? I'm here to help!";
  }

  /// Réponse par défaut en cas d'échec de la génération de texte.
  String _getDefaultResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, je n'ai pas pu générer de réponse pour l'instant. Pourriez-vous reformuler votre question ou essayer quelque chose d'autre ? Merci de votre patience !"
        : "I'm sorry, I couldn't generate a response right now. Could you please rephrase your question or try something else? Thank you for your patience!";
  }

  /// Introdction pour les recommandations.
  String _getRecommendationIntro(String language) {
    return language == 'fr'
        ? "Super ! Voici quelques professionnels de santé que je recommande chaleureusement :"
        : "Great! Here are some healthcare professionals I warmly recommend:";
  }

  /// Recommande les docteurs basés sur la spécialité.
  /// Recommande les docteurs basés sur la spécialité.
  Future<List<MedicalProvider>> _getRecommendedDoctors(String specialty) async {
    try {
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('specialty', isEqualTo: specialty)
          .limit(3)
          .get();

      // Utiliser Future.wait pour gérer les opérations asynchrones dans map
      final doctors = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();

        // Vérifier si un HealthCenter est associé
        HealthCenter? healthCenter;
        if (data.containsKey('healthCenterId')) {
          final healthCenterId = data['healthCenterId'];
          final healthCenterDoc = await _firestore
              .collection('health_centers')
              .doc(healthCenterId)
              .get();

          if (healthCenterDoc.exists) {
            final healthCenterData = healthCenterDoc.data()!;
            healthCenter = HealthCenter(
              id: healthCenterDoc.id,
              name: healthCenterData['name'] ?? '',
              address: healthCenterData['address'] ?? '',
              latitude: healthCenterData['latitude'] ?? 0.0,
              longitude: healthCenterData['longitude'] ?? 0.0,
              specialties: List<String>.from(healthCenterData['specialties'] ?? []),
            );
          }
        }

        return MedicalProvider(
          id: doc.id,
          name: data['name'] ?? '',
          specialty: data['specialty'] ?? '',
          phone: data['phone'] ?? '',
          address: data['address'] ?? '',
          latitude: data['latitude'] ?? 0.0,
          longitude: data['longitude'] ?? 0.0,
          healthCenter: healthCenter,
          rating: data['rating'] ?? 0,
        );
      }).toList());

      return doctors;
    } catch (e) {
      print('Error getting recommended doctors: $e');
      return [];
    }
  }

  /// Formatte les recommandations de fournisseurs médicaux.
  String _formatProviderRecommendations(
      List<MedicalProvider> providers, String language) {
    return providers.map((provider) {
      final healthCenter = provider.healthCenter;
      final centerSpecialties = healthCenter?.specialties.join(', ') ?? '';
      return "${provider.name} (${_translateSpecialty(provider.specialty, language)})"
          "${healthCenter != null ? ' - ${healthCenter.name}' : ''}"
          "${centerSpecialties.isNotEmpty ? ' - Specialties: $centerSpecialties' : ''}"
          " - ${language == 'fr' ? 'Tél' : 'Phone'}: ${provider.phone}"
          " - ${language == 'fr' ? 'Adresse' : 'Address'}: ${provider.address}";
    }).join('\n');
  }

  /// Traduit la spécialité médicale en fonction de la langue.
  String _translateSpecialty(String specialty, String language) {
    final translations = {
      'Ophtalmologue': {'en': 'Ophthalmologist', 'fr': 'Ophtalmologue'},
      'Dentiste': {'en': 'Dentist', 'fr': 'Dentiste'},
      'Dermatologue': {'en': 'Dermatologist', 'fr': 'Dermatologue'},
      'Pédiatre': {'en': 'Pediatrician', 'fr': 'Pédiatre'},
      'Cardiologue': {'en': 'Cardiologist', 'fr': 'Cardiologue'},
      'Orthopédiste': {'en': 'Orthopedist', 'fr': 'Orthopédiste'},
    };
    return translations[specialty]?[language] ?? specialty;
  }

  /// Traduit le type de lieu médical en fonction de la langue.
  String _translatePlaceType(String placeType, String language) {
    final translations = {
      'Hôpital': {'en': 'Hospital', 'fr': 'Hôpital'},
      'Clinique': {'en': 'Clinic', 'fr': 'Clinique'},
      'Cabinet': {'en': 'Office', 'fr': 'Cabinet'},
    };
    return translations[placeType]?[language] ?? placeType;
  }

  /// Détermine la spécialité d'un docteur en fonction de la réponse générée.
  String? _determineSpecialty(String responseText) {
    if (responseText.contains(RegExp(r'\b(eye|vision|ophtalm|oculist|ocular)\b',
        caseSensitive: false))) {
      return 'Ophtalmologue';
    } else if (responseText.contains(
        RegExp(r'\b(tooth|dent|mouth|dental)\b', caseSensitive: false))) {
      return 'Dentiste';
    } else if (responseText
        .contains(RegExp(r'\b(skin|derm|rash)\b', caseSensitive: false))) {
      return 'Dermatologue';
    } else if (responseText
        .contains(RegExp(r'\b(child|baby|pediat)\b', caseSensitive: false))) {
      return 'Pédiatre';
    } else if (responseText
        .contains(RegExp(r'\b(heart|cardi)\b', caseSensitive: false))) {
      return 'Cardiologue';
    } else if (responseText
        .contains(RegExp(r'\b(bone|joint|orthoped)\b', caseSensitive: false))) {
      return 'Orthopédiste';
    }
    return null;
  }
}

// ================================================================
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

abstract class GeminiRemoteDataSource {
  Future<ChatMessage> generateTextResponse(
      String prompt, List<ChatMessage> history);
  Future<ChatMessage> generateImageResponse(
      Uint8List imageData, String description);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final GenerativeModel _model;
  final FirebaseFirestore _firestore;

  GeminiRemoteDataSourceImpl(String apiKey, this._firestore)
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    ),
  );

  @override
  Future<ChatMessage> generateTextResponse(
      String prompt, List<ChatMessage> history) async {
    try {
      print("Prompt: $prompt");
      print("History: ${history.map((msg) => msg.content).toList()}");
      final language = _detectLanguage(prompt);
      final fullPrompt = _buildPrompt(prompt, history, language);

      final response = await _model.generateContent([Content.text(fullPrompt)]);

      print("1 ere étape avant la réponse:");
      print("Réponse: ${response.text}");
      print("2eme étape après la réponse:");

      var responseText = response.text ?? _getDefaultResponse(language);
      responseText = _removeRepetitions(responseText);

      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
          content: _getNonMedicalResponse(language),
          type: MessageType.ai,
          contentType: ContentType.text,
        );
      }

      final specialty = _determineSpecialty(prompt);
      List<MedicalProvider> doctors = [];
      if (specialty != null) {
        doctors = await _getRecommendedDoctors(specialty);
      }

      String finalResponse = responseText;
      if (doctors.isNotEmpty) {
        finalResponse += "\n\n${_getRecommendationIntro(language)}";
        finalResponse += "\n${_formatProviderRecommendations(doctors, language)}";
      }

      return ChatMessage(
        content: finalResponse,
        type: MessageType.ai,
        contentType: ContentType.text,
        recommendations: doctors.isNotEmpty ? doctors : null,
      );
    } catch (e) {
      print('Error generating text response: ${e.toString()}');
      throw ServerException('Error generating text response: ${e.toString()}');
    }
  }

  @override
  Future<ChatMessage> generateImageResponse(
      Uint8List imageData, String description) async {
    try {
      final language = _detectLanguage(description);
      final medicalPrompt = _getImageAnalysisPrompt(language, description);

      final prompt = TextPart(medicalPrompt);
      final imagePart = DataPart('image/jpeg', imageData);

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final responseText = _removeRepetitions(
          response.text ?? _getDefaultImageAnalysisResponse(language));
      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
            content: _getNonMedicalImageResponse(language),
            type: MessageType.ai,
            contentType: ContentType.text);
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
    final isFrench = RegExp(r'^\p{Script=Latin}+$', unicode: true).hasMatch(text);
    return isFrench ? 'fr' : 'en';
  }

  String _buildPrompt(
      String userInput, List<ChatMessage> history, String language) {
    final basePrompt = language == 'fr'
        ? "Vous êtes un assistant médical virtuel amical et compétent. Répondez aux questions de santé de manière concise et précise. Assurez-vous de bien comprendre la question avant de répondre."
        : "You are a friendly and knowledgeable virtual medical assistant. Answer health questions concisely and accurately. Ensure you understand the question before responding.";

    final conversationHistory = history
        .take(5)
        .map((msg) =>
    "${msg.type == MessageType.user ? 'User' : 'Assistant'}: ${msg.content}")
        .join("\n");

    return "$basePrompt\n\n$conversationHistory\n\nUser: $userInput\n\nAssistant:";
  }

  String _removeRepetitions(String response) {
    final sentences = response.split('. ');
    final uniqueSentences = sentences.toSet().toList();
    return uniqueSentences.join('. ');
  }

  String _getImageAnalysisPrompt(String language, String description) {
    if (language == 'fr') {
      return """
    Vous êtes un assistant médical expérimenté spécialisé dans l'analyse d'images médicales. Votre tâche est d'analyser l'image fournie et de fournir une interprétation professionnelle et informée. Veuillez répondre de manière claire et précise.

    Directives :
    1. N'analyser que les images liées à la médecine ou à la santé.
    2. Si l'image ne semble pas être de nature médicale, informez l'utilisateur avec courtoisie.
    3. Évitez de fournir un diagnostic définitif. Recommandez de consulter un professionnel de santé pour une interprétation précise.
    4. Décrivez ce que vous observez dans l'image d'un point de vue médical en utilisant un langage simple et compréhensible.
    5. Si vous avez des doutes sur la nature médicale de l'image, exprimez votre incertitude et demandez des clarifications supplémentaires.

    Description de l'image fournie : $description

    Analyse de l'image :
    """;
    } else {
      return """
    You are a seasoned medical assistant specializing in analyzing medical images. Your task is to analyze the provided image and offer a professional and informed interpretation. Please respond clearly and accurately.

    Guidelines:
    1. Only analyze images that are related to medicine or health.
    2. If the image does not appear to be medical in nature, politely inform the user.
    3. Avoid providing a definitive diagnosis. Recommend consulting a healthcare professional for an accurate interpretation.
    4. Describe what you observe in the image from a medical perspective using simple and understandable language.
    5. If you are unsure about the medical nature of the image, express your uncertainty and request further clarification.

    Description of the provided image: $description

    Image analysis:
    """;
    }
  }

  bool _isMedicalRelated(String text) {
    final medicalKeywords = [
      'health', 'medicine', 'disease', 'symptom', 'treatment', 'diagnosis',
      'medication', 'therapy', 'surgery', 'patient', 'doctor', 'hospital',
      'clinic', 'virus', 'bacteria', 'infection', 'pain', 'prevention',
      'healing', 'recovery', 'well-being', 'anatomy', 'physiology', 'fever',
      'cough', 'cold', 'flu', 'asthma', 'allergy', 'diabetes', 'hypertension',
      'cardiac', 'heart', 'depression', 'anxiety', 'migraine', 'cancer',
      'vaccine', 'nutrition', 'chronic illness', 'inflammation', 'fracture',
      'burn', 'hemorrhage', 'epidemic', 'pandemic', 'emergency', 'care',
      'consultation', 'prescription', 'generalist', 'specialist', 'pharmacy',
      'eczema', 'rash', 'lesion', 'fatigue', 'stress', 'therapy', 'psychology',
      'surgery', 'operation', 'intensive care', 'ICU', 'pediatrics', 'oncology',
      'neurology', 'cardiology', 'gynecology', 'urology', 'dermatology',
      'gastroenterology', 'orthopedics', 'pulmonology', 'endocrinology',
      'hematology', 'nephrology', 'rheumatology', 'ophthalmology', 'ent',
      'otolaryngology'
    ];

    final textLower = text.toLowerCase();
    return medicalKeywords.any((keyword) => textLower.contains(keyword));
  }

  String _getNonMedicalResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, mais je suis ici pour vous aider uniquement avec des questions de santé et de médecine. Pouvez-vous reformuler votre question dans un contexte médical ? Merci de votre compréhension ! 😊"
        : "I'm sorry, but I'm here to assist with health and medical questions only. Could you please rephrase your question in a medical context? Thank you for understanding! 😊";
  }

  String _getNonMedicalImageResponse(String language) {
    return language == 'fr'
        ? "Oups ! Il semble que l'image fournie ne soit pas de nature médicale. Pourriez-vous vérifier et confirmer qu'il s'agit bien d'une image médicale ? Merci pour votre aide !"
        : "Oops! It seems that the provided image might not be medical in nature. Could you please check and confirm if it's indeed a medical image? Thank you for your assistance!";
  }

  String _getDefaultImageAnalysisResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, je n'ai pas pu analyser l'image cette fois-ci. Pourriez-vous essayer à nouveau ou fournir plus de détails ? Je suis là pour vous aider !"
        : "I'm sorry, I couldn't analyze the image this time. Could you please try again or provide more details? I'm here to help!";
  }

  String _getDefaultResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, je n'ai pas pu générer de réponse pour l'instant. Pourriez-vous reformuler votre question ou essayer quelque chose d'autre ? Merci de votre patience !"
        : "I'm sorry, I couldn't generate a response right now. Could you please rephrase your question or try something else? Thank you for your patience!";
  }

  String _getRecommendationIntro(String language) {
    return language == 'fr'
        ? "Super ! Voici quelques professionnels de santé que je recommande chaleureusement :"
        : "Great! Here are some healthcare professionals I warmly recommend:";
  }

  Future<List<MedicalProvider>> _getRecommendedDoctors(String specialty) async {
    try {
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('specialty', isEqualTo: specialty)
          .limit(3)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MedicalProvider(
          id: doc.id,
          name: data['name'] ?? '',
          specialty: data['specialty'] ?? '',
          phone: data['phone'] ?? '',
          address: data['address'] ?? '',
          latitude: data['latitude'] ?? 0.0,
          longitude: data['longitude'] ?? 0.0,
          placeName: data['placeName'],
          placeType: data['placeType'],
        );
      }).toList();
    } catch (e) {
      print('Error getting recommended doctors: $e');
      return [];
    }
  }

  String _formatProviderRecommendations(
      List<MedicalProvider> providers, String language) {
    return providers
        .map((provider) =>
    "${provider.name} (${_translateSpecialty(provider.specialty, language)})"
        "${provider.placeName != null ? ' - ${provider.placeName}' : ''}"
        "${provider.placeType != null ? ' (${_translatePlaceType(provider.placeType!, language)})' : ''}"
        " - ${language == 'fr' ? 'Tél' : 'Phone'}: ${provider.phone}"
        " - ${language == 'fr' ? 'Adresse' : 'Address'}: ${provider.address}")
        .join('\n');
  }

  String _translateSpecialty(String specialty, String language) {
    final translations = {
      'Ophtalmologue': {'en': 'Ophthalmologist', 'fr': 'Ophtalmologue'},
      'Dentiste': {'en': 'Dentist', 'fr': 'Dentiste'},
      'Dermatologue': {'en': 'Dermatologist', 'fr': 'Dermatologue'},
      'Pédiatre': {'en': 'Pediatrician', 'fr': 'Pédiatre'},
      'Cardiologue': {'en': 'Cardiologist', 'fr': 'Cardiologue'},
      'Orthopédiste': {'en': 'Orthopedist', 'fr': 'Orthopédiste'},
    };
    return translations[specialty]?[language] ?? specialty;
  }

  String _translatePlaceType(String placeType, String language) {
    final translations = {
      'Hôpital': {'en': 'Hospital', 'fr': 'Hôpital'},
      'Clinique': {'en': 'Clinic', 'fr': 'Clinique'},
      'Cabinet': {'en': 'Office', 'fr': 'Cabinet'},
    };
    return translations[placeType]?[language] ?? placeType;
  }

  String? _determineSpecialty(String prompt) {
    prompt = prompt.toLowerCase();
    if (prompt.contains('yeux') ||
        prompt.contains('vision') ||
        prompt.contains('eye') ||
        prompt.contains('sight')) {
      return 'Ophtalmologue';
    } else if (prompt.contains('dent') ||
        prompt.contains('bouche') ||
        prompt.contains('tooth') ||
        prompt.contains('mouth')) {
      return 'Dentiste';
    } else if (prompt.contains('peau') ||
        prompt.contains('éruption') ||
        prompt.contains('skin') ||
        prompt.contains('rash')) {
      return 'Dermatologue';
    } else if (prompt.contains('enfant') ||
        prompt.contains('bébé') ||
        prompt.contains('child') ||
        prompt.contains('baby')) {
      return 'Pédiatre';
    } else if (prompt.contains('coeur') || prompt.contains('heart')) {
      return 'Cardiologue';
    } else if (prompt.contains('os') ||
        prompt.contains('articulation') ||
        prompt.contains('bone') ||
        prompt.contains('joint')) {
      return 'Orthopédiste';
    }
    return null;
  }
}*/

// ===================================================================

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/doctors/domain/entities/medical_provider.dart';

abstract class GeminiRemoteDataSource {
  Future<ChatMessage> generateTextResponse(
      String prompt, List<ChatMessage> history);
  Future<ChatMessage> generateImageResponse(
      Uint8List imageData, String description);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final GenerativeModel _model;
  final FirebaseFirestore _firestore;

  GeminiRemoteDataSourceImpl(String apiKey, this._firestore)
      : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    ),
  );

  @override
  Future<ChatMessage> generateTextResponse(
      String prompt, List<ChatMessage> history) async {
    try {
      print("Prompt: $prompt");
      print("History: ${history.map((msg) => msg.content).toList()}");
      final language = _detectLanguage(prompt);
      final fullPrompt = _buildPrompt(prompt, history, language);

      final response = await _model.generateContent([Content.text(fullPrompt)]);

      print("1 ere étape avant la réponse:");
      print("Réponse: ${response.text}");
      print("2eme étape après la réponse:");

      var responseText = response.text ?? _getDefaultResponse(language);
      responseText = _removeRepetitions(responseText);

      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
          content: _getNonMedicalResponse(language),
          type: MessageType.ai,
          contentType: ContentType.text,
        );
      }

      final specialty = _determineSpecialty(prompt);
      List<MedicalProvider> doctors = [];
      if (specialty != null) {
        doctors = await _getRecommendedDoctors(specialty);
      }

      String finalResponse = responseText;
      if (doctors.isNotEmpty) {
        finalResponse += "\n\n${_getRecommendationIntro(language)}";
        finalResponse += "\n${_formatProviderRecommendations(doctors, language)}";
      }

      return ChatMessage(
        content: finalResponse,
        type: MessageType.ai,
        contentType: ContentType.text,
        recommendations: doctors.isNotEmpty ? doctors : null,
      );
    } catch (e) {
      print('Error generating text response: ${e.toString()}');
      throw ServerException('Error generating text response: ${e.toString()}');
    }
  }

  @override
  Future<ChatMessage> generateImageResponse(
      Uint8List imageData, String description) async {
    try {
      final language = _detectLanguage(description);
      final medicalPrompt = _getImageAnalysisPrompt(language, description);

      final prompt = TextPart(medicalPrompt);
      final imagePart = DataPart('image/jpeg', imageData);

      final response = await _model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final responseText = _removeRepetitions(
          response.text ?? _getDefaultImageAnalysisResponse(language));
      if (!_isMedicalRelated(responseText)) {
        return ChatMessage(
            content: _getNonMedicalImageResponse(language),
            type: MessageType.ai,
            contentType: ContentType.text);
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
    final isFrench = RegExp(r'^\p{Script=Latin}+$', unicode: true).hasMatch(text);
    return isFrench ? 'fr' : 'en';
  }

  String _buildPrompt(
      String userInput, List<ChatMessage> history, String language) {
    final basePrompt = language == 'fr'
        ? "Vous êtes un assistant médical virtuel amical et compétent. Répondez aux questions de santé de manière concise et précise. Assurez-vous de bien comprendre la question avant de répondre."
        : "You are a friendly and knowledgeable virtual medical assistant. Answer health questions concisely and accurately. Ensure you understand the question before responding.";

    final conversationHistory = history
        .take(5)
        .map((msg) =>
    "${msg.type == MessageType.user ? 'User' : 'Assistant'}: ${msg.content}")
        .join("\n");

    return "$basePrompt\n\n$conversationHistory\n\nUser: $userInput\n\nAssistant:";
  }

  String _removeRepetitions(String response) {
    final sentences = response.split('. ');
    final uniqueSentences = sentences.toSet().toList();
    return uniqueSentences.join('. ');
  }

  String _getImageAnalysisPrompt(String language, String description) {
    if (language == 'fr') {
      return """
    Vous êtes un assistant médical expérimenté spécialisé dans l'analyse d'images médicales. Votre tâche est d'analyser l'image fournie et de fournir une interprétation professionnelle et informée. Veuillez répondre de manière claire et précise.

    Directives :
    1. N'analyser que les images liées à la médecine ou à la santé.
    2. Si l'image ne semble pas être de nature médicale, informez l'utilisateur avec courtoisie.
    3. Évitez de fournir un diagnostic définitif. Recommandez de consulter un professionnel de santé pour une interprétation précise.
    4. Décrivez ce que vous observez dans l'image d'un point de vue médical en utilisant un langage simple et compréhensible.
    5. Si vous avez des doutes sur la nature médicale de l'image, exprimez votre incertitude et demandez des clarifications supplémentaires.

    Description de l'image fournie : $description

    Analyse de l'image :
    """;
    } else {
      return """
    You are a seasoned medical assistant specializing in analyzing medical images. Your task is to analyze the provided image and offer a professional and informed interpretation. Please respond clearly and accurately.

    Guidelines:
    1. Only analyze images that are related to medicine or health.
    2. If the image does not appear to be medical in nature, politely inform the user.
    3. Avoid providing a definitive diagnosis. Recommend consulting a healthcare professional for an accurate interpretation.
    4. Describe what you observe in the image from a medical perspective using simple and understandable language.
    5. If you are unsure about the medical nature of the image, express your uncertainty and request further clarification.

    Description of the provided image: $description

    Image analysis:
    """;
    }
  }

  bool _isMedicalRelated(String text) {
    final medicalKeywords = [
      'health', 'medicine', 'disease', 'symptom', 'treatment', 'diagnosis',
      'medication', 'therapy', 'surgery', 'patient', 'doctor', 'hospital',
      'clinic', 'virus', 'bacteria', 'infection', 'pain', 'prevention',
      'healing', 'recovery', 'well-being', 'anatomy', 'physiology', 'fever',
      'cough', 'cold', 'flu', 'asthma', 'allergy', 'diabetes', 'hypertension',
      'cardiac', 'heart', 'depression', 'anxiety', 'migraine', 'cancer',
      'vaccine', 'nutrition', 'chronic illness', 'inflammation', 'fracture',
      'burn', 'hemorrhage', 'epidemic', 'pandemic', 'emergency', 'care',
      'consultation', 'prescription', 'generalist', 'specialist', 'pharmacy',
      'eczema', 'rash', 'lesion', 'fatigue', 'stress', 'therapy', 'psychology',
      'surgery', 'operation', 'intensive care', 'ICU', 'pediatrics', 'oncology',
      'neurology', 'cardiology', 'gynecology', 'urology', 'dermatology',
      'gastroenterology', 'orthopedics', 'pulmonology', 'endocrinology',
      'hematology', 'nephrology', 'rheumatology', 'ophthalmology', 'ent',
      'otolaryngology'
    ];

    final textLower = text.toLowerCase();
    return medicalKeywords.any((keyword) => textLower.contains(keyword));
  }

  String _getNonMedicalResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, mais je suis ici pour vous aider uniquement avec des questions de santé et de médecine. Pouvez-vous reformuler votre question dans un contexte médical ? Merci de votre compréhension ! 😊"
        : "I'm sorry, but I'm here to assist with health and medical questions only. Could you please rephrase your question in a medical context? Thank you for understanding! 😊";
  }

  String _getNonMedicalImageResponse(String language) {
    return language == 'fr'
        ? "Oups ! Il semble que l'image fournie ne soit pas de nature médicale. Pourriez-vous vérifier et confirmer qu'il s'agit bien d'une image médicale ? Merci pour votre aide !"
        : "Oops! It seems that the provided image might not be medical in nature. Could you please check and confirm if it's indeed a medical image? Thank you for your assistance!";
  }

  String _getDefaultImageAnalysisResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, je n'ai pas pu analyser l'image cette fois-ci. Pourriez-vous essayer à nouveau ou fournir plus de détails ? Je suis là pour vous aider !"
        : "I'm sorry, I couldn't analyze the image this time. Could you please try again or provide more details? I'm here to help!";
  }

  String _getDefaultResponse(String language) {
    return language == 'fr'
        ? "Je suis désolé, je n'ai pas pu générer de réponse pour l'instant. Pourriez-vous reformuler votre question ou essayer quelque chose d'autre ? Merci de votre patience !"
        : "I'm sorry, I couldn't generate a response right now. Could you please rephrase your question or try something else? Thank you for your patience!";
  }

  String _getRecommendationIntro(String language) {
    return language == 'fr'
        ? "Super ! Voici quelques professionnels de santé que je recommande chaleureusement :"
        : "Great! Here are some healthcare professionals I warmly recommend:";
  }

  Future<List<MedicalProvider>> _getRecommendedDoctors(String specialty) async {
    try {
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('specialty', isEqualTo: specialty)
          .limit(3)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return MedicalProvider(
          id: doc.id,
          name: data['name'] ?? '',
          specialty: data['specialty'] ?? '',
          phone: data['phone'] ?? '',
          address: data['address'] ?? '',
          latitude: data['latitude'] ?? 0.0,
          longitude: data['longitude'] ?? 0.0,
          placeName: data['placeName'],
          placeType: data['placeType'],
        );
      }).toList();
    } catch (e) {
      print('Error getting recommended doctors: $e');
      return [];
    }
  }

  String _formatProviderRecommendations(
      List<MedicalProvider> providers, String language) {
    return providers
        .map((provider) =>
    "${provider.name} (${_translateSpecialty(provider.specialty, language)})"
        "${provider.placeName != null ? ' - ${provider.placeName}' : ''}"
        "${provider.placeType != null ? ' (${_translatePlaceType(provider.placeType!, language)})' : ''}"
        " - ${language == 'fr' ? 'Tél' : 'Phone'}: ${provider.phone}"
        " - ${language == 'fr' ? 'Adresse' : 'Address'}: ${provider.address}")
        .join('\n');
  }

  String _translateSpecialty(String specialty, String language) {
    final translations = {
      'Ophtalmologue': {'en': 'Ophthalmologist', 'fr': 'Ophtalmologue'},
      'Dentiste': {'en': 'Dentist', 'fr': 'Dentiste'},
      'Dermatologue': {'en': 'Dermatologist', 'fr': 'Dermatologue'},
      'Pédiatre': {'en': 'Pediatrician', 'fr': 'Pédiatre'},
      'Cardiologue': {'en': 'Cardiologist', 'fr': 'Cardiologue'},
      'Orthopédiste': {'en': 'Orthopedist', 'fr': 'Orthopédiste'},
    };
    return translations[specialty]?[language] ?? specialty;
  }

  String _translatePlaceType(String placeType, String language) {
    final translations = {
      'Hôpital': {'en': 'Hospital', 'fr': 'Hôpital'},
      'Clinique': {'en': 'Clinic', 'fr': 'Clinique'},
      'Cabinet': {'en': 'Office', 'fr': 'Cabinet'},
    };
    return translations[placeType]?[language] ?? placeType;
  }

  String? _determineSpecialty(String prompt) {
    prompt = prompt.toLowerCase();
    if (prompt.contains('yeux') ||
        prompt.contains('vision') ||
        prompt.contains('eye') ||
        prompt.contains('sight')) {
      return 'Ophtalmologue';
    } else if (prompt.contains('dent') ||
        prompt.contains('bouche') ||
        prompt.contains('tooth') ||
        prompt.contains('mouth')) {
      return 'Dentiste';
    } else if (prompt.contains('peau') ||
        prompt.contains('éruption') ||
        prompt.contains('skin') ||
        prompt.contains('rash')) {
      return 'Dermatologue';
    } else if (prompt.contains('enfant') ||
        prompt.contains('bébé') ||
        prompt.contains('child') ||
        prompt.contains('baby')) {
      return 'Pédiatre';
    } else if (prompt.contains('coeur') || prompt.contains('heart')) {
      return 'Cardiologue';
    } else if (prompt.contains('os') ||
        prompt.contains('articulation') ||
        prompt.contains('bone') ||
        prompt.contains('joint')) {
      return 'Orthopédiste';
    }
    return null;
  }
}
*/
