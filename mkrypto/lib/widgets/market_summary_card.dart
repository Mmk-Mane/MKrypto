import 'package:flutter/material.dart';

class MarketSummaryCard extends StatelessWidget {
  const MarketSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111C2B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Global Market Cap',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '\$2.41T',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '▲ +1.24% (24h)',
                      style: TextStyle(
                        color: Colors.greenAccent.shade400,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Temporary chart placeholder.
          SizedBox(
            width: 90,
            height: 48,
            child: CustomPaint(painter: _MarketChartPainter()),
          ),
        ],
      ),
    );
  }
}

class _MarketChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.greenAccent
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(0, size.height * 0.75);
    path.lineTo(size.width * 0.10, size.height * 0.65);
    path.lineTo(size.width * 0.20, size.height * 0.70);
    path.lineTo(size.width * 0.30, size.height * 0.45);
    path.lineTo(size.width * 0.40, size.height * 0.55);
    path.lineTo(size.width * 0.50, size.height * 0.30);
    path.lineTo(size.width * 0.60, size.height * 0.40);
    path.lineTo(size.width * 0.70, size.height * 0.20);
    path.lineTo(size.width * 0.80, size.height * 0.30);
    path.lineTo(size.width * 0.90, size.height * 0.10);
    path.lineTo(size.width, size.height * 0.05);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
