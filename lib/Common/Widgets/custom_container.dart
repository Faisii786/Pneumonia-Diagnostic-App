import 'package:flutter/material.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';

class CustomContainer extends StatelessWidget {
  final Color? borderColor;
  final Widget widget;

  const CustomContainer({super.key, required this.widget, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor ?? AppColors.greyColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget,
    );
  }
}
