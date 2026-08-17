import 'package:flutter/material.dart';
import 'package:svara_app/core/router/app_router.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/services/api_service.dart';
import 'package:svara_app/widgets/mobile_wrapper.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'tamu');
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithUsername() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Nama pengguna dan kata sandi wajib diisi.');
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiService.login(
      username: username,
      password: password,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      AppRouter.toMain(context);
    } else {
      _showMessage(result.message ?? 'Login gagal.');
    }
  }

  void _showForgotPasswordMessage() {
    _showMessage(
      'Pemulihan kata sandi belum diaktifkan untuk akun demo.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        backgroundColor: AppTheme.bgMint,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
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
                        color: Colors.black.withValues(
                          alpha: 0.04,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Pengguna',
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
                          hintText: 'tamu',
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kata Sandi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textDark,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: _showForgotPasswordMessage,
                            child: const Text(
                              'Lupa Kata Sandi',
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
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : _loginWithUsername,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.primaryDarkTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(27),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                      style: TextStyle(
                        color: AppTheme.textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          AppRouter.toRegister(context),
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