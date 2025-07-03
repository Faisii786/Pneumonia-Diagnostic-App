import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/custom_text.dart';
import 'package:pneumonia_diagnostic_app/Common/Widgets/profile_avatar.dart';
import 'package:pneumonia_diagnostic_app/features/Analysis/View/analysis_screen.dart';
import 'package:pneumonia_diagnostic_app/features/Settings/View/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  const DashboardScreen({super.key, this.userName = "User"});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                print('Camera picked: \\${pickedFile?.path}');
                if (pickedFile != null) {
                  setState(() {});
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnalysisScreen(imagePath: pickedFile.path),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                print('Gallery picked: \\${pickedFile?.path}');
                if (pickedFile != null) {
                  setState(() {});
                  Get.to(
                    () => AnalysisScreen(imagePath: pickedFile.path),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Pneumonia Diagnostic App',
          color: Colors.white,
          size: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top navbar with profile pic and name
            Row(
              children: [
                const ProfileAvatar(size: 48),
                const SizedBox(width: 12),
                CustomText(
                  text: widget.userName,
                  size: 18,
                  weight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomText(
              text: 'Welcome back!',
              size: 24,
              weight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 10),
            CustomText(
              text: 'Select an option to get started:',
              size: 16,
              color: Colors.black87,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    icon: Icons.camera_alt_rounded,
                    title: 'Scan X-ray',
                    color: Colors.blueAccent,
                    onTap: _pickImage,
                  ),
                  _DashboardCard(
                    icon: Icons.analytics_rounded,
                    title: 'View Reports',
                    color: Colors.green,
                    onTap: () {
                      // Navigate to Reports screen
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.info_outline,
                    title: 'App Info',
                    color: Colors.orange,
                    onTap: () {
                      // Navigate to Info screen
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    color: Colors.purple,
                    onTap: () {
                      Get.to(() => SettingsScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              CustomText(
                text: title,
                size: 16,
                weight: FontWeight.w600,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
