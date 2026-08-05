import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
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
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primaryDarkTeal),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all as read',
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section TODAY
              const Text(
                'TODAY',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              _buildNotificationTile(
                icon: Icons.medication_rounded,
                iconBg: AppTheme.primaryLightTeal,
                iconColor: AppTheme.primaryTeal,
                title: 'Daily Medication Reminder',
                time: '10:30 AM',
                desc: 'It\'s time for your morning dosage of Vitamin D and Omega-3. Ensure you take them with a meal for better absorption.',
                tag: 'Medication',
                isUnread: true,
              ),
              const SizedBox(height: 10),
              _buildNotificationTile(
                icon: Icons.calendar_today_rounded,
                iconBg: const Color(0xFFFFECE5),
                iconColor: AppTheme.accentCoral,
                title: 'Screening Tomorrow',
                time: '08:15 AM',
                desc: 'Reminder: You have a routine blood sugar screening scheduled at City General Clinic at 9:00 AM tomorrow.',
                tag: 'Appointment',
                isUnread: true,
              ),
              const SizedBox(height: 24),

              // Section EARLIER THIS WEEK
              const Text(
                'EARLIER THIS WEEK',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMuted, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),
              _buildNotificationTile(
                icon: Icons.lightbulb_outline_rounded,
                iconBg: Colors.indigo.shade50,
                iconColor: Colors.indigo.shade600,
                title: 'Health Tip: Hydration',
                time: 'Oct 12',
                desc: 'Staying hydrated can significantly improve your focus and energy levels. Aim for 8 glasses of water today!',
                tag: 'Educational',
                isUnread: false,
              ),
              const SizedBox(height: 10),
              _buildNotificationTile(
                icon: Icons.trending_up_rounded,
                iconBg: AppTheme.primaryLightTeal,
                iconColor: AppTheme.primaryTeal,
                title: 'Progress Report',
                time: 'Oct 11',
                desc: 'Your activity level increased by 12% last week. Great job!',
                tag: null,
                isUnread: false,
              ),
              const SizedBox(height: 10),
              _buildNotificationTile(
                icon: Icons.verified_outlined,
                iconBg: Colors.green.shade50,
                iconColor: Colors.green.shade700,
                title: 'Results Ready',
                time: 'Oct 10',
                desc: 'Your latest lab results from Oct 10 are now available for review.',
                tag: null,
                isUnread: false,
              ),
              const SizedBox(height: 10),
              _buildNotificationTile(
                icon: Icons.directions_walk_rounded,
                iconBg: Colors.grey.shade100,
                iconColor: AppTheme.textDark,
                title: 'Time to move!',
                time: 'Oct 09',
                desc: 'You\'ve been sitting for 2 hours. Take a quick 5-minute stretch or walk to improve circulation.',
                tag: 'Activity',
                isUnread: false,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String time,
    required String desc,
    String? tag,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isUnread ? Border.all(color: AppTheme.primaryTeal.withValues(alpha: 0.3), width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textDark),
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textMuted, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (tag != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.bgMint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: AppTheme.primaryDarkTeal, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
