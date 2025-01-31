import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 130,
          width: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              100,
            ),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1612276529731-4b21494e6d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZG9jdG9yJTIwcG9ydHJhaXR8ZW58MHx8MHx8fDA%3D"),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pierre MFOUNDOU',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'petenet001@gmail.com',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
