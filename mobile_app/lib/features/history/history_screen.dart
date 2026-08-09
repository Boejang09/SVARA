import 'package:flutter/material.dart';
import 'package:svara_app/core/mock/screening_record.dart';
import 'package:svara_app/core/mock/screening_store.dart';
import 'package:svara_app/core/router/app_routes.dart';
import 'package:svara_app/core/theme/app_theme.dart';
import 'package:svara_app/widgets/skeleton/skeleton.dart';
import 'package:svara_app/widgets/svara_logo.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppTheme.primaryDarkTeal,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const HistorySkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari skrining...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppTheme.textMuted,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<List<ScreeningRecord>>(
                      valueListenable: ScreeningStore.records,
                      builder: (context, records, _) {
                        return Column(
                          children: records
                              .map(
                                (record) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _HistoryRecordCard(record: record),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

class _HistoryRecordCard extends StatelessWidget {
  final ScreeningRecord record;

  const _HistoryRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final riskColor = record.isLowRisk
        ? AppTheme.primaryTeal
        : AppTheme.statusWarning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.formattedDate,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  record.riskLevel,
                  style: TextStyle(
                    color: record.isLowRisk
                        ? AppTheme.primaryDarkTeal
                        : Colors.orange.shade900,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.title,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricMini(
                  icon: Icons.favorite_border_rounded,
                  label: 'Jantung',
                  value: record.heartStatus,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricMini(
                  icon: Icons.air_rounded,
                  label: '',
                  value: record.isLowRisk ? 'Optimal' : 'Normal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            record.idText,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _MetricMini extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetricMini({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgMint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryDarkTeal, size: 16),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.primaryDarkTeal,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
