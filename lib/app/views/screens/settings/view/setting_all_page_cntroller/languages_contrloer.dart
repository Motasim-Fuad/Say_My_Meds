import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:saymymeds/app/views/screens/home/controller/home_page_&_edit_profilecontroller.dart';
import 'package:saymymeds/app/views/screens/medications/controler/MedicationController/meddication_controller.dart';
import 'package:saymymeds/app/views/screens/home/controller/recently_scenned_controller.dart';
import 'package:saymymeds/app/views/screens/medications/controler/check_info_controller/cheak_info_controller.dart';

class LanguageController extends GetxController {
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

  // Display name to full name mapping (for settings page)
  final Map<String, String> displayNameMap = {
    'English': 'English',
    'Spanish': 'Spanish (Español)',
    'French': 'French (Français)',
    'Portugese': 'Portugese',
    'Creole': 'Creole',
    'Russian': 'Russian',
    'Chinese': 'Chinese',
  };

  @override
  void onInit() {
    super.onInit();
    _initializeLanguage();
  }

  // Initialize language from backend or current locale
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

      // Fallback to current locale
      selectedDisplayLanguage.value = _localeToDisplay(Get.locale) ?? 'English';
    } catch (e) {
      print('Error initializing language: $e');
      selectedDisplayLanguage.value = 'English';
    }
  }

  // Convert language code to display name
  String _getDisplayName(String langCode) {
    for (final entry in languageMap.entries) {
      if (entry.value == langCode) {
        return entry.key;
      }
    }
    return 'English';
  }

  // Convert Locale to display name
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

  // Main function to change language
  Future<void> changeLanguage(String displayLanguageName) async {
    try {
      isLoading.value = true;
      final langCode = languageMap[displayLanguageName] ?? 'en';
      final locale = localeMap[langCode] ?? const Locale('en', 'US');

      print("📝 Changing language to: $displayLanguageName ($langCode)");

      // Update Get locale
      Get.updateLocale(locale);

      // Update selected language
      selectedDisplayLanguage.value = displayLanguageName;

      // Save to backend
      if (Get.isRegistered<HomePageEditProfilecontroller>()) {
        final profileController = Get.find<HomePageEditProfilecontroller>();
        final success = await profileController.updateProfile(
          newName: profileController.name.value,
          languageCode: langCode,
        );

        if (success) {
          print("✅ Language saved to backend: $langCode");
          Get.snackbar(
            'Success',
            'Language changed to $displayLanguageName',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      }

      // Sync to all controllers
      _syncLanguageToAllControllers(langCode);
    } catch (e) {
      print('❌ Error changing language: $e');
      Get.snackbar(
        'Error',
        'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sync language to all controllers
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

      print("✅ All controllers synced with language: $langCode");
    } catch (e) {
      print('⚠️ Error syncing controllers: $e');
    }
  }
}
