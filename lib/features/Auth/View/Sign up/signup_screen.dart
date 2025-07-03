import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/text_field.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/View/Sign%20in/signin_screen.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/media_query.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/size_box.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMediaQuery(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/signup.png',
                width: mq.getWidth(.7),
              ),
              const CustomSizedBox(
                height: 0.05,
              ),
              CustomText(
                text: 'Create your account',
                fontFamily: 'pop',
                size: 20,
                weight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              const CustomSizedBox(height: 0.01),
              CustomText(
                text: "It's just few minutes and free!",
                fontFamily: 'pop',
                size: 14,
                color: AppColors.greyColor,
              ),
              const CustomSizedBox(height: 0.05),
              CustomTextField(
                isBorder: true,
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.greyColor,
                ),
                text: 'Name',
              ),
              const CustomSizedBox(height: 0.02),
              CustomTextField(
                isBorder: true,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.greyColor,
                ),
                text: 'Email',
              ),
              const CustomSizedBox(height: 0.02),
              CustomTextField(
                isBorder: true,
                prefixIcon: Icon(
                  Icons.security,
                  color: AppColors.greyColor,
                ),
                suffixIcon: Icon(
                  Icons.visibility_off,
                  color: AppColors.greyColor,
                ),
                text: 'Password',
              ),
              const CustomSizedBox(height: 0.05),
              CustomButton(
                btnName: 'SIGN UP',
                ontap: () async {},
              ),
              const CustomSizedBox(height: 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Already have an account?",
                    size: 16,
                    fontFamily: 'pop',
                  ),
                  const CustomSizedBox(
                    width: 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAll(const SignInScreen());
                    },
                    child: CustomText(
                      text: "Login",
                      size: 17,
                      color: AppColors.primaryColor,
                      weight: FontWeight.w600,
                      fontFamily: 'pop',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
