import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/development_notice.dart';
import 'package:svara_app/widgets/mobile_wrapper.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'guest');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginAsGuest() {
    AppRouter.toMain(context);
  }

  void _showAuthDevelopmentMessage() {
    showDevelopmentSnack(
      context,
      message:
          'Sedang dalam tahap pengembangan. Backend user belum tersedia, jadi MVP memakai mode Guest.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        backgroundColor: AppTheme.bgMint,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const SvaraLogo(
                  size: 72,
                  showText: true,
                  tagline: 'Presisi Klinis. Kejernihan Jantung.',
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'guest',
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: _showAuthDevelopmentMessage,
                            child: const Text(
                              'Lupa Password',
                              style: TextStyle(
                                color: AppTheme.primaryDarkTeal,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: '********',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppTheme.textMuted,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppTheme.textMuted,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const DevelopmentNotice(
                        message:
                            'Login username dan password mengikuti roadmap. Karena backend belum ada, akses MVP sementara menggunakan akun Guest.',
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _showAuthDevelopmentMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                          child: const Text(
                            'Login dengan Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade200)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade200)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _loginAsGuest,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppTheme.primaryTeal,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Masuk sebagai Guest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                    GestureDetector(
                      onTap: _showAuthDevelopmentMessage,
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          color: AppTheme.primaryDarkTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
