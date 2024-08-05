import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tell_me_doctor/features/auth/domain/entities/user.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_providers.dart';
import 'package:tell_me_doctor/features/auth/presentation/riverpod/auth_state.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _buildBody(authState),
    );
  }

  Widget _buildBody(AuthState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.user != null) {
      _nameController.text = state.user!.name ?? '';
      _emailController.text = state.user!.email;
      return _buildProfileForm(state.user!);
    } else if (state.errorMessage != null) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    } else {
      return const Center(child: Text('Please log in'));
    }
  }

  Widget _buildProfileForm(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final updatedUser = User(
                id: user.id,
                name: _nameController.text,
                email: _emailController.text,
              );
              ref.read(authNotifierProvider.notifier).updateProfile(updatedUser);
            },
            child: const Text('Update Profile'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}