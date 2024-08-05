import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApi {
  GeminiApi({required String type})
      : _model = GenerativeModel(
          model: type,
          apiKey: dotenv.get("AIzaSyAZG7sP9eAlMDAmzKXntqNTwV_P0kyB7VQ"),
        );

  final GenerativeModel _model;

  Future<String?> generateContent(String prompt) async {
    final response = await _model.generateContent([
      Content.text(prompt),
    ]);

    return response.text;
  }

  Future<String?> generateContentWithImage(
      String prompt, Uint8List file, String type) async {
    final response = await _model.generateContent([
      Content.multi([TextPart(prompt), DataPart(type, file)]),
    ]);

    return response.text;
  }
}
