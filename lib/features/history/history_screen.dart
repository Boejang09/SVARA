import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/features/notifications/notifications_screen.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All Screenings', 'Heart Focused', 'Lung Analysis'];
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
        automaticallyImplyLeading: false,
        title: const SvaraWordmark(markSize: 32, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryDarkTeal),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const HistorySkeleton()
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search screenings...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textMuted),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilter == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(_filters[index]),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textDark,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                        backgroundColor: Colors.white,
                        selectedColor: AppTheme.primaryTeal,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryTeal : Colors.grey.shade200,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() => _selectedFilter = index);
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Header & Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Screening Records',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  Text(
                    '24 Results',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Records List
              _buildRecordCard(
                date: 'Oct 24, 2023',
                title: 'Full Respiratory Scan',
                riskLevel: 'Low Risk',
                isLowRisk: true,
                heartStatus: 'Normal',
                lungStatus: 'Optimal',
                idText: 'ID: SV-4492-B',
              ),
              const SizedBox(height: 12),
              _buildRecordCard(
                date: 'Oct 12, 2023',
                title: 'Morning Check-up',
                riskLevel: 'Moderate',
                isLowRisk: false,
                heartStatus: 'Tachycardia',
                lungStatus: 'Normal',
                idText: 'ID: SV-3821-A',
              ),
              const SizedBox(height: 12),
              _buildRecordCard(
                date: 'Sep 28, 2023',
                title: 'Post-Exercise Log',
                riskLevel: 'Low Risk',
                isLowRisk: true,
                heartStatus: 'Normal',
                lungStatus: 'Normal',
                idText: 'ID: SV-2910-C',
              ),
              const SizedBox(height: 12),
              _buildRecordCard(
                date: 'Sep 15, 2023',
                title: 'Monthly Baseline',
                riskLevel: 'Low Risk',
                isLowRisk: true,
                heartStatus: 'Normal',
                lungStatus: 'Optimal',
                idText: 'ID: SV-1842-X',
              ),
              const SizedBox(height: 24),

              // Health Trend Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Trend',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your cardiovascular stability has improved by 12% over the last 3 months.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.indigo.shade700,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard({
    required String date,
    required String title,
    required String riskLevel,
    required bool isLowRisk,
    required String heartStatus,
    required String lungStatus,
    required String idText,
  }) {
    final badgeColor = isLowRisk ? AppTheme.primaryLightTeal : const Color(0xFFFFECE5);
    final badgeTextColor = isLowRisk ? AppTheme.primaryDarkTeal : AppTheme.accentCoral;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(color: badgeTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textDark),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.bgMint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_outline_rounded, size: 16, color: AppTheme.primaryTeal),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Heart', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          Text(heartStatus, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.bgMint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.air_rounded, size: 16, color: AppTheme.primaryTeal),
                      const SizedBox(width: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Lung', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          Text(lungStatus, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(idText, style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
            ],
          ),
        ],
      ),
    );
  }
}
