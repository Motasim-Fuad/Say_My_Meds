// // }

// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:saymymeds/app/core/consants/api_constants.dart';
// import 'package:saymymeds/app/utlies/storage_helper.dart';
// import 'package:saymymeds/app/views/screens/home/model/recently_scanned_model.dart';
// import 'dart:convert';

// class RecentlyScannedController extends GetxController {
//   static const String baseUrl = ApiConstants.baseUrl;
//   static const String apiPath = '/api/core';

//   var medicines = <Medication>[].obs;
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//   var currentLanguage = 'en'.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // ✅ Get current language from GetX
//     currentLanguage.value = Get.locale?.languageCode ?? 'en';

//     // ✅ Listen to global language changes
//     ever(currentLanguage, (_) {
//       fetchRecentlyScanned();
//     });

//     fetchRecentlyScanned();
//   }

//   Future<void> fetchRecentlyScanned() async {
//     try {
//       isLoading(true);
//       errorMessage('');

//       final token = await StorageHelper.getToken();
//       if (token == null) {
//         errorMessage('No authentication token found');
//         isLoading(false);
//         return;
//       }

//       // ✅ Send language header to API
//       var headers = {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//         'Accept-Language': currentLanguage.value,
//       };

//       final url = Uri.parse('$baseUrl$apiPath/medications');
//       var response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         final recentlyScanned = RecentlyScanned.fromJson(jsonResponse);

//         final results = recentlyScanned.results ?? [];

//         if (results.isEmpty) {
//           medicines.value = [];
//         } else if (results.length > 3) {
//           medicines.value = results.sublist(results.length - 3);
//         } else {
//           medicines.value = results;
//         }

//         medicines.refresh();
//       } else {
//         errorMessage('Failed to load medications: ${response.statusCode}');
//       }
//     } catch (e) {
//       errorMessage('Error: $e');
//       print('❌ Error fetching medications: $e');
//     } finally {
//       isLoading(false);
//     }
//   }

//   // ✅ Call this when user changes language in settings
//   void updateLanguage(String newLanguage) {
//     currentLanguage.value = newLanguage;
//   }
// }

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:saymymeds/app/views/screens/home/model/recently_scanned_model.dart';
import 'dart:convert';

class RecentlyScannedController extends GetxController {
  static const String baseUrl = ApiConstants.baseUrl;
  static const String apiPath = '/api/core';

  var medicines = <Medication>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var currentLanguage = 'en'.obs;
  var globalLanguageCode = 'en'.obs; // ✅ Track global language

  @override
  void onInit() {
    super.onInit();

    // ✅ Get current language from GetX
    currentLanguage.value = Get.locale?.languageCode ?? 'en';

    // ✅ Watch global language changes
    ever(globalLanguageCode, (_) {
      _syncLanguageFromGlobal();
    });

    fetchRecentlyScanned();
  }

  // ✅ Sync language when global language changes
  void _syncLanguageFromGlobal() {
    final newLang = globalLanguageCode.value;

    if (currentLanguage.value != newLang) {
      currentLanguage.value = newLang;
      fetchRecentlyScanned();
      print('✅ Recently Scanned: Language synced to $newLang');
    }
  }
  //
  // Future<void> fetchRecentlyScanned() async {
  //   try {
  //     isLoading(true);
  //     errorMessage('');
  //
  //     final token = await StorageHelper.getToken();
  //     if (token == null) {
  //       errorMessage('No authentication token found');
  //       isLoading(false);
  //       return;
  //     }
  //
  //     // ✅ Send language parameter to API
  //     var headers = {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     };
  //
  //     final url = Uri.parse(
  //       '$baseUrl$apiPath/medications/?lang=${currentLanguage.value}',
  //     );
  //     var response = await http.get(url, headers: headers);
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       final recentlyScanned = RecentlyScanned.fromJson(jsonResponse);
  //
  //       final results = recentlyScanned.results ?? [];
  //
  //       if (results.isEmpty) {
  //         medicines.value = [];
  //       } else if (results.length > 3) {
  //         medicines.value = results.sublist(results.length - 3);
  //       } else {
  //         medicines.value = results;
  //       }
  //
  //       medicines.refresh();
  //       print(
  //         '✅ Recently Scanned loaded: ${medicines.length} (Lang: ${currentLanguage.value})',
  //       );
  //     } else {
  //       errorMessage('Failed to load medications: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     errorMessage('Error: $e');
  //     print('❌ Error fetching medications: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }


  // recently_scenned_controller.dart

  Future<void> fetchRecentlyScanned() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await StorageHelper.getToken();
      if (token == null) {
        errorMessage('No authentication token found');
        isLoading(false);
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // ✅ URL টা চেক কর - স্ল্যাশ ঠিক কর
      final url = Uri.parse('$baseUrl$apiPath/medications/?lang=${currentLanguage.value}');
      print('🌐 Fetching from: $url'); // ডিবাগ জন্য

      var response = await http.get(url, headers: headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final recentlyScanned = RecentlyScanned.fromJson(jsonResponse);

        final results = recentlyScanned.results ?? [];
        print('📊 Results count: ${results.length}'); // ডিবাগ

        if (results.isEmpty) {
          medicines.value = [];
        } else if (results.length > 3) {
          medicines.value = results.sublist(results.length - 3);
        } else {
          medicines.value = results;
        }

        medicines.refresh();
        print('✅ Recently Scanned loaded: ${medicines.length}');
      } else {
        errorMessage('Failed to load medications: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error: $e');
      print('❌ Error fetching medications: $e');
    } finally {
      isLoading(false);
    }
  }
  // ✅ Call this when user changes language in settings
  void updateLanguage(String newLanguage) {
    currentLanguage.value = newLanguage;
    fetchRecentlyScanned();
  }

  // ✅ Sync global language
  void updateGlobalLanguage(String langCode) {
    globalLanguageCode.value = langCode;
  }
}
