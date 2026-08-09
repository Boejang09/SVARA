import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/development_notice.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _agreeTOS = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  void _register() {
    showDevelopmentSnack(
      context,
      message:
          'Sedang dalam tahap pengembangan. Registrasi membutuhkan backend user.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.primaryDarkTeal,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Buat Akun',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SvaraLogo(size: 64, showText: false),
              const SizedBox(height: 16),
              const Text(
                'Bergabung dengan SVARA',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryDarkTeal,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Mulai perjalanan kesehatan berbasis klinis\nAnda hari ini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 28),
              const DevelopmentNotice(
                message:
                    'Registrasi akun membutuhkan backend user dan database. Untuk MVP saat ini gunakan mode Guest dari halaman login.',
              ),
              const SizedBox(height: 18),
              _buildLabel('Nama Lengkap'),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'John Doe',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Email'),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'john@example.com',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Nomor Telepon'),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+62 812 3456 7890',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Kata Sandi'),
              TextField(
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  hintText: '********',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.textMuted,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTheme.textMuted,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLabel('Konfirmasi Kata Sandi'),
              TextField(
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: '********',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.textMuted,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTheme.textMuted,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _agreeTOS,
                    activeColor: AppTheme.primaryDarkTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) =>
                        setState(() => _agreeTOS = val ?? false),
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12.5,
                        ),
                        children: [
                          TextSpan(text: 'Saya setuju dengan '),
                          TextSpan(
                            text: 'Syarat Layanan',
                            style: TextStyle(
                              color: AppTheme.primaryDarkTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(
                              color: AppTheme.primaryDarkTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryDarkTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: const Text(
                    'Buat Akun',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: AppTheme.primaryDarkTeal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
