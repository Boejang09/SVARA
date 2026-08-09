import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/development_notice.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await simulateLoading();
    if (mounted) setState(() => _isLoading = false);
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
          'Notifikasi',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => showDevelopmentSnack(context),
            child: const Text(
              'Tandai semua dibaca',
              style: TextStyle(
                color: AppTheme.primaryDarkTeal,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const NotificationsSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hari Ini',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _NotificationTile(
                      icon: Icons.medical_services_outlined,
                      title: 'Pengingat Kesehatan',
                      time: '10:30',
                      body:
                          'Saatnya melakukan latihan pernapasan singkat dan minum air yang cukup.',
                      tag: 'Kesehatan',
                      unread: true,
                    ),
                    const SizedBox(height: 12),
                    const _NotificationTile(
                      icon: Icons.event_available_rounded,
                      title: 'Skrining Besok',
                      time: '08:15',
                      body:
                          'Anda memiliki jadwal skrining rutin. Pastikan berada di tempat tenang.',
                      tag: 'Jadwal',
                      unread: true,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Minggu Ini',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _NotificationTile(
                      icon: Icons.trending_up_rounded,
                      title: 'Laporan Perkembangan',
                      time: '11 Okt',
                      body:
                          'Stabilitas kesehatan Anda meningkat 12% dibanding minggu lalu.',
                      tag: 'Laporan',
                    ),
                    const SizedBox(height: 12),
                    const _NotificationTile(
                      icon: Icons.lightbulb_outline_rounded,
                      title: 'Tips Hidrasi',
                      time: '10 Okt',
                      body:
                          'Menjaga hidrasi dapat membantu kualitas rekaman dan fokus harian.',
                      tag: 'Tips',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String body;
  final String tag;
  final bool unread;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.time,
    required this.body,
    required this.tag,
    this.unread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.primaryLightTeal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primaryDarkTeal),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLightTeal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppTheme.primaryDarkTeal,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (unread)
                      const Icon(
                        Icons.circle,
                        color: AppTheme.primaryDarkTeal,
                        size: 8,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
