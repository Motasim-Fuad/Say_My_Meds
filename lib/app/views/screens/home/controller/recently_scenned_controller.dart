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
  var globalLanguageCode = 'en'.obs;

  @override
  void onInit() {
    super.onInit();

    currentLanguage.value = Get.locale?.languageCode ?? 'en';

    ever(globalLanguageCode, (_) {
      _syncLanguageFromGlobal();
    });

    fetchRecentlyScanned();
  }

  void _syncLanguageFromGlobal() {
    final newLang = globalLanguageCode.value;

    if (currentLanguage.value != newLang) {
      currentLanguage.value = newLang;
      fetchRecentlyScanned();
      print('✅ Recently Scanned: Language synced to $newLang');
    }
  }

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

      final url = Uri.parse('$baseUrl$apiPath/medications/?lang=${currentLanguage.value}');
      print('🌐 Fetching from: $url');

      var response = await http.get(url, headers: headers);

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final recentlyScanned = RecentlyScanned.fromJson(jsonResponse);

        final results = recentlyScanned.results ?? [];
        print('📊 Results count: ${results.length}');

        // Print IDs before sorting
        for (var med in results) {
          print('   📝 Medication ID: ${med.id}, Name: ${med.genericName}');
        }

        // ✅ গুরুত্বপূর্ণ: আইডি অনুযায়ী Descending order এ সাজান (বড় থেকে ছোট)
        // মানে: 7, 6, 5 এই ক্রমে দেখাবে
        final sortedResults = results..sort((a, b) => b.id!.compareTo(a.id!));

        print('📊 After sorting by ID (descending):');
        for (var med in sortedResults) {
          print('   📝 Medication ID: ${med.id}, Name: ${med.genericName}');
        }

        if (sortedResults.isEmpty) {
          medicines.value = [];
        } else if (sortedResults.length > 3) {
          // সবচেয়ে বড় ID থেকে 3টা নিবে (সর্বশেষ 3টা)
          medicines.value = sortedResults.sublist(0, 3);
        } else {
          medicines.value = sortedResults;
        }

        medicines.refresh();
        print('✅ Recently Scanned loaded: ${medicines.length} items (latest first)');

        // Final display order
        for (var med in medicines) {
          print('   🎯 Displaying ID: ${med.id}, Name: ${med.genericName}');
        }
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

  void updateLanguage(String newLanguage) {
    currentLanguage.value = newLanguage;
    fetchRecentlyScanned();
  }

  void updateGlobalLanguage(String langCode) {
    globalLanguageCode.value = langCode;
  }
}