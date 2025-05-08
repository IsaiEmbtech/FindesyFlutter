import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:find_esy1/services/auth_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:find_esy1/app/routes/app_pages.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OtpPage extends StatelessWidget {
  final AuthService _authService = Get.find();
  final _otpController = TextEditingController();

  OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final otpSessionId = args['otpSessionId'];
    final phone = args['phone'];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard on tap outside
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify OTP'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Enter OTP',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
              ).animate().fadeIn().slideY(begin: -0.5),

              const SizedBox(height: 10),

              // Subtitle
              Text(
                'OTP sent to $phone',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 30),

              // OTP Field
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  inactiveColor: Colors.grey[300],
                  activeColor: Colors.blue,
                  selectedColor: Colors.blueAccent,
                  activeFillColor: Colors.blue.shade50,
                  selectedFillColor: Colors.blue.shade100,
                  inactiveFillColor: Colors.grey.shade100,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                onCompleted: (v) => _verifyOtp(otpSessionId, v),
                onChanged: (value) {},
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

              const SizedBox(height: 20),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final otp = _otpController.text.trim();
                    if (otp.isEmpty || otp.length < 6) {
                      Get.snackbar(
                        'Error',
                        'Please enter the 6-digit OTP',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    } else {
                      _verifyOtp(otpSessionId, otp);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(String otpSessionId, String otp) async {
    try {
      print("Verfiy OTP : $otpSessionId , $otp");
      var  k = await _authService.verifyOtp(otpSessionId, otp);
      print(k);
      Get.offAllNamed(Routes.PROFILE);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
