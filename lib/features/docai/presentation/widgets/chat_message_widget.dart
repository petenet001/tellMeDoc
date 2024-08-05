import 'package:flutter/material.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/chat_message.dart';
import 'package:tell_me_doctor/features/docai/domain/entities/medical_provider.dart';
import 'package:tell_me_doctor/features/home/presentation/pages/doctor_profile/doctor_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: message.type == MessageType.user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          buildMessageBubble(context),
          if (message.type == MessageType.ai)
            FutureBuilder<List<MedicalProvider>>(
              future: getRecommendedDoctors(message.content),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return buildRecommendations(context, snapshot.data!);
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }

  Widget buildMessageBubble(BuildContext context) {
    final isUser = message.type == MessageType.user;
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8, left: isUser ? 64 : 0, right: isUser ? 0 : 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.shade100 : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: isUser ? Colors.blue.shade800 : Colors.purple.shade700,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildRecommendations(BuildContext context, List<MedicalProvider> doctors) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommandations:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.purple.shade800,
            ),
          ),
          const SizedBox(height: 8),
          ...doctors.map((doctor) => buildDoctorCard(context, doctor)),
        ],
      ),
    );
  }

  Widget buildDoctorCard(BuildContext context, MedicalProvider doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade200,
          child: Text(
            doctor.name[0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          doctor.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(doctor.specialty),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple.shade300),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorProfilePage(doctor: doctor),
            ),
          );
        },
      ),
    );
  }

  Future<List<MedicalProvider>> getRecommendedDoctors(String messageContent) async {
    // Analyze message content to determine required specialty
    String specialty = determineSpecialty(messageContent);

    // Query Firestore for top doctors in the determined specialty
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('specialty', isEqualTo: specialty)
        .orderBy('rating', descending: true)
        .limit(3)
        .get();

    // Convert query results to MedicalProvider objects
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return MedicalProvider(
        id: doc.id,
        name: data['name'],
        specialty: data['specialty'],
        phone: data['phone'],
        address: data['address'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        // Add other fields as necessary
      );
    }).toList();
  }

  String determineSpecialty(String messageContent) {
    // This is a simple example. You might want to use a more sophisticated
    // method like natural language processing for better accuracy.
    messageContent = messageContent.toLowerCase();
    if (messageContent.contains('dent') || messageContent.contains('tooth')) {
      return 'Dentist';
    } else if (messageContent.contains('skin') || messageContent.contains('rash')) {
      return 'Dermatologist';
    } else if (messageContent.contains('heart') || messageContent.contains('chest pain')) {
      return 'Cardiologist';
    }
    // Add more conditions for other specialties
    return 'General Practitioner'; // Default case
  }
}