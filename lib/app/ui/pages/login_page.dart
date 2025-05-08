import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:find_esy1/app/routes/app_pages.dart';
import 'package:find_esy1/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  final AuthService _authService = Get.find();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RxBool isLoading = false.obs;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple)
                      .animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Findesy',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 10),
                  const Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildLoginOptions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Obx(() => isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ).animate().fadeIn(),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOptions() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _animatedOption(
              icon: Icons.phone_android,
              text: 'Continue with Mobile Number',
              onTap: () => Get.toNamed(Routes.PHONE_REGISTER),
            ),
            const SizedBox(height: 20),
            _animatedOption(
              icon: Icons.g_mobiledata,
              text: 'Continue with Google',
              color: Colors.redAccent,
              onTap: _handleGoogleSignIn,
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.deepPurple,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).scale(duration: 300.ms),
      ),
    );
  }
  Future<void> _handleGoogleSignIn() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        await _authService.CreateAccountwithGoogle();
        Get.offAllNamed(Routes.PROFILE);
      }
    } catch (e) {
      print("Google Sign-In Error: $e"); // This will print the error in the console
      Get.snackbar(
        'Login Failed',
        'Could not sign in with Google. Try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

}
