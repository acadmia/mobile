import 'package:flutter/material.dart';
import '../bordo_colors.dart';
import '../typography.dart';

class BordoButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isAccent;

  const BordoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isAccent ? BordoColors.accent : BordoColors.primary,
        foregroundColor: BordoColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: BordoTypography.body),
    );
  }
}
