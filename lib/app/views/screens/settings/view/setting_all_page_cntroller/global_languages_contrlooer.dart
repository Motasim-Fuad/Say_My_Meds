import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:saymymeds/app/views/screens/home/controller/home_page_&_edit_profilecontroller.dart';
import 'package:saymymeds/app/views/screens/medications/controler/MedicationController/meddication_controller.dart';
import 'package:saymymeds/app/views/screens/home/controller/recently_scenned_controller.dart';
import 'package:saymymeds/app/views/screens/medications/controler/check_info_controller/cheak_info_controller.dart';
import 'package:saymymeds/app/views/screens/view_details/view_controlr/view_detiails_controller.dart';

class GlobalLanguageController extends GetxController {
  var selectedDisplayLanguage = 'English'.obs;
  var isLoading = false.obs;

  // Language mapping
  final Map<String, String> languageMap = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'Portugese': 'pt',
    'Creole': 'ht',
    'Russian': 'ru',
    'Chinese': 'zh-CN',
  };

  // Locale mapping
  final Map<String, Locale> localeMap = {
    'en': const Locale('en', 'US'),
    'es': const Locale('es', 'ES'),
    'fr': const Locale('fr', 'FR'),
    'pt': const Locale('pt', 'BR'),
    'ht': const Locale('ht', 'HT'),
    'ru': const Locale('ru', 'RU'),
    'zh-CN': const Locale.fromSubtags(
      languageCode: 'zh',
      scriptCode: 'Hans',
      countryCode: 'CN',
    ),
  };

  @override
  void onInit() {
    super.onInit();
    _initializeLanguage();
  }

  void _initializeLanguage() {
    try {
      if (Get.isRegistered<HomePageEditProfilecontroller>()) {
        final profileController = Get.find<HomePageEditProfilecontroller>();
        if (profileController.preferredLanguage.value.isNotEmpty) {
          final savedLangCode = profileController.preferredLanguage.value;
          selectedDisplayLanguage.value = _getDisplayName(savedLangCode);
          final locale = localeMap[savedLangCode] ?? const Locale('en', 'US');
          if (Get.locale != locale) {
            Get.updateLocale(locale);
          }
          return;
        }
      }

      selectedDisplayLanguage.value = _localeToDisplay(Get.locale) ?? 'English';
    } catch (e) {
      print('Error initializing language: $e');
      selectedDisplayLanguage.value = 'English';
    }
  }

  String _getDisplayName(String langCode) {
    for (final entry in languageMap.entries) {
      if (entry.value == langCode) {
        return entry.key;
      }
    }
    return 'English';
  }

  String? _localeToDisplay(Locale? locale) {
    if (locale == null) return null;
    if (locale.languageCode == 'zh') return 'Chinese';

    for (final entry in languageMap.entries) {
      if (entry.value == locale.languageCode) {
        return entry.key;
      }
    }
    return null;
  }

  Future<void> changeLanguage(String displayLanguageName) async {
    try {
      isLoading.value = true;
      final langCode = languageMap[displayLanguageName] ?? 'en';
      final locale = localeMap[langCode] ?? const Locale('en', 'US');

      print("📝 Changing language to: $displayLanguageName ($langCode)");
      print("🌍 Locale will be: ${locale.toString()}");

      Get.updateLocale(locale);
      selectedDisplayLanguage.value = displayLanguageName;

      Future.delayed(Duration.zero, () {
        print("🔄 Current locale after update: ${Get.locale.toString()}");
        print("🔍 Test translation 'hello': ${'hello'.tr}");
        print("🔍 Test translation 'scan_medication': ${'scan_medication'.tr}");
      });

      if (Get.isRegistered<HomePageEditProfilecontroller>()) {
        final profileController = Get.find<HomePageEditProfilecontroller>();
        final success = await profileController.updateProfile(
          newName: profileController.name.value,
          languageCode: langCode,
        );

        if (success) {
          print("✅ Language saved to backend: $langCode");

          // ✅ FIX: Snackbar দেখানোর আগে context চেক করুন
          _showSnackbar(
            'Success',
            'Language changed to $displayLanguageName',
            isError: false,
          );
        }
      }

      _syncLanguageToAllControllers(langCode);
    } catch (e) {
      print('❌ Error changing language: $e');
      _showSnackbar(
        'Error',
        'Failed to change language',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ নতুন মেথড: সেফভাবে Snackbar দেখানোর জন্য
  void _showSnackbar(String title, String message, {bool isError = false}) {
    // Get.context চেক করুন
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ? Colors.red : Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    } else {
      // যদি context না থাকে, print করুন
      print("⚠️ Cannot show snackbar: No context available");
      print("   Message: $title - $message");
    }
  }

  void _syncLanguageToAllControllers(String langCode) {
    try {
      if (Get.isRegistered<MedicationController>()) {
        final medController = Get.find<MedicationController>();
        medController.updateGlobalLanguage(langCode);
      }

      if (Get.isRegistered<RecentlyScannedController>()) {
        final recentController = Get.find<RecentlyScannedController>();
        recentController.updateGlobalLanguage(langCode);
      }

      if (Get.isRegistered<CheckInfoController>()) {
        final checkInfoController = Get.find<CheckInfoController>();
        checkInfoController.updateGlobalLanguage(langCode);
      }

      // ✅ Sync with ViewDetailsController
      if (Get.isRegistered<ViewDetailsController>()) {
        final viewDetailsController = Get.find<ViewDetailsController>();
        viewDetailsController.updateGlobalLanguage(langCode);
      }

      print("✅ All controllers synced with language: $langCode");
    } catch (e) {
      print('⚠️ Error syncing controllers: $e');
    }
  }
}