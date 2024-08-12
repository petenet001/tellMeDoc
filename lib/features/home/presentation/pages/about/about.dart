import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/app_logo.png'),fit: BoxFit.contain)
                ),),
            const SizedBox(height: 16),
            const Text(
              'À propos de Tell Me Doc',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tell Me Doc est une application innovante qui vous aide à trouver rapidement des informations médicales fiables et à vous connecter avec les meilleurs professionnels de santé de votre région. Que vous ayez besoin de conseils, de diagnostics ou de recommandations de spécialistes, Tell Me Doc est là pour vous aider.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Version de l\'application : 1.0.0',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Développé par :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pierre MFOUNDOU',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'petenet001@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact : support@tellmedoc.com',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Vous pouvez ajouter une action ici, par exemple envoyer un e-mail au support
              },
              child: const Text('Nous contacter'),
            ),
          ],
        ),
      ),
    );
  }
}
