import 'package:flutter/material.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final int? maxLines;
  final VoidCallback? suffixPressed;
  final String? Function(String?)? validator;
  final int? maxWords;
  final bool readOnly;
  final bool isBorder;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final VoidCallback? ontap;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.text,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.suffixPressed,
    this.validator,
    this.maxWords,
    this.controller,
    this.readOnly = false,
    this.ontap,
    this.keyboardType,
    this.isBorder = false, // New parameter with default false (no border)
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onTap: widget.ontap,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxWords,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (value) {
        if (widget.textInputAction == TextInputAction.next) {
          FocusScope.of(context).nextFocus();
        }
      },
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        hintText: widget.text,
        hintStyle: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontFamily: 'pop',
          color: AppColors.greyColor,
        ),
        filled: true,
        fillColor: Colors.white,
        border: widget.isBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  width: 1,
                ),
              )
            : InputBorder.none,
        enabledBorder: widget.isBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.greyColor,
                  width: 1,
                ),
              )
            : InputBorder.none,
        focusedBorder: widget.isBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              )
            : InputBorder.none,
      ),
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontFamily: 'pop',
      ),
    );
  }
}
