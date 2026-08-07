import 'package:flutter/material.dart';

class SvaraLogo extends StatelessWidget {
  static const String assetPath = 'assets/images/svara_logo_exact.png';
  static const Color logoColor = Color(0xFF2DBEB0);

  final double size;
  final bool showText;
  final String? tagline;

  const SvaraLogo({
    super.key,
    this.size = 60,
    this.showText = true,
    this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          const Text(
            'SVARA',
            style: TextStyle(
              color: Color(0xFF005F56),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
        ],
        if (tagline != null) ...[
          const SizedBox(height: 6),
          Text(
            tagline!,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class SvaraWordmark extends StatelessWidget {
  final double markSize;
  final double fontSize;

  const SvaraWordmark({super.key, this.markSize = 36, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SvaraMark(size: markSize, hasShadow: false),
        const SizedBox(width: 10),
        Text(
          'SVARA',
          style: TextStyle(
            color: const Color(0xFF005F56),
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SvaraMark extends StatelessWidget {
  final double size;
  final bool hasShadow;

  const _SvaraMark({required this.size, required this.hasShadow});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Image.asset(
          SvaraLogo.assetPath,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
