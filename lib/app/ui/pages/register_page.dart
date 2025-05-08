import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:find_esy1/app/routes/app_pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RxBool isLoading = false.obs;
  final box = GetStorage();
  //
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Future<void> _signInWithGoogle() async {
  //   try {
  //     isLoading.value = true;
  //     print('🔄 Starting Google sign-in flow...');
  //
  //     final GoogleSignInAccount? account = await _googleSignIn.signIn();
  //     if (account == null) {
  //       print('❌ User cancelled sign-in.');
  //       throw Exception('Sign in cancelled by user');
  //     }
  //
  //     print('✅ Google account selected: ${account.displayName} (${account.email})');
  //
  //     final GoogleSignInAuthentication auth = await account.authentication;
  //     print("👤 Google ID: ${account.id}") ;
  //     print('🔑 Access Token: ${auth.accessToken}');
  //     print('👤 Display Name: ${account.displayName}');
  //     print('📧 Email: ${account.email}');
  //     print('🖼️ Photo URL: ${account.photoUrl}');
  //
  //     // Simulate storing data locally without backend call
  //     box.write('token', auth.accessToken);
  //     box.write('name', account.displayName);
  //     box.write('email', account.email);
  //     box.write('avatar_url', account.photoUrl);
  //
  //     Get.snackbar(
  //       'Google Sign-In Success',
  //       'Welcome ${account.displayName}!',
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //
  //     Future.delayed(const Duration(seconds: 2), () {
  //       Get.offAllNamed(Routes.PROFILE);
  //     });
  //   } catch (e, stack) {
  //     print('🚨 Exception caught: $e');
  //     print('🧵 Stack trace: $stack');
  //     Get.snackbar(
  //       'Sign-In Failed',
  //       e.toString(),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> _signInWithGoogle() async {
    try {
      isLoading.value = true;
      print('🔄 Starting Google sign-in flow...');

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print('❌ User cancelled sign-in.');
        throw Exception('Sign in cancelled by user');
      }

      print('✅ Google account selected: ${account.displayName} (${account.email})');

      final GoogleSignInAuthentication auth = await account.authentication;
      print("👤 Google ID: ${account.id}");
      print('🔑 Access Token: ${auth.accessToken}');
      print('👤 Display Name: ${account.displayName}');
      print('📧 Email: ${account.email}');
      print('🖼️ Photo URL: ${account.photoUrl}');

      // Prepare payload for backend
      final payload = {
        "google_id": account.id,
        "name": account.displayName,
        "email": account.email,
        "avatar_url": account.photoUrl,
      };

      print('📤 Sending payload to backend: $payload');

      // Replace with your actual base URL
      const baseUrl = 'https://findesy.onrender.com'; // e.g., 'https://api.findesy.com'
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ Backend response: $responseData');

        // Store user data in GetStorage
        box.write('token', responseData['user']['token']);
        box.write('id', responseData['user']['id']);
        box.write('email', responseData['user']['email']);
        box.write('name', responseData['user']['name']);
        box.write('avatar_url', responseData['user']['avatar_url']);
        box.write('role', responseData['user']['role']);

        // Print stored data for verification
        print('📦 Stored data:');
        print('🔑 Token: ${box.read('token')}');
        print('🆔 ID: ${box.read('id')}');
        print('📧 Email: ${box.read('email')}');
        print('👤 Name: ${box.read('name')}');
        print('🖼️ Avatar URL: ${box.read('avatar_url')}');
        print('🎭 Role: ${box.read('role')}');

        Get.snackbar(
          'Google Sign-In Success',
          'Welcome ${account.displayName}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate directly to profile page
        Get.offAllNamed(Routes.PROFILE);
      } else {
        throw Exception('Failed to authenticate with backend: ${response.body}');
      }
    } catch (e, stack) {
      print('🚨 Exception caught: $e');
      print('🧵 Stack trace: $stack');
      Get.snackbar(
        'Sign-In Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.g_mobiledata,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Welcome to Findesy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create your account to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  Obx(() => ElevatedButton(
                    onPressed: isLoading.value ? null : _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      elevation: 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.login_rounded),
                        SizedBox(width: 12),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () => Get.offAllNamed(Routes.LOGIN),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Obx(() => isLoading.value
              ? Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.redAccent),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
