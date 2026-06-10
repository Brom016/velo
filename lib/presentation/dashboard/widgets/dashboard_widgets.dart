import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';

class SpeedometerGauge extends StatelessWidget {
  final double speed;
  final double maxScale;
  final double size;

  const SpeedometerGauge({
    super.key,
    required this.speed,
    this.maxScale = 200,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (speed / maxScale).clamp(0.0, 1.0);
    final startAngle = 150.0;
    final sweepAngle = 240.0;
    final currentAngle = startAngle + sweepAngle * progress;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SpeedometerPainter(
          progress: progress,
          maxScale: maxScale,
          startAngle: startAngle,
          sweepAngle: sweepAngle,
          currentAngle: currentAngle,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Formatters.speed(speed),
                style: AppTextStyles.monoHero.copyWith(fontSize: 56),
              ),
              Text('km/h', style: AppTextStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double progress;
  final double maxScale;
  final double startAngle;
  final double sweepAngle;
  final double currentAngle;

  _SpeedometerPainter({
    required this.progress,
    required this.maxScale,
    required this.startAngle,
    required this.sweepAngle,
    required this.currentAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    final trackPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _radians(startAngle),
      _radians(sweepAngle),
      false,
      trackPaint,
    );

    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.cyan, AppColors.amber],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _radians(startAngle),
      _radians(sweepAngle * progress),
      false,
      activePaint,
    );

    final glowPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _radians(startAngle),
      _radians(sweepAngle * progress),
      false,
      glowPaint,
    );

    for (int i = 0; i <= 24; i++) {
      final angle = startAngle + (sweepAngle / 24) * i;
      final isMajor = i % 6 == 0;
      final innerR = radius - (isMajor ? 14 : 8);
      final outerR = radius - 4;
      canvas.drawLine(
        Offset(center.dx + innerR * math.cos(_radians(angle)),
            center.dy + innerR * math.sin(_radians(angle))),
        Offset(center.dx + outerR * math.cos(_radians(angle)),
            center.dy + outerR * math.sin(_radians(angle))),
        Paint()
          ..color = isMajor ? AppColors.textSecondary : AppColors.border
          ..strokeWidth = isMajor ? 1.5 : 1,
      );
    }
  }

  double _radians(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(covariant _SpeedometerPainter old) =>
      old.progress != progress;
}

class GForceIndicator extends StatelessWidget {
  final double gX;
  final double gY;
  final double magnitude;
  final double size;

  const GForceIndicator({
    super.key,
    required this.gX,
    required this.gY,
    required this.magnitude,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _GForcePainter(gX: gX, gY: gY),
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          '${Formatters.gForce(magnitude)} G',
          style: AppTextStyles.monoSm.copyWith(color: AppColors.amber),
        ),
      ],
    );
  }
}

class _GForcePainter extends CustomPainter {
  final double gX;
  final double gY;

  _GForcePainter({required this.gX, required this.gY});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.bgCard
      ..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.amber.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    for (final g in [0.5, 1.0, 1.5]) {
      final r = radius * (g / 2);
      canvas.drawCircle(center, r, Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5);
    }

    final crossPaint = Paint()
      ..color = AppColors.textSecondary.withValues(alpha: 0.25)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - radius),
        Offset(center.dx, center.dy + radius), crossPaint);

    final clampedX = (gX / 2).clamp(-1.0, 1.0) * radius;
    final clampedY = (gY / 2).clamp(-1.0, 1.0) * radius;
    final dotPos = Offset(center.dx + clampedX, center.dy - clampedY);

    canvas.drawCircle(dotPos, 4, Paint()..color = AppColors.danger);
    canvas.drawCircle(dotPos, 6, Paint()
      ..color = AppColors.danger.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
  }

  @override
  bool shouldRepaint(covariant _GForcePainter old) =>
      old.gX != gX || old.gY != gY;
}

class CompassIndicator extends StatelessWidget {
  final double bearing;
  final double size;

  const CompassIndicator({
    super.key,
    required this.bearing,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CompassPainter(bearing: bearing),
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          Formatters.bearing(bearing),
          style: AppTextStyles.monoSm.copyWith(color: AppColors.cyan),
        ),
      ],
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double bearing;

  _CompassPainter({required this.bearing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.bgCard
      ..style = PaintingStyle.fill);
    canvas.drawCircle(center, radius, Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    // Fixed tick marks
    for (int i = 0; i < 36; i++) {
      final angle = i * 10 * math.pi / 180;
      final isMajor = i % 9 == 0;
      final innerR = radius - (isMajor ? 14 : 8);
      final outerR = radius - 4;
      canvas.drawLine(
        Offset(center.dx + innerR * math.cos(angle),
               center.dy + innerR * math.sin(angle)),
        Offset(center.dx + outerR * math.cos(angle),
               center.dy + outerR * math.sin(angle)),
        Paint()
          ..color = isMajor ? AppColors.textSecondary : AppColors.border
          ..strokeWidth = isMajor ? 1.5 : 1,
      );
    }

    // Fixed labels (N at top, E right, S bottom, W left)
    const labels = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90 - 90) * math.pi / 180;
      final labelR = radius - 20;
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: AppTextStyles.monoXs.copyWith(
            color: i == 0 ? AppColors.amber : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          center.dx + labelR * math.cos(angle) - tp.width / 2,
          center.dy + labelR * math.sin(angle) - tp.height / 2,
        ),
      );
    }

    // Rotating needle
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(bearing * math.pi / 180);
    canvas.drawLine(
      Offset(0, -radius + 14),
      Offset(0, radius - 14),
      Paint()
        ..color = AppColors.amber
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(0, -radius + 14),
      3,
      Paint()..color = AppColors.amber,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CompassPainter old) =>
      old.bearing != bearing;
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color valueColor;
  final bool locked;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.unit = '',
    this.valueColor = AppColors.cyan,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (locked)
            Row(
              children: [
                const Icon(Icons.lock_outline,
                    size: 10, color: AppColors.textDisabled),
                const SizedBox(width: 4),
                Text(label, style: AppTextStyles.label),
              ],
            )
          else ...[
            Text(label, style: AppTextStyles.label),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value,
                  style: AppTextStyles.monoMd.copyWith(color: valueColor)),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(unit,
                    style: AppTextStyles.monoXs
                        .copyWith(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class LiveBadge extends StatefulWidget {
  final String label;
  final Color color;

  const LiveBadge({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _anim,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(widget.label,
          style: AppTextStyles.monoXs.copyWith(color: widget.color)),
      ],
    );
  }
}
