import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/text_field.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/media_query.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/size_box.dart';
import 'package:pneumonia_diagnostic_app/Common/Screens/botton_nav_bar.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/Controller/auth_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController nameController = TextEditingController();
  String? selectedGender;
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final mq = CustomMediaQuery(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login.png',
                  width: mq.getWidth(.7),
                ),
                const CustomSizedBox(
                  height: 0.05,
                ),
                CustomText(
                  text: 'Welcome',
                  fontFamily: 'pop',
                  size: 20,
                  weight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const CustomSizedBox(height: 0.01),
                CustomText(
                  text: 'Enter your details to continue',
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
                  controller: nameController,
                ),
                const CustomSizedBox(height: 0.02),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.wc, color: AppColors.greyColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Gender',
                  ),
                  value: selectedGender,
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                const CustomSizedBox(height: 0.05),
                Obx(() => CustomButton(
                      btnName: 'Continue',
                      isLoading: authController.isLoading.value,
                      ontap: () {
                        if (!authController.isLoading.value) {
                          if (nameController.text.isNotEmpty &&
                              selectedGender != null) {
                            // Test Firestore connection first
                            authController
                                .testFirestoreConnection()
                                .then((connected) {
                              if (connected) {
                                // Save user data to Firestore
                                authController
                                    .saveUserData(
                                  name: nameController.text.trim(),
                                  gender: selectedGender!,
                                )
                                    .then((success) {
                                  if (success) {
                                    // Navigate to bottom nav bar
                                    Get.to(() => BottomNavBar(
                                          userName: nameController.text,
                                        ));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to save user data. Please try again.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }).catchError((error) {
                                  print('Error in signin: $error');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $error'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Firestore connection failed. Please check your internet connection.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter your name and select gender.')),
                            );
                          }
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
