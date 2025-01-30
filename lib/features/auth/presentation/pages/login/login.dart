import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoadingEmail =
      false; // Ajout d'une variable pour le bouton de connexion par email
  bool _isLoadingGoogle =
      false; // Ajout d'une variable pour le bouton de connexion par Google

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/doctor_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(.95)),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage("assets/app_logo.png"),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Login to continue using the app",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _emailController,
                                labelText: "Email",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: _passwordController,
                                labelText: "Password",
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Handle forgot password
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            /*  SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoadingEmail
                                      ? null
                                      : () {
                                    if (_formKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        _isLoadingEmail = true;
                                      });
                                      ref
                                          .read(authNotifierProvider
                                          .notifier)
                                          .signInWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text,
                                      )
                                          .whenComplete(() {
                                        if (mounted) {
                                          setState(() {
                                            _isLoadingEmail = false;
                                          });
                                        }
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                  ),
                                  child: _isLoadingEmail
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    "Connexion",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),*/
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Or Login with",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                              const SizedBox(height: 20),
                             /* SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoadingGoogle
                                      ? null
                                      : () {
                                          setState(() {
                                            _isLoadingGoogle = true;
                                          });
                                          ref
                                              .read(
                                                  authNotifierProvider.notifier)
                                              .signInWithGoogle()
                                              .whenComplete(() {
                                            if (mounted) {
                                              setState(() {
                                                _isLoadingGoogle = false;
                                              });
                                            }
                                          });
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        width: 1,
                                        color: Colors.purple,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  child: _isLoadingGoogle
                                      ? const CircularProgressIndicator()
                                      : Image.asset(
                                          "assets/google-logo-carre-2015-09-400.png",
                                          width: 25,
                                          height: 25,
                                        ),
                                ),
                              ),*/
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?"),
                                  TextButton(
                                    onPressed:
                                        _isLoadingEmail || _isLoadingGoogle
                                            ? null
                                            : () {
                                                context.go('/register');
                                              },
                                    child: const Text("Register",
                                        style: TextStyle(color: Colors.purple)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: validator,
    );
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor));
  }





}
