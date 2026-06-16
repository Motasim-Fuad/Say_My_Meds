// lib/app/views/screens/home/controller/recently_scenned_controller.dart

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

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';

    String path = imagePath.trim();
    if (path.startsWith('http')) return path;

    String cleanBaseUrl = ApiConstants.baseUrl;
    if (cleanBaseUrl.endsWith('/')) {
      cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return '$cleanBaseUrl/$path';
  }

// recently_scenned_controller.dart - fetchRecentlyScanned() মেথড আপডেট করুন
// recently_scenned_controller.dart - আপডেট করা fetchRecentlyScanned()

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

      final url = Uri.parse('$baseUrl$apiPath/medications/?lang=${currentLanguage.value}');
      print('🌐 Fetching from: $url');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final results = jsonResponse['results'] as List? ?? [];

        print('📊 Results count: ${results.length}');

        List<Medication> medications = [];
        for (var item in results) {
          // Medication.fromJson ব্যবহার করুন - এটি সব ফিল্ড পার্স করবে
          try {
            // 🔑 মূল JSON-এ ভাষা নির্দিষ্ট ফিল্ড যোগ করুন
            // কারণ Medication.fromJson সব ভাষার ফিল্ড খুঁজে বের করে
            Medication med = Medication.fromJson(item);

            // ইমেজ URL তৈরি করুন
            if (med.originalImage.isNotEmpty && !med.originalImage.startsWith('http')) {
              med.originalImage = _buildImageUrl(med.originalImage);
            }

            medications.add(med);
            print('   📝 ID: ${med.id}, Name: ${med.genericName}');
          } catch (e) {
            print('❌ Error parsing medication: $e');
          }
        }

        // ID অনুযায়ী সাজান (সর্বশেষ প্রথমে)
        medications.sort((a, b) => b.id.compareTo(a.id));

        // শুধু প্রথম ৩টা দেখান
        medicines.value = medications.length > 3 ? medications.sublist(0, 3) : medications;
        medicines.refresh();

        print('✅ Recently Scanned loaded: ${medicines.length} items');
        for (var med in medicines) {
          print('   🎯 ID: ${med.id}, Name: ${med.genericName}');
        }

      } else {
        errorMessage('Failed: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Error: $e');
      print('❌ Error: $e');
    } finally {
      isLoading(false);
    }
  }


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
  //     final url = Uri.parse('$baseUrl$apiPath/medications/?lang=${currentLanguage.value}');
  //     print('🌐 Fetching from: $url');
  //
  //     var response = await http.get(
  //       url,
  //       headers: {'Authorization': 'Bearer $token'},
  //     );
  //
  //     print('📥 Response status: ${response.statusCode}');
  //     print('📥 Full Response Body: ${response.body}'); // 👈 সম্পূর্ণ রেসপন্স প্রিন্ট করুন
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //
  //       // 👈 রেসপন্সের পুরো স্ট্রাকচার প্রিন্ট করুন
  //       print('📊 Full JSON Structure:');
  //       print(jsonResponse);
  //
  //       // 👈 রেসপন্সের key গুলো দেখুন
  //       print('📊 Response keys: ${jsonResponse.keys}');
  //
  //       final recentlyScanned = RecentlyScanned.fromJson(jsonResponse);
  //       final results = recentlyScanned.results ?? [];
  //
  //       // 👈 প্রতিটি মেডিকেশনের ডাটা প্রিন্ট করুন
  //       for (var med in results) {
  //         print('📝 Medication Data:');
  //         print('   ID: ${med.id}');
  //         print('   genericName: ${med.genericName}');
  //         print('   brandName: ${med.brandName}');
  //         print('   All fields: ${med.toJson()}'); // যদি toJson মেথড থাকে
  //       }
  //
  //       print('📊 Results count: ${results.length}');
  //
  //       if (results.isNotEmpty) {
  //         for (var med in results) {
  //           med.originalImage = _buildImageUrl(med.originalImage);
  //         }
  //
  //         results.sort((a, b) => b.id.compareTo(a.id));
  //
  //         medicines.value = results.length > 3 ? results.sublist(0, 3) : results;
  //         medicines.refresh();
  //
  //         print('✅ Recently Scanned loaded: ${medicines.length} items');
  //         for (var med in medicines) {
  //           print('   🎯 ID: ${med.id}, Name: ${med.genericName}');
  //         }
  //       } else {
  //         medicines.value = [];
  //         print('⚠️ No medications found');
  //       }
  //     } else {
  //       errorMessage('Failed: ${response.statusCode}');
  //       print('❌ API Error Response: ${response.body}');
  //     }
  //   } catch (e) {
  //     errorMessage('Error: $e');
  //     print('❌ Error: $e');
  //     print('❌ Stack trace: ${StackTrace.current}');
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  void updateLanguage(String newLanguage) {
    currentLanguage.value = newLanguage;
    fetchRecentlyScanned();
  }

  void updateGlobalLanguage(String langCode) {
    globalLanguageCode.value = langCode;
  }
}