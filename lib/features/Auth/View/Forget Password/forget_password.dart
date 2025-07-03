import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/text_field.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/View/Sign%20in/signin_screen.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/View/Sign%20up/signup_screen.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/media_query.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/size_box.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMediaQuery(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/resetPassword.png',
                  width: mq.getWidth(.6),
                ),
                const CustomSizedBox(height: 0.04),
                CustomText(
                  text: 'Forgot Your Password?',
                  fontFamily: 'pop',
                  size: 20,
                  weight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const CustomSizedBox(height: 0.02),
                CustomText(
                  text:
                      'Enter your email below, and we’ll send you a link to reset your password.',
                  size: 16,
                  align: TextAlign.center,
                  color: AppColors.greyColor,
                  fontFamily: 'pop',
                ),
                const CustomSizedBox(height: 0.05),
                CustomTextField(
                  isBorder: true,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.greyColor,
                  ),
                  text: 'Email',
                ),
                const CustomSizedBox(height: 0.05),
                CustomButton(
                  btnName: 'Send Reset Link',
                  ontap: () {},
                ),
                const CustomSizedBox(height: 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: "Don't have an account?",
                      size: 16,
                      fontFamily: 'pop',
                    ),
                    const CustomSizedBox(width: 0.02),
                    InkWell(
                      onTap: () {
                        Get.offAll(const SignUpScreen());
                      },
                      child: CustomText(
                        text: "Register",
                        size: 17,
                        color: AppColors.primaryColor,
                        weight: FontWeight.w600,
                        fontFamily: 'pop',
                      ),
                    ),
                  ],
                ),
                const CustomSizedBox(height: 0.03),
                TextButton(
                  onPressed: () {
                    Get.offAll(() => SignInScreen());
                  },
                  child: CustomText(
                    text: "Back to Login",
                    size: 16,
                    color: AppColors.primaryColor,
                    weight: FontWeight.w600,
                    fontFamily: 'pop',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
