import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.reader;
  bool _isLoading = false;
  String? _error;

  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _authService.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'সাইনআপ করা যায়নি');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _roleChip(UserRole role, String label) {
    final selected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryBlue : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.black : AppColors.textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('সাইনআপ')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textWhite),
                  decoration: const InputDecoration(hintText: 'তোমার নাম'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: AppColors.textWhite),
                  decoration: const InputDecoration(hintText: 'ইমেইল'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: AppColors.textWhite),
                  decoration:
                      const InputDecoration(hintText: 'পাসওয়ার্ড (কমপক্ষে ৬ ক্যারেক্টার)'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                const Text(
                  'তুমি কী হিসেবে যোগ দিতে চাও?',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _roleChip(UserRole.reader, 'পাঠক'),
                    _roleChip(UserRole.writer, 'লেখক'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'লেখক হিসেবে যোগ দিলে পড়া ও লেখা দুটোই করতে পারবে।',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.error)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.black),
                        )
                      : const Text('অ্যাকাউন্ট তৈরি করুন'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
