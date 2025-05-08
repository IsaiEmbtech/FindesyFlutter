import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:find_esy1/services/api_service.dart';

class AuthService extends GetxService {
  final GetStorage _box = GetStorage();
  final ApiService _apiService = Get.find();
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    // Initialize login status when service starts
    isLoggedIn.value = _box.hasData('auth_token');
    super.onInit();
  }
  // Future<dynamic> CreateAccountwithGoogle() async {
  //   try {
  //     print('🔵 Initiating Google login...');
  //     final response = await _apiService.postRequest("auth/google", {});
  //
  //     // Print the full API response for debugging
  //     print('🟢 Google login response: $response');
  //
  //     await _saveUserData(response['user']);
  //     isLoggedIn.value = true;
  //
  //     return response;
  //   } catch (e) {
  //     print('🔴 Google login failed: $e');
  //     throw _handleError(e, 'Google login');
  //   }
  // }
  Future<dynamic> CreateAccountwithGoogle() async {
    try {
      print('🔵 Initiating Google login...');

      // Assuming _apiService.postRequest returns a response that you can decode or parse
      final response = await _apiService.postRequest("auth/google", {});

      // Print the full API response for debugging
      print('🟢 Google login response: $response');

      // Check if the response contains the expected keys
      if (response == null || !response.containsKey('user')) {
        throw Exception('Invalid response from server');
      }

      // Save user data
      await _saveUserData(response['user']);

      // Set the login state to true
      isLoggedIn.value = true;

      // Return the successful response
      return response;
    } catch (e) {
      print('🔴 Google login failed: $e');
      // Handle the error and show more info in case of failure
      throw _handleError(e, 'Google login');
    }
  }


  Future<dynamic> sendOtpforlogin(String mobile) async {
    try {
      print('🔵 Sending OTP to $mobile...');
      final response = await _apiService.postRequest("auth/login/request-otp", {
        "mobile": mobile,
      });

      // Check if the response indicates success
      if (response['success'] == true) {
        print('🟢 OTP sent successfully ');
        print("Response OTP Login $response");
        return response;
      } else {
        // Handle specific error messages
        if (response['error'] != null) {
          if (response['error'].contains("User  not found")) {
            print('🔴 User not found. Please register first.');
            throw Exception('User  not found. Please register first.');
          }
        }
        // Handle other errors
        print('🔴 OTP sending failed: ${response['error']}');
        throw Exception('OTP sending failed: ${response['error']}');
      }
    } catch (e) {
      print('🔴 OTP sending failed: $e');
      throw _handleError(e, 'OTP sending');
    }
  }



  Future<dynamic> verifyOtp(String otpSessionId, String otp) async {
    final GetStorage _box = GetStorage(); // Initialize GetStorage

    try {
      print('🔵 Verifying OTP...');

      if (otpSessionId.isEmpty) {
        throw Exception("OTP session not found. Please request a new OTP.");
      }

      final response = await _apiService.postRequest("auth/login/verify-otp", {
        "otpSessionId": otpSessionId,
        "otp": otp,
      });

      if (response['success'] == true) {
        print('🟢 OTP verified successfully');

        final user = response['user'];

        // ✅ Save user data and token to local storage
        await _box.write('user_data', user);
        await _box.write('auth_token', user['token']);

        print("✅ Saved user_data: ${_box.read('user_data')}");
        print("✅ Saved token: ${_box.read('auth_token')}");

        // ✅ Show success alert
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        return response;
      } else {
        final message = response['message'] ?? 'OTP verification failed';

        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        throw Exception(message);
      }
    } catch (e) {
      print("🔴 OTP verification failed: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<dynamic> sendOtp(String mobile) async {
    try {
      return await _apiService.postRequest("auth/register/send-otp", {
        "mobile": mobile,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> completePhoneRegistration({
    required String otpSessionId,
    required String otp,
    required String phone,
    required String email,
    required String name,
    required Map<String, String> address,
  }) async {
    try {
      final response = await _apiService.postRequest(
        "auth/register/verify-otp",
        {
          "otpSessionId": otpSessionId,
          "otp": otp,
          "mobile": phone,
          "email": email,
          "name": name,
          "address": address,
          "google_id": null,
          "acc_auth_id": null,
          "avatar_url": null,
        },
      );
      await _saveUserData(response['user']);
      isLoggedIn.value = true;
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<dynamic> updateUser(Map<String, dynamic> data) async {
    try {
      print('🔵 Updating user data...');
      final response = await _apiService.postRequest("auth/updateuser", data);

      print('🟢 User updated successfully');
      await _saveUserData(response['user']);
      return response;
    } catch (e) {
      print('🔴 User update failed: $e');
      throw _handleError(e, 'user update');
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> user) async {
    try {
      print('💾 Saving user data to local storage...');
      await _box.write('auth_token', user['auth_token']);
      await _box.write('email', user['email']);
      await _box.write('name', user['name']);
      await _box.write('role', user['role']);
      await _box.write('google_id', user['google_id']);
      await _box.write('user_data', user);
      print('💾 User data saved successfully');
    } catch (e) {
      print('🔴 Failed to save user data: $e');
      throw 'Failed to save user data locally';
    }
  }

  String _handleError(dynamic error, String operation) {
    if (error.toString().contains('Connection error')) {
      return 'No internet connection. Please check your network and try again.';
    }

    else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else {
      return 'Failed to complete $operation. ${error.toString().replaceAll(RegExp(r'Exception: '), '')}';
    }
  }

  Future<void> logout() async {
    try {
      print('🔵 Logging out user...');
      await _box.erase();
      isLoggedIn.value = false;
      print('🟢 User logged out successfully');
    } catch (e) {
      print('🔴 Logout failed: $e');
      throw 'Failed to logout. Please try again.';
    }
  }

  Map<String, dynamic>? get userData => _box.read('user_data');
  String? get token => _box.read('auth_token');
  String? get email => _box.read('email');
  String? get name => _box.read('name');
}