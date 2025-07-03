import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final TextAlign? align;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? height;
  final String? fontFamily;

  const CustomText({
    super.key,
    required this.text,
    this.size,
    this.weight,
    this.color,
    this.align,
    this.decoration,
    this.letterSpacing,
    this.height,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color ?? Colors.black,
        fontFamily: fontFamily ?? 'pop',
        fontSize: size ?? 18,
        fontWeight: weight ?? FontWeight.normal,
        decoration: decoration,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }
}
