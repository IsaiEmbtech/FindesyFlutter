import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:find_esy1/app/routes/app_pages.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MobVerifyOtpPage extends StatelessWidget {
  final _otpController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isOtpComplete = false.obs;

  MobVerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Animated phone number display
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Enter OTP sent to ${args['phone']}',
                key: ValueKey(args['phone']),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // OTP Input Field with animations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                autoFocus: true,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.transparent,
                  activeColor: theme.colorScheme.primary,
                  selectedColor: theme.colorScheme.primary,
                  inactiveColor: theme.colorScheme.onSurface.withOpacity(0.2),
                  inactiveFillColor: Colors.transparent,
                  selectedFillColor: Colors.transparent,
                ),
                onChanged: (value) {
                  isOtpComplete.value = value.length == 6;
                },
                onCompleted: (otp) => _verifyOtp(args['otpSessionId'], otp, args['phone']),
                beforeTextPaste: (text) {
                  // Only allow numeric input
                  return RegExp(r'^[0-9]+$').hasMatch(text ?? '');
                },
              ),
            ),
            const SizedBox(height: 40),

            // Verify Button with loading state
            Obx(() {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (isOtpComplete.value && !isLoading.value)
                        ? () => _verifyOtp(
                        args['otpSessionId'],
                        _otpController.text,
                        args['phone'])
                        : null,
                    child: isLoading.value
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Verify',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            }),

            // Resend OTP option
            TextButton(
              onPressed: () {
              },
              child: Text(
                'Resend OTP',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOtp(String otpSessionId, String otp, String phone) async {
    if (otp.length != 6) return;

    isLoading.value = true;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      Get.toNamed(
        Routes.MOB_CREATE_ACC,
        arguments: {
          'otpSessionId': otpSessionId,
          'otp': otp,
          'phone': phone,
        },

      );
    } finally {
      isLoading.value = false;
    }
  }
}