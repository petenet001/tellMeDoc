import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tell_me_doctor/features/docai/presentation/pages/riverpod/chat_notifier.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/chat_message_widget.dart';

class DocAiPage extends ConsumerStatefulWidget {
  const DocAiPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<DocAiPage> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assistant Médical'),leading: const BackButton(),),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatMessageWidget(message: messages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Posez une question médicale...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      ref.read(chatProvider.notifier).sendTextMessage(_textController.text);
      _textController.clear();
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      final description = await _getImageDescription();
      if (description != null) {
        ref.read(chatProvider.notifier).sendImageMessage(imageBytes, description);
      }
    }
  }

  Future<String?> _getImageDescription() async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Décrivez l'image"),
        content: TextField(
        decoration: const InputDecoration(hintText: "Entrez une brève description de l'image"),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Envoyer'),
          onPressed: () => Navigator.of(context).pop(_textController.text),
        ),
      ],
    ),
    );
  }
}