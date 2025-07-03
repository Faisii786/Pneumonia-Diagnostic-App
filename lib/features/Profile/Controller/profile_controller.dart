import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:pneumonia_diagnostic_app/features/Auth/Controller/auth_controller.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/Model/user_model.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  var isUploadingImage = false.obs;
  var selectedImage = Rxn<File>();
  var profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Set current profile image URL
    refreshProfileImageUrl();

    // Listen to user changes
    ever(authController.currentUser, (UserModel? user) {
      refreshProfileImageUrl();
    });
  }

  // Refresh profile image URL
  void refreshProfileImageUrl() {
    profileImageUrl.value = authController.currentUser.value?.profilePic ?? '';
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        await uploadImageToFirebase();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Take photo with camera
  Future<void> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        await uploadImageToFirebase();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Upload image to Firebase Storage
  Future<void> uploadImageToFirebase() async {
    if (selectedImage.value == null) return;

    try {
      isUploadingImage.value = true;

      final user = authController.currentUser.value;
      if (user == null) {
        throw Exception('User not found');
      }

      // Create storage reference
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload file
      final uploadTask = storageRef.putFile(selectedImage.value!);
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user model with new profile image URL
      await updateUserProfileImage(downloadUrl);

      // Update local observable
      profileImageUrl.value = downloadUrl;

      Get.snackbar(
        'Success',
        'Profile image updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingImage.value = false;
      selectedImage.value = null;
    }
  }

  // Update user profile image in Firestore
  Future<void> updateUserProfileImage(String imageUrl) async {
    try {
      final user = authController.currentUser.value;
      if (user == null) return;

      // Update in Firestore
      await authController.updateUserData(
        userId: user.id!,
        updateData: {'profilePic': imageUrl},
      );

      // Update local user model
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        profilePic: imageUrl,
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        dateOfBirth: user.dateOfBirth,
        isOnline: user.isOnline,
        lastActive: user.lastActive,
        pushToken: user.pushToken,
        token: user.token,
      );

      // Update auth controller
      authController.currentUser.value = updatedUser;
      authController.userData.value = updatedUser.toMap();
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }

  // Show image picker dialog
  void showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                takePhotoWithCamera();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Get current user
  UserModel? get currentUser => authController.currentUser.value;

  // Check if user has profile image
  bool get hasProfileImage => profileImageUrl.value.isNotEmpty;

  // Get profile image URL
  String get profileImageUrlValue => profileImageUrl.value;
}
