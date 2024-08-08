import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tell_me_doctor/app.dart';
import 'package:tell_me_doctor/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: "assets/.env");
  final apiKey = dotenv.get('API_KEY');

  if (apiKey.isEmpty) {
    if (kDebugMode) {
      print('No API_KEY found in .env file');
    }
    exit(1);
  }


  runApp(const ProviderScope(child: MyApp()));
}