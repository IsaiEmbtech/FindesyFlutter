import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:find_esy1/services/auth_service.dart';
import 'package:find_esy1/services/location_service.dart';
import 'package:find_esy1/app/routes/app_pages.dart';

class MobCreateAccPage extends StatelessWidget {
  final AuthService _authService = Get.find();
  final LocationService _locationService = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool usingLocation = false.obs;

  MobCreateAccPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Registration').animate().fadeIn(duration: 300.ms),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              Text(
                'Almost there!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 8),

              Text(
                'Complete your profile to get started',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 30),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isEmail ?? false ? null : 'Enter valid email',
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isNotEmpty ?? false ? null : 'Please enter name',
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 20),

              // Location Section
              Obx(() => Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: theme.primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Use Current Location',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          Switch(
                            value: usingLocation.value,
                            onChanged: (value) => _handleLocationPermission(),
                            activeColor: theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),

                  if (usingLocation.value) ...[
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Colors.transparent,
                    ).animate(
                      onComplete: (controller) => controller.repeat(),
                    ).fadeIn(delay: 100.ms),
                    const SizedBox(height: 10),
                    Text(
                      'Fetching your location...',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              )),

              const SizedBox(height: 20),

              // Address Fields
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isNotEmpty ?? false ? null : 'Please enter address',
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 15),

              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isNotEmpty ?? false ? null : 'Please enter city',
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 15),

              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  prefixIcon: const Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isNotEmpty ?? false ? null : 'Please enter state',
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 15),

              TextFormField(
                controller: _zipController,
                decoration: InputDecoration(
                  labelText: 'ZIP Code',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) => value?.isNotEmpty ?? false ? null : 'Please enter ZIP code',
              ).animate().fadeIn(delay: 900.ms),

              const SizedBox(height: 30),

              // Submit Button
              Obx(() => isLoading.value
                  ? _buildLoadingIndicator()
                  : ElevatedButton(
                onPressed: () => _completeRegistration(args),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: theme.primaryColor,
                ),
                child: Text(
                  'Complete Registration',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().scale(
                begin: const Offset(0.9, 0.9),
                curve: Curves.easeOutBack,
              ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(width: 15),
          Text(
            'Processing... Please wait',
            style: Theme.of(Get.context!).textTheme.bodyMedium,
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Future<void> _handleLocationPermission() async {
    try {
      // Initialize permission handler
      WidgetsFlutterBinding.ensureInitialized();

      // Check if permission is granted
      var status = await Permission.location.status;
      if (!status.isGranted) {
        // Request permission if not granted
        status = await Permission.location.request();
        if (!status.isGranted) {
          debugPrint('Location permission denied');
          return;
        }
      }

      usingLocation.value = true;
      await _getCurrentLocation();
    } catch (e) {
      debugPrint('Location permission error: $e');
      usingLocation.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Get.dialog(
        AlertDialog(
          title: const Text('Getting Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Please hold tight while we fetch your location...',
                textAlign: TextAlign.center,
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final position = await _locationService.getCurrentLocation();
      final place = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      _streetController.text = place.street ?? '';
      _cityController.text = place.locality ?? '';
      _stateController.text = place.administrativeArea ?? '';
      _zipController.text = place.postalCode ?? '';

      Get.back();
    } catch (e) {
      debugPrint('Location error: $e');
      if (Get.isDialogOpen ?? false) Get.back();
    } finally {
      usingLocation.value = false;
    }
  }

  Future<void> _completeRegistration(Map<String, dynamic> args) async {
    if (_formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        Get.dialog(
          AlertDialog(
            title: const Text('Creating Account'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'We are processing your registration. Please hold tight!',
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        await _authService.completePhoneRegistration(
          otpSessionId: args['otpSessionId'],
          otp: args['otp'],
          phone: args['phone'],
          email: _emailController.text,
          name: _nameController.text,
          address: {
            "street": _streetController.text,
            "city": _cityController.text,
            "state": _stateController.text,
            "zip": _zipController.text,
          },
        );

        Get.back();
        Get.offAllNamed(Routes.PROFILE);
      } catch (e) {
        debugPrint('Registration error: $e');
        if (Get.isDialogOpen ?? false) Get.back();
      } finally {
        isLoading.value = false;
      }
    }
  }
}