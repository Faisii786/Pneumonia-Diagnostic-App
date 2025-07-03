import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/Controller/auth_controller.dart';
import 'package:pneumonia_diagnostic_app/features/Profile/Controller/profile_controller.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/profile_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final user = profileController.currentUser;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // User Avatar with Image Upload
              GestureDetector(
                onTap: () {
                  if (!profileController.isUploadingImage.value) {
                    profileController.showImagePickerDialog();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const ProfileAvatar(size: 200),
                    // Upload indicator
                    if (profileController.isUploadingImage.value)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    // Edit icon
                    if (!profileController.isUploadingImage.value)
                      Positioned(
                        bottom: 8,
                        right: 12,
                        child: Material(
                          color: AppColors.primaryColor,
                          shape: const CircleBorder(),
                          elevation: 4,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              profileController.showImagePickerDialog();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // User Name
              CustomText(
                text: user?.name ?? 'User Name',
                size: 24,
                weight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 10),

              // User Gender
              if (user?.gender != null && user!.gender!.isNotEmpty)
                CustomText(
                  text: 'Gender: ${user.gender}',
                  size: 16,
                  color: AppColors.greyColor,
                ),
              const SizedBox(height: 30),

              // User Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'User Information',
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 15),
                    _buildInfoRow('Name', user?.name ?? 'N/A'),
                    _buildInfoRow('Gender', user?.gender ?? 'N/A'),
                  ],
                ),
              ),

              const Spacer(),

              // Logout Button
              CustomButton(
                btnName: 'Logout',
                buttonColor: Colors.red,
                ontap: () {
                  _showLogoutDialog(context, authController);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: CustomText(
              text: '$label:',
              size: 14,
              weight: FontWeight.w500,
              color: AppColors.greyColor,
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              size: 14,
              weight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                authController.logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
