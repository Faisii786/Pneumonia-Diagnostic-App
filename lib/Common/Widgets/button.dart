import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/media_query.dart';

class CustomButton extends StatelessWidget {
  final String? btnName;
  final VoidCallback ontap;
  final Color? textColor;
  final Color? buttonColor;
  final Color? filledBorderColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final bool? isLoading;
  final bool? isFilled;

  const CustomButton({
    super.key,
    required this.ontap,
    this.btnName,
    this.buttonColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.isLoading = false,
    this.isFilled = false,
    this.filledBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = CustomMediaQuery(context);
    return InkWell(
        onTap: ontap,
        child: Container(
          width: mediaQuery.getWidth(width ?? 1),
          height: mediaQuery.getHeight(height ?? 0.06),
          decoration: BoxDecoration(
            border: isFilled == true
                ? Border.all(
                    color: filledBorderColor ?? AppColors.primaryColor,
                    width: 1)
                : null,
            color: isFilled == true
                ? Colors.transparent
                : buttonColor ?? AppColors.primaryColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
          child: Center(
            child: isLoading!
                ? const SpinKitFadingCircle(
                    size: 30,
                    color: Colors.white,
                  )
                : CustomText(
                    size: fontSize,
                    text: btnName ?? 'Get Started',
                    weight: FontWeight.w500,
                    color: isFilled == true
                        ? textColor ?? AppColors.primaryColor
                        : textColor ?? Colors.white,
                  ),
          ),
        ));
  }
}
