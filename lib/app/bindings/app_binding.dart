import 'package:find_esy1/services/api_service.dart';
import 'package:find_esy1/services/auth_service.dart';
import 'package:find_esy1/services/location_service.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => LocationService());
  }
}