import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/logo.png', height: 120),
              const SizedBox(height: 40),
              CustomTextField(
                hint: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
                controller: _passwordController,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text('Lupa password?'),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: _isLoading ? 'Please wait...' : 'Sign in',
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mohon isi email dan password'),
                            ),
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        try {
                          await _authService.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (!mounted) return;
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          if (!mounted) return;
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton('assets/facebook.png'),
                  _socialButton('assets/google.png'),
                  _socialButton(
                    'assets/x.png',
                  ), // Changed from twitter.png to x.png
                  _socialButton('assets/apple.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String iconPath) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(iconPath, height: 24),
      ),
    );
  }
}
