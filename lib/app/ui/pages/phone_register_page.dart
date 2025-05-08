import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:find_esy1/services/auth_service.dart';
import 'package:find_esy1/app/routes/app_pages.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneRegisterPageState();
}

class _PhoneRegisterPageState extends State<PhoneLoginPage> {
  final AuthService _authService = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final RxBool _isPhoneValid = false.obs;

  PhoneNumber? _phoneNumber;
  bool _isLoading = false;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(300.ms, () => setState(() => _showTitle = true));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Animated Title
              AnimatedContainer(
                duration: 500.ms,
                height: _showTitle ? null : 0,
                child: const Text(
                  'Welcome Back to FindEsy \n Login with Phone Number',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: -0.5),
              ),
              const SizedBox(height: 40),

              // Phone Number Field
              IntlPhoneField(
                controller: _phoneController,
                initialCountryCode: 'IN',
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                ),
                dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                style: const TextStyle(fontSize: 16),
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onChanged: (phone) {
                  _phoneNumber = phone;

                  final isValid = RegExp(r'^[6-9]\d{9}$').hasMatch(phone.number);
                  _isPhoneValid.value = isValid;
                },
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.5),
              const SizedBox(height: 30),

              // Submit Button with validation state
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (!_isPhoneValid.value || _isLoading) ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.blue.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'GET OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
              )),
              const SizedBox(height: 20),

              // Already Registered
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not Having Register \n Phone Number?"),
                  TextButton(
                    onPressed: () => Get.offNamed(Routes.MOB_SEND_OTP),
                    child: const Text(
                      'Register with Phone',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
  // Future<void> _sendOtp() async {
  //   if (_formKey.currentState!.validate() && _phoneNumber != null) {
  //     try {
  //       setState(() => _isLoading = true);
  //       final completeNumber = '+${_phoneNumber!.countryCode}${_phoneNumber!.number}';
  //      print("Complete Number $completeNumber");
  //       await Future.delayed(300.ms);
  //
  //       final response = await _authService.sendOtp(completeNumber);
  //
  //       Get.toNamed(
  //         Routes.OTP,
  //         arguments: {
  //           'otpSessionId': response['otpSessionId'],
  //           'phone': completeNumber,
  //         },
  //       );
  //     } catch (e) {
  //       Get.snackbar(
  //         'Error',
  //         e.toString(),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //         duration: const Duration(seconds: 3),
  //         margin: const EdgeInsets.all(16),
  //         borderRadius: 12,
  //         animationDuration: 300.ms,
  //       );
  //     } finally {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }
  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate() && _phoneNumber != null) {
      try {
        setState(() => _isLoading = true);

        // Use only the phone number without the country code
        final phoneNumber = _phoneNumber!.number; // Assuming _phoneNumber has a 'number' property
        print("Phone Number: $phoneNumber");

        await Future.delayed(300.ms);

        // Send the OTP using the phone number only
        final response = await _authService.sendOtp(phoneNumber);

        Get.toNamed(
          Routes.OTP,
          arguments: {
            'otpSessionId': response['otpSessionId'],
            'phone': phoneNumber, // Pass the phone number without country code
          },
        );
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
          animationDuration: 300.ms,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

}
