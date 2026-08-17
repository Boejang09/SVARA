import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/notifications/notifications_screen.dart';
import 'package:svara_app/services/api_service.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await simulateLoading();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ==========================================================================
  // FITUR YANG BELUM TERSEDIA
  // ==========================================================================

  void _showUnavailable() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(
        milliseconds: 300,
      ),
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return const Center(
          child: _UnavailableDialog(),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgMint,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SvaraWordmark(
          markSize: 32,
          fontSize: 20,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const ProfileSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ========================================================
                    // PROFILE HEADER
                    // ========================================================

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryTeal.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ==================================================
                          // FOTO PROFIL + TOMBOL EDIT OVERLAY
                          // ==================================================

                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Positioned(
                                  left: 4,
                                  top: 4,
                                  child: CircleAvatar(
                                    radius: 46,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 54,
                                      color: AppTheme.primaryDarkTeal,
                                    ),
                                  ),
                                ),

                                // Tombol edit terpisah dan menimpa
                                // sisi kanan-bawah avatar.
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: Material(
                                    color: Colors.white,
                                    shape: const CircleBorder(),
                                    elevation: 3,
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: _showUnavailable,
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: AppTheme.primaryTeal,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit_rounded,
                                          size: 17,
                                          color: AppTheme.primaryTeal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ==================================================
                          // NAMA PENGGUNA
                          // ==================================================

                          Text(
                            ApiService.currentUser?['nama'] ?? 'Tamu',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ==================================================
                          // RINGKASAN
                          // ==================================================

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        'SKOR KESEHATAN',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '--',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Column(
                                    children: [
                                      Text(
                                        'TERAKHIR PINDAI',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Belum ada',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ========================================================
                    // PENGATURAN AKUN
                    // ========================================================

                    _buildSettingsGroup(
                      title: 'Pengaturan Akun',
                      items: [
                        _SettingItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Informasi Pribadi',
                          onTap: _showUnavailable,
                        ),
                        _SettingItem(
                          icon: Icons.history_rounded,
                          title: 'Riwayat Medis',
                          onTap: _showUnavailable,
                        ),
                        _SettingItem(
                          icon: Icons.logout_rounded,
                          title: 'Keluar',
                          onTap: _logout,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ========================================================
                    // PREFERENSI & KEAMANAN
                    // ========================================================

                    _buildSettingsGroup(
                      title: 'Preferensi & Keamanan',
                      items: [
                        _SettingItem(
                          icon: Icons.language_rounded,
                          title: 'Bahasa',
                          subtitle: 'Indonesia',
                          onTap: _showUnavailable,
                        ),
                        _SettingItem(
                          icon: Icons.shield_outlined,
                          title: 'Privasi',
                          onTap: _showUnavailable,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ========================================================
                    // DUKUNGAN
                    // ========================================================

                    _buildSettingsGroup(
                      title: 'Dukungan',
                      items: [
                        _SettingItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Pusat Bantuan',
                          onTap: _showUnavailable,
                        ),
                        _SettingItem(
                          icon: Icons.info_outline_rounded,
                          title: 'Tentang SVARA',
                          onTap: _showUnavailable,
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

  // ==========================================================================
  // SETTINGS GROUP
  // ==========================================================================

  Widget _buildSettingsGroup({
    required String title,
    required List<_SettingItem> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          ...items,
        ],
      ),
    );
  }

  // ==========================================================================
  // LOGOUT
  // ==========================================================================

  Future<void> _logout() async {
    await ApiService.logout();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }
}

// ============================================================================
// SETTING ITEM
// ============================================================================

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.primaryLightTeal,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryDarkTeal,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 503 SERVICE UNAVAILABLE DIALOG
// ============================================================================

class _UnavailableDialog extends StatelessWidget {
  const _UnavailableDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 24,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          24,
          24,
          24,
          22,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==============================================================
            // LOTTIE CAT LOADING
            // ==============================================================

            SizedBox(
              width: 150,
              height: 120,
              child: Lottie.asset(
                'assets/animations/cat_loading.json',
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Center(
                    child: Icon(
                      Icons.cloud_off_rounded,
                      color: AppTheme.primaryDarkTeal,
                      size: 48,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // ==============================================================
            // STATUS 503
            // ==============================================================

            const Text(
              '503',
              style: TextStyle(
                color: AppTheme.primaryDarkTeal,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Service Unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Fitur ini belum tersedia.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 22),

            // ==============================================================
            // TOMBOL TUTUP
            // ==============================================================

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}