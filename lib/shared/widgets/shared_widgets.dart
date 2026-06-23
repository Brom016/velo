import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class VeloTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscure;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const VeloTextField({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.prefixIcon,
    this.keyboardType,
    this.obscure = false,
    this.onChanged,
    this.validator,
  });

  @override
  State<VeloTextField> createState() => _VeloTextFieldState();
}

class _VeloTextFieldState extends State<VeloTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      style: AppTextStyles.body,
      onChanged: widget.onChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.textSecondary, size: 20)
            : null,
        suffixIcon: widget.obscure
            ? GestureDetector(
                onTap: () => setState(() => _obscureText = !_obscureText),
                child: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary, size: 20),
              )
            : null,
      ),
    );
  }
}

class VeloCard extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final VoidCallback? onTap;
  final Widget child;

  const VeloCard({
    super.key,
    this.padding = const EdgeInsets.all(AppDimensions.cardPadding),
    this.borderColor = AppColors.border,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

class LockedFeatureView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onLogin;

  const LockedFeatureView({
    super.key,
    required this.title,
    required this.message,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline,
                size: 48, color: AppColors.textDisabled),
            const SizedBox(height: AppDimensions.md),
            Text(title, style: AppTextStyles.heading),
            const SizedBox(height: AppDimensions.sm),
            Text(message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary)),
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              width: 200,
              child: TextButton(
                onPressed: onLogin,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.amber,
                  foregroundColor: AppColors.bgPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
                child: const Text('Login Sekarang', style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;

  const ErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
            color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 16, color: AppColors.danger),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Text(message,
              style: AppTextStyles.body.copyWith(
                  color: AppColors.danger, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
