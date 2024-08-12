import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Importez la bibliothèque flutter_svg
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/docai/presentation/pages/riverpod/chat_notifier.dart';
import 'package:tell_me_doctor/features/docai/presentation/widgets/chat_message_widget.dart';

class DocAiPage extends ConsumerStatefulWidget {
  const DocAiPage({super.key});

  @override
  ConsumerState<DocAiPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<DocAiPage> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Médical'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Colors.purple.withOpacity(.05)),
                        child: SvgPicture.asset(
                          'assets/undraw_doctor_kw-5-l.svg', // Remplacez par le chemin de votre SVG
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
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
                    icon: const HeroIcon(HeroIcons.photo),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.purpleAccent.withOpacity(.2),
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText:
                              "Alors ${authState.user?.firstName?.toLowerCase() ?? "User"} dites-moi tout... ",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const HeroIcon(HeroIcons.paperAirplane),
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
        ref
            .read(chatProvider.notifier)
            .sendImageMessage(imageBytes, description);
      }
    }
  }

  Future<String?> _getImageDescription() async {
    final descriptionController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Décrivez l'image"),
        content: TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
              hintText: "Entrez une brève description de l'image"),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Envoyer'),
            onPressed: () =>
                Navigator.of(context).pop(descriptionController.text),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
