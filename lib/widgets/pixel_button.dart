import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PixelButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool primary;
  final double height;

  const PixelButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.primary = false,
    this.height = 54,
  }) : super(key: key);

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.primary;

    final gradient = isPrimary
        ? const LinearGradient(
            colors: [AppColors.neonGreen, AppColors.neonGreenDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    final bgColor = isPrimary ? null : AppColors.card;
    final borderColor =
        isPrimary ? AppColors.neonGreen : AppColors.borderGreen;
    final textColor = isPrimary ? Colors.black : AppColors.textWhite;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: widget.height,
        transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.35),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: textColor, size: 22),
              const SizedBox(width: 10),
            ],
            Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}