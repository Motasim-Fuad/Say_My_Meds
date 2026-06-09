import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saymymeds/app/views/screens/auth/enter_code.dart';
import 'package:saymymeds/app/views/screens/auth/forget_password.dart';
import 'package:saymymeds/app/views/screens/auth/new_password.dart';
import 'package:saymymeds/app/views/screens/auth/sigin_in.dart';
import 'package:saymymeds/app/views/screens/auth/sign_up.dart';
import 'package:saymymeds/app/views/screens/auth/verifiy_code.dart';
import 'package:saymymeds/app/views/screens/home/home_view_page.dart';

import 'package:saymymeds/app/views/screens/home/views/screens/SubscriptionCard/subscription_card.dart';
import 'package:saymymeds/app/views/screens/medications/view/cheack_info.dart';
import 'package:saymymeds/app/views/screens/medications/view/medication.dart';
import 'package:saymymeds/app/views/screens/scan/image_scanner_screen.dart';
import 'package:saymymeds/app/views/screens/settings/view/edit_profile.dart';
import 'package:saymymeds/app/views/screens/settings/view/language_selection.dart';
import 'package:saymymeds/app/views/screens/settings/view/setting_page.dart';
import 'package:saymymeds/app/views/screens/splash/splash_screen.dart';
import 'package:saymymeds/app/views/screens/view_details/medication_preview_model/medication_preview.dart';
import 'package:saymymeds/app/views/screens/view_details/view_detils.dart';
import 'package:saymymeds/app/views/screens/welcome/weal_come_screen.dart';

class AppRoutes {
  static const String splashScreen = "/";
  static const String welcomeScreen = "/welcome";
  // auth
  static const String siginIn = "/signin";
  static const String forgetPasswordScreen = "/forgetPasswordScreen";
  static const String enterCode = "/enterCode";
  static const String newPassword = "/newPassword";
  static const String signUp = "/signUp";
  static const String bottomNav = "/bottomNav";
  static const String verifyCode = '/verifyCode';
  // home page
  static const String homeViewPage = "/homeViewPage";
  static const String medicineDetailPage = "/medicineDetailPage";
  static const String subscriptionCard = "/subscriptionCard";
  static const String settingPage = "/settingPage";
  static const String editProfile = "/editProfile";
  static const String languageSelection = "/languageSelection";
  static const String checkInfoPage = "/checkInfoPage";
  static const String medication = "/medication";
  static const String imageScannerScreen = '/imageScannerScreen';

  static final GoRouter router = GoRouter(
    initialLocation: splashScreen,
    routes: [
      GoRoute(
        path: splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: welcomeScreen,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: siginIn, builder: (context, state) => const SiginInViews()),
      GoRoute(
        path: forgetPasswordScreen,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: enterCode,
        builder: (context, state) {
          String? email;
          if (state.extra != null) {
            if (state.extra is String) {
              email = state.extra as String;
            } else if (state.extra is Map<String, dynamic>) {
              email = (state.extra as Map<String, dynamic>)['email'];
            }
          }
          return const EnterCode();
        },
      ),
      GoRoute(
        path: newPassword,
        builder: (context, state) {
          final token =
              state.extra as String? ??
              state.uri.queryParameters['token'] ??
              '';
          print('🚀 GoRouter passed token to NewPassword: $token');
          return NewPassword(resetToken: token);
        },
      ),
      GoRoute(path: signUp, builder: (context, state) => const SignUp()),

      GoRoute(
        path: homeViewPage,
        //
        builder: (context, state) => HomeViewPage(),
      ),
      GoRoute(
        path: verifyCode,
        builder: (context, state) {
          String email = '';
          if (state.extra != null) {
            if (state.extra is String) {
              email = state.extra as String;
            } else if (state.extra is Map) {
              final map = state.extra as Map;
              email = map['email']?.toString() ?? '';
            }
          }
          print("Email received in route: $email");
          return VerifyCode(email: email);
        },
      ),

      GoRoute(
        path: medication,
        // name: 'medication',
        builder: (context, state) => const Medication(),
      ),
      // ekane bat pari korchi kintu
      GoRoute(
        path: checkInfoPage,
        // name: 'checkInfoPage',
        builder: (context, state) {
          final medicationId = state.extra as int;
          return CheckInfoPage(medicationId: medicationId);
        },
      ),
      GoRoute(
        path: '/checkInfoPage/:id', // Using path parameter
        builder: (context, state) {
          final medicationId =
              state.pathParameters['id']; // Correctly accessing path parameter
          if (medicationId == null) {
            return const Center(child: Text('Invalid medication ID'));
          }
          return CheckInfoPage(
            medicationId: int.tryParse(medicationId) ?? 0,
          ); // Safely parse to int
        },
      ),
      // end ekane
      GoRoute(
        path: medicineDetailPage,
        builder: (context, state) {
          final preview = state.extra as MedicationPreviewModel?;
          return MedicineDetailPage(preview: preview);
        },
      ),
      GoRoute(
        path: subscriptionCard,
        builder: (context, state) => const SubscriptionCard(),
      ),
      GoRoute(
        path: settingPage, //
        builder: (context, state) => SettingPage(),
      ),
      GoRoute(
        path: editProfile, //
        builder: (context, state) => EditProfile(),
      ),
      GoRoute(
        path: languageSelection,
        builder: (context, state) => LanguageSelection(),
      ),
      GoRoute(
        path: imageScannerScreen,
        builder: (context, state) => ImageScannerScreen(),
      ),
    ],
  );
}
