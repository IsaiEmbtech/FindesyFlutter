import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:find_esy1/app/routes/app_pages.dart';
import 'package:find_esy1/services/auth_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobSendOtpPage extends StatelessWidget {
  final AuthService _authService = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isValidPhone = false.obs;

  MobSendOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Phone Number'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Animated title
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'We\'ll send an OTP to verify your number',
                  key: const ValueKey('title'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // // Phone input field with country code
              // IntlPhoneField(
              //   controller: _phoneController,
              //   keyboardType: TextInputType.phone,
              //   autofocus: true,
              //   decoration: InputDecoration(
              //     labelText: 'Phone Number',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(
              //         color: theme.colorScheme.outline,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(
              //         color: theme.colorScheme.primary,
              //         width: 2,
              //       ),
              //     ),
              //   ),
              //   initialCountryCode: 'IN',
              //   disableLengthCheck: true,
              //   onChanged: (phone) {
              //     isValidPhone.value = phone.number.isNotEmpty &&
              //         phone.number.length >= 10;
              //   },
              //   validator: (phone) {
              //     if (phone == null || phone.number.isEmpty) {
              //       return 'Please enter phone number';
              //     }
              //     if (phone.number.length < 10) {
              //       return 'Enter valid phone number';
              //     }
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 40),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  isValidPhone.value = value.isNotEmpty && value.length >= 10;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),


              // Send OTP Button with loading state
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
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        disabledBackgroundColor:
                        theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      onPressed: (isValidPhone.value && !isLoading.value)
                          ? _sendOtp
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
                        'Send OTP',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final response = await _authService.sendOtp(_phoneController.text.trim());

        Get.toNamed(
          Routes.MOB_VERIFY_OTP,
          arguments: {
            'otpSessionId': response['otpSessionId'],
            'phone': _phoneController.text.trim()
          },

        );
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}