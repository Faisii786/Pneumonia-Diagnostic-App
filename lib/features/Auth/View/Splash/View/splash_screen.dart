import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/Controller/auth_controller.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/View/Sign%20in/signin_screen.dart';
import 'package:pneumonia_diagnostic_app/Common/Screens/botton_nav_bar.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    // Wait for auth controller to initialize and check login status
    await Future.delayed(const Duration(seconds: 2));

    // Wait for the auth controller to finish checking login status
    await authController.checkLoginStatus();

    // Now check the login status and navigate
    if (authController.isLoggedIn.value) {
      Get.offAll(() => BottomNavBar(
            userName: authController.currentUser.value?.name ?? 'User',
          ));
    } else {
      Get.offAll(() => const SignInScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(
              Icons.medical_services,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              'Pneumonia Diagnostic',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'pop',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'AI-Powered Medical Analysis',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'pop',
              ),
            ),
            const SizedBox(height: 50),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
