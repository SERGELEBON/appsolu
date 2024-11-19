import 'package:flutter/material.dart';
import '../../../core/constant/colors.dart';

class RechargeOption extends StatelessWidget {
  final IconData? icon;
  final String? imageAsset;
  final String label;
  final String fee;
  final Color iconColor;
  final VoidCallback onPressed;

  const RechargeOption({
    this.icon,
    this.imageAsset,
    required this.label,
    required this.fee,
    required this.iconColor,
    required this.onPressed, required int height, required int width,
  }) : assert(icon != null || imageAsset != null, 'Either icon or imageAsset must be provided.');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset!, width: 32, height: 32)  // Affichage de l'image si fournie
            else if (icon != null)
              Icon(icon, color: iconColor, size: 32),  // Affichage de l'icône si fournie
            SizedBox(width: 15),
            Expanded(
              child: Text(label, style: TextStyle(color: AppColors.text, fontSize: 16)),
            ),
            Text(fee, style: TextStyle(color: AppColors.accent, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
