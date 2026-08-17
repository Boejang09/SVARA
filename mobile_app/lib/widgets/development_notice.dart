import 'package:flutter/material.dart';
import 'package:svara_app/core/theme/app_theme.dart';

class DevelopmentNotice extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const DevelopmentNotice({
    super.key,
    this.title = 'Sedang dalam tahap pengembangan',
    this.message = '',
    this.icon = Icons.construction_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFDBA74),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppTheme.accentCoral,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showDevelopmentSnack(
  BuildContext context, {
  String message =
      'Sedang dalam tahap pengembangan. Fitur ini membutuhkan backend atau model ML.',
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message.isEmpty
              ? 'Sedang dalam tahap pengembangan'
              : message,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
}