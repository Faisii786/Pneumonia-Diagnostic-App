import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pneumonia_diagnostic_app/features/Dashboard/View/dashboard_screen1.dart';
import 'package:pneumonia_diagnostic_app/features/Report/View/report_screen.dart';
import 'package:pneumonia_diagnostic_app/features/Profile/View/profile_screen.dart';
import 'package:pneumonia_diagnostic_app/utills/constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final String userName;

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.report),
      label: 'Report',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  BottomNavBar({super.key, this.userName = "User"});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());
    final List<Widget> screens = [
      DashboardScreen(userName: userName),
      ReportScreen(
        patientName: 'John Doe',
        result: 'No Pneumonia Detected',
        date: '2024-06-01',
      ),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: Obx(() {
        // Only show the selected screen, do not force dashboard after image selection
        return screens[controller.currentIndex.value];
      }),
      bottomNavigationBar: Obx(
        () => Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BottomNavigationBar(
                selectedIconTheme: const IconThemeData(size: 27),
                unselectedIconTheme: const IconThemeData(size: 27),
                items: _navItems,
                currentIndex: controller.currentIndex.value,
                onTap: controller.updateIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.primaryColor,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withOpacity(0.6),
                selectedFontSize: 14,
                unselectedFontSize: 14,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                elevation: 8.0,
                selectedLabelStyle: TextStyle(fontFamily: 'pop'),
                unselectedLabelStyle: TextStyle(fontFamily: 'pop'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
