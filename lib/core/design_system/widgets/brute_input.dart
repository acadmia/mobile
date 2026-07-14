import 'package:flutter/material.dart';
import '../bordo_colors.dart';
import '../typography.dart';

class BruteInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const BruteInput({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: BordoColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BordoColors.primary.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: BordoTypography.inputBig.copyWith(fontSize: 24),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: BordoTypography.bodySecondary,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
