import 'package:flutter/material.dart';

/*
class MessageTile extends StatelessWidget {
  const MessageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading:  Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1612276529731-4b21494e6d71?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZG9jdG9yJTIwcG9ydHJhaXR8ZW58MHx8MHx8fDA%3D"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: const Text("John Doe",style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: const Text("data",style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),),
    );
  }
}
*/

class MessageTile extends StatelessWidget {
  final String name;
  final String message;
  final String imageUrl;
  final String time;
  final bool isRead;

  const MessageTile({
    super.key,
    required this.name,
    required this.message,
    required this.imageUrl,
    this.time = '12:34',
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            15,
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image:NetworkImage(imageUrl),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isRead ? Colors.grey : Colors.black,
              ),
            ),
          ),
          if (!isRead)
            Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              ),
              width: 8,
              height: 8,
            ),
        ],
      ),
    );
  }
}