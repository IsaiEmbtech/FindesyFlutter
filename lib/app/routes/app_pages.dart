import 'package:find_esy1/app/ui/pages/login_page.dart';
import 'package:find_esy1/app/ui/pages/otp_page.dart';
import 'package:find_esy1/app/ui/pages/phone_register_page.dart';
import 'package:find_esy1/app/ui/pages/profile_page.dart';
import 'package:find_esy1/app/ui/pages/register_page.dart';
import 'package:get/get.dart';
import 'package:find_esy1/app/ui/pages/Registration_Mobile/mob_send_otp_page.dart';
import 'package:find_esy1/app/ui/pages/Registration_Mobile/mob_verify_otp_page.dart';
import 'package:find_esy1/app/ui/pages/Registration_Mobile/mob_create_acc_page.dart';
abstract class AppPages {
  static const INITIAL = Routes.REGISTER;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: () => LoginPage()),
    GetPage(name: Routes.PHONE_REGISTER, page: () => PhoneLoginPage()),
    GetPage(name: Routes.OTP, page: () => OtpPage()),
    GetPage(name: Routes.REGISTER, page: () => RegisterPage()),
    GetPage(name: Routes.PROFILE, page: () => ProfileEditPage()),
    GetPage(name: Routes.MOB_SEND_OTP, page: () => MobSendOtpPage()),
    GetPage(name: Routes.MOB_VERIFY_OTP, page: () => MobVerifyOtpPage()),
    GetPage(name: Routes.MOB_CREATE_ACC, page: () => MobCreateAccPage()),
  ];
}

abstract class Routes {
  static const LOGIN = '/login';
  static const PHONE_REGISTER = '/phone-register';
  static const OTP = '/otp';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const MOB_SEND_OTP = '/mob-send-otp';
  static const MOB_VERIFY_OTP = '/mob-verify-otp';
  static const MOB_CREATE_ACC = '/mob-create-acc';
  
}