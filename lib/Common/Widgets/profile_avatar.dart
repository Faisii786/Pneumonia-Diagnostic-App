import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/features/Profile/Controller/profile_controller.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  const ProfileAvatar({this.size = 48, super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    return Obx(() {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.5,
          ),
        ),
        child: ClipOval(
          child: profileController.hasProfileImage
              ? Image.network(
                  profileController.profileImageUrlValue,
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  errorBuilder: (context, error, stackTrace) =>
                      _defaultAvatar(size),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: size * 0.4,
                        height: size * 0.4,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor),
                        ),
                      ),
                    );
                  },
                )
              : _defaultAvatar(size),
        ),
      );
    });
  }

  Widget _defaultAvatar(double size) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: size * 0.7,
        color: AppColors.primaryColor.withOpacity(0.7),
      ),
    );
  }
}
