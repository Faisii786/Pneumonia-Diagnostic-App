import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pneumonia_diagnostic_app/Common/Screens/botton_nav_bar.dart';

class UploadImageController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = File(image.path);

      Get.back(); // Close bottom sheet

      // Wait for 3 seconds, then navigate
      Future.delayed(Duration(seconds: 3), () {
        Get.off(() => BottomNavBar());
      });
    } else {
      Get.back();
    }
  }
}
