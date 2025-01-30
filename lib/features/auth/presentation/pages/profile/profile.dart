import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _firstNameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _emailController;

  final ImagePicker _imagePicker = ImagePicker();
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _firstNameController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
  /*  final authState = ref.watch(authNotifierProvider);
*/
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      //body: _buildBody(authState),
      body: Placeholder(),
    );
  }

/*
  Widget _buildBody(AuthState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.user != null) {
      _nameController.text = state.user!.name ?? '';
      _firstNameController.text = state.user!.firstName ?? '';
      _phoneController.text = state.user!.phone ?? '';
      _cityController.text = state.user!.city ?? '';
      _emailController.text = state.user!.email;
      _photoUrl = state.user!.photoUrl;
      return _buildProfileForm(state.user!);
    } else if (state.errorMessage != null) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    } else {
      return const Center(child: Text('Please log in'));
    }
  }
*/
/*

  Widget _buildProfileForm(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _getImageProvider(_photoUrl),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _pickImage,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(controller: _nameController, labelText: 'Nom'),
          const SizedBox(height: 16),
          _buildTextField(controller: _firstNameController, labelText: 'Prénom'),
          const SizedBox(height: 16),
          _buildTextField(controller: _phoneController, labelText: 'Numéro de téléphone'),
          const SizedBox(height: 16),
          _buildTextField(controller: _cityController, labelText: 'Ville'),
          const SizedBox(height: 16),
          _buildTextField(controller: _emailController, labelText: 'Email', enabled: false),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateProfile,
            child: const Text('Mettre à jour le profil'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final shouldSignOut = await _showSignOutConfirmationDialog(context);
              if (shouldSignOut == true) {
                ref.read(authNotifierProvider.notifier).signOut(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
*/

  Widget _buildTextField({required TextEditingController controller, required String labelText, bool enabled = true}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      enabled: enabled,
    );
  }

  ImageProvider _getImageProvider(String? urlOrPath) {
    if (urlOrPath == null) {
      return const AssetImage("assets/avatar_placeholder.png");
    } else if (urlOrPath.startsWith('http') || urlOrPath.startsWith('https')) {
      return NetworkImage(urlOrPath);
    } else {
      return FileImage(File(urlOrPath));
    }
  }

 /* Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final photoUrl = pickedFile.path;
      setState(() {
        _photoUrl = photoUrl;
      });
      ref.read(authNotifierProvider.notifier).updateProfilePicture(photoUrl);
    }
  }*/

  /*void _updateProfile() {
    final updatedUser = User(
      id: ref.read(authNotifierProvider).user!.id,
      name: _nameController.text,
      firstName: _firstNameController.text,
      phone: _phoneController.text,
      city: _cityController.text,
      email: _emailController.text,
      photoUrl: _photoUrl,
    );
    ref.read(authNotifierProvider.notifier).updateUserProfile(updatedUser);
  }*/

  Future<bool?> _showSignOutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la déconnexion"),
        content: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Déconnexion"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
//petenet001@gmail.com