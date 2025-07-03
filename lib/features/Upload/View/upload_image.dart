import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/button.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/features/Upload/Controller/upload_image_controller.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/size_box.dart';

class UploadImageScreen extends StatelessWidget {
  UploadImageScreen({super.key});
  final UploadImageController controller = Get.put(UploadImageController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Upload Image',
          size: 18,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Let’s analyze your chest X-ray',
                size: 22,
                weight: FontWeight.bold,
              ),
              CustomSizedBox(height: 0.01),
              CustomText(
                text: 'Please upload an image using camera or gallery',
                size: 14,
                color: Colors.grey.shade600,
              ),
              CustomSizedBox(height: 0.04),

              // Image Display Section
              Obx(() {
                final imageFile = controller.selectedImage.value;
                return Container(
                  width: size.width * 1,
                  height: size.width * 1,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Colors.grey.shade100,
                  ),
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 50, color: Colors.grey.shade500),
                            CustomSizedBox(height: 0.01),
                            CustomText(
                              text: 'No image selected',
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                );
              }),

              Spacer(),

              // Upload Button
              CustomButton(
                ontap: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Wrap(
                        children: [
                          ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Pick from Camera"),
                              onTap: () {
                                controller.pickImage(ImageSource.camera);
                              }),
                          ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Pick from Gallery"),
                              onTap: () {
                                controller.pickImage(ImageSource.gallery);
                              }),
                        ],
                      ),
                    ),
                  );
                },
                btnName: 'Upload Image',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
