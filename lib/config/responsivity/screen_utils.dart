import 'package:flutter/material.dart';

class ScreenUtils {

  // Obtenir la largeur de l'écran
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Obtenir la hauteur de l'écran
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Adapter la largeur à un pourcentage de l'écran
  static double adaptiveWidth(BuildContext context, double percentage) {
    return screenWidth(context) * percentage;
  }

  // Adapter la hauteur à un pourcentage de l'écran
  static double adaptiveHeight(BuildContext context, double percentage) {
    return screenHeight(context) * percentage;
  }

  // Obtenir la plateforme (iOS, Android, etc.)
  static TargetPlatform getPlatform(BuildContext context) {
    return Theme.of(context).platform;
  }
}