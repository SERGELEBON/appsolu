import 'package:flutter/material.dart';

import '../../../library/common_widgets/app_colors.dart';




class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, required TextStyle style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.text,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
