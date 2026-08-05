import 'package:flutter/material.dart';

class SvaraLogo extends StatelessWidget {
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
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF00BFA5),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00BFA5).withValues(alpha: 0.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomPaint(
              size: Size(size * 0.55, size * 0.55),
              painter: _SvaraEmblemPainter(),
            ),
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

  const SvaraWordmark({
    super.key,
    this.markSize = 36,
    this.fontSize = 20,
  });

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

  const _SvaraMark({
    required this.size,
    required this.hasShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF00BFA5),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF00BFA5).withValues(alpha: 0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.55, size * 0.55),
          painter: _SvaraEmblemPainter(),
        ),
      ),
    );
  }
}

class _SvaraEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    path.moveTo(size.width * 0.2, size.height * 0.35);
    path.lineTo(size.width * 0.5, size.height * 0.85);
    path.lineTo(size.width * 0.8, size.height * 0.35);
    
    path.moveTo(size.width * 0.35, size.height * 0.2);
    path.lineTo(size.width * 0.65, size.height * 0.2);
    path.lineTo(size.width * 0.5, size.height * 0.45);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
