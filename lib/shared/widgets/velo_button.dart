import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

enum VeloButtonStyle { primary, danger, outline, ghost }

class VeloButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VeloButtonStyle style;
  final bool loading;
  final double width;
  final double height;
  final VoidCallback? onPressed;

  const VeloButton({
    super.key,
    required this.label,
    this.icon,
    this.style = VeloButtonStyle.primary,
    this.loading = false,
    this.width = double.infinity,
    this.height = AppDimensions.buttonHeight,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = loading || onPressed == null;

    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (style) {
      case VeloButtonStyle.primary:
        bgColor = AppColors.amber;
        textColor = AppColors.bgPrimary;
        borderColor = Colors.transparent;
      case VeloButtonStyle.danger:
        bgColor = AppColors.danger;
        textColor = Colors.white;
        borderColor = Colors.transparent;
      case VeloButtonStyle.outline:
        bgColor = Colors.transparent;
        textColor = AppColors.amber;
        borderColor = AppColors.amber;
      case VeloButtonStyle.ghost:
        bgColor = Colors.transparent;
        textColor = AppColors.amber;
        borderColor = Colors.transparent;
    }

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.4),
          disabledForegroundColor: textColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            side: BorderSide(color: borderColor, width: style == VeloButtonStyle.outline ? 1.5 : 0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.bgPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: AppTextStyles.subheading.copyWith(
                    color: disabled
                        ? textColor.withValues(alpha: 0.4)
                        : textColor,
                    fontWeight: FontWeight.w700,
                  )),
                ],
              ),
      ),
    );
  }
}
