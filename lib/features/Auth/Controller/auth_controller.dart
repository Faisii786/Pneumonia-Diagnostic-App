import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:pneumonia_diagnostic_app/features/Auth/Model/user_model.dart';
import 'package:pneumonia_diagnostic_app/features/Auth/View/Sign%20in/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var isLoading = false.obs;
  var userData = {}.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rxn<UserModel>();

  // Fallback storage for when SharedPreferences fails
  static String? _fallbackUserId;
  static String? _fallbackUserName;

  @override
  void onInit() {
    super.onInit();
    // Removed automatic checkLoginStatus call to prevent race conditions
    // The splash screen will handle checking login status
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    try {
      String? userId;
      String? userName;

      // Try to get SharedPreferences with timeout
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = prefs.getString('user_id');
        userName = prefs.getString('user_name');
      } catch (e) {
        // Use fallback storage
        userId = _fallbackUserId;
        userName = _fallbackUserName;
      }

      if (userId != null && userName != null && userId.isNotEmpty) {
        UserModel? user = await getUserData(userId);
        if (user != null) {
          currentUser.value = user;
          userData.value = user.toMap();
          isLoggedIn.value = true;
        } else {
          await clearUserData();
        }
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
  }

  // Save user data to local storage
  Future<void> saveUserToLocalStorage(UserModel user) async {
    try {
      // Save to fallback storage first
      _fallbackUserId = user.id;
      _fallbackUserName = user.name;

      // Try SharedPreferences
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', user.id ?? '');
        await prefs.setString('user_name', user.name ?? '');
      } catch (e) {
        // SharedPreferences failed, using fallback storage only
      }
    } catch (e) {
      // Error saving user to local storage
    }
  }

  // Clear user data from local storage
  Future<void> clearUserData() async {
    try {
      // Clear fallback storage
      _fallbackUserId = null;
      _fallbackUserName = null;

      // Try SharedPreferences
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('user_name');
      } catch (e) {
        // SharedPreferences failed, using fallback storage only
      }

      currentUser.value = null;
      userData.value = {};
      isLoggedIn.value = false;
    } catch (e) {
      // Error clearing user data
    }
  }

  // Test Firestore connection
  Future<bool> testFirestoreConnection() async {
    try {
      await _firestore.collection('test').doc('test').get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Generate a simple unique user ID
  String _generateUserId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          20, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Save user data to Firestore using UserModel
  Future<bool> saveUserData({
    required String name,
    required String gender,
  }) async {
    try {
      isLoading.value = true;

      // Generate a unique user ID
      String userId = _generateUserId();

      // Create UserModel instance with available data
      UserModel userModel = UserModel(
        id: userId,
        name: name,
        gender: gender,
        email: '',
        password: '',
        profilePic: '',
        phoneNumber: '',
        dateOfBirth: '',
        isOnline: false,
        lastActive: '',
        pushToken: '',
        token: '',
      );

      // Convert to map for Firestore
      Map<String, dynamic> userDataMap = userModel.toMap();

      // Save to Firestore
      await _firestore.collection('users').doc(userId).set(userDataMap);

      // Save to local storage
      await saveUserToLocalStorage(userModel);

      // Store user data in observable
      this.userData.value = userDataMap;
      currentUser.value = userModel;
      isLoggedIn.value = true;

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  // Get user data from Firestore and convert to UserModel
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update user data
  Future<bool> updateUserData({
    required String userId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      isLoading.value = true;

      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(userId).update(updateData);

      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    await clearUserData();
    Get.to(() => SignInScreen());
  }

  // Manually refresh login status
  Future<void> refreshLoginStatus() async {
    await checkLoginStatus();
  }
}
