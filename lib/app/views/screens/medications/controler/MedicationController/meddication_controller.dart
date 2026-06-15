// lib/app/views/screens/medications/controler/MedicationController/meddication_controller.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'dart:convert';
import 'package:saymymeds/app/views/screens/medications/controler/model/medication_api_model.dart';

class MedicationController extends GetxController {
  String mediaBaseUrlForImages = ApiConstants.baseUrl;

  final medications = <Results>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedLanguage = 'en'.obs;
  final isPlaying = false.obs;
  final medicationId = 0.obs;
  final languageCode = 'en'.obs;
  final noteText = ''.obs;
  final errorMessage = ''.obs;
  final globalLanguageCode = 'en'.obs;

  late final FlutterTts flutterTts;
  String authToken = '';

  final Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'Portuguese': 'pt',
    'Creole': 'ht',
    'Chinese': 'zh-CN',
    'Russian': 'ru',
  };

  final Map<String, String> ttsLanguageMap = {
    'en': 'en-US',
    'es': 'es-ES',
    'fr': 'fr-FR',
    'pt': 'pt-PT',
    'ht': 'ht',
    'zh-CN': 'zh-CN',
    'ru': 'ru-RU',
  };

  @override
  void onInit() {
    super.onInit();
    flutterTts = FlutterTts();
    _setupTts();

    ever(globalLanguageCode, (_) {
      _syncLanguageFromGlobal();
    });

    fetchMedications();
  }

  void _setupTts() async {
    await _setTtsLanguage();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      isPlaying.value = false;
    });

    flutterTts.setErrorHandler((msg) {
      print('TTS Error: $msg');
      isPlaying.value = false;
    });
  }

  Future<void> _setTtsLanguage() async {
    String ttsLang = ttsLanguageMap[selectedLanguage.value] ?? 'en-US';
    await flutterTts.setLanguage(ttsLang);
  }

  void _syncLanguageFromGlobal() {
    final newLang = globalLanguageCode.value;
    if (selectedLanguage.value != newLang) {
      selectedLanguage.value = newLang;
      languageCode.value = newLang;
      _setTtsLanguage();
      fetchMedications();
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final trimmedPath = imagePath.trim();
    if (trimmedPath.startsWith('http://') || trimmedPath.startsWith('https://')) {
      return trimmedPath;
    }
    final cleanPath = trimmedPath.startsWith('/') ? trimmedPath : '/$trimmedPath';
    return '$mediaBaseUrlForImages$cleanPath';
  }

  Future<void> fetchMedications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await StorageHelper.getToken();
      if (token == null) {
        errorMessage.value = 'No authentication token found';
        print('❌ No authentication token found');
        isLoading.value = false;
        return;
      }

      // ✅ সঠিক URL - ApiConstants.medications ব্যবহার করুন
      final url = '${ApiConstants.medications}?lang=${selectedLanguage.value}';
      print('🌐 Fetching medications from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      ).timeout(const Duration(seconds: 15));

      print('📥 Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📊 Response data keys: ${data.keys}');

        final model = MedicationApiModel.fromJson(data);

        if (model.results != null && model.results!.isNotEmpty) {
          print('✅ Found ${model.results!.length} medications');

          for (var med in model.results!) {
            med.originalImage = _buildImageUrl(med.originalImage);
            print('   📝 Medication: ${med.genericName} (ID: ${med.id})');
          }
          medications.value = model.results!;
          print('✅ Medications list updated with ${medications.length} items');
        } else {
          print('⚠️ No medications found in response');
          medications.value = [];
          errorMessage.value = 'No medications available';
        }
      } else {
        print('❌ Failed to load medications: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        errorMessage.value = 'Failed to load medications: ${response.statusCode}';
      }
    } catch (e) {
      print('❌ Error fetching medications: $e');
      errorMessage.value = 'Error: $e';
      _showSnackbar('Error', 'Failed to load medications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteMedication(int medId) async {
    try {
      final token = await StorageHelper.getToken();
      if (token == null) {
        _showSnackbar('Error', 'No authentication token');
        return false;
      }

      // ✅ সঠিক URL
      final url = '${ApiConstants.medications}$medId/';
      print('🗑️ Deleting medication: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('📥 Delete response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        medications.removeWhere((med) => med.id == medId);
        print('✅ Medication deleted successfully');
        _showSnackbar('Success', 'Medication deleted');
        return true;
      } else {
        print('❌ Delete failed: ${response.statusCode}');
        _showSnackbar('Error', 'Failed to delete medication');
        return false;
      }
    } catch (e) {
      print('❌ Delete error: $e');
      _showSnackbar('Error', 'Failed to delete medication');
      return false;
    }
  }

  Future<void> toggleAudio() async {
    try {
      if (isPlaying.value) {
        await flutterTts.stop();
        isPlaying.value = false;
        return;
      }

      final medication = medications.firstWhereOrNull((m) => m.id == medicationId.value);
      if (medication == null) {
        _showSnackbar('Error', 'No medication selected');
        return;
      }

      final text = '''
        Generic Name: ${medication.genericName}. 
        Brand Name: ${medication.brandName}. 
        Manufacturer: ${medication.manufacturer}. 
        Drug Class: ${medication.drugClass}. 
        Uses: ${medication.uses}. 
        How to Take: ${medication.howToTake}.
      ''';

      isPlaying.value = true;
      await flutterTts.speak(text);

    } catch (e) {
      isPlaying.value = false;
      _showSnackbar('Error', 'Failed to speak: $e');
    }
  }

  List<Results> get filteredMedications {
    if (searchQuery.value.isEmpty) {
      print('🔍 Showing all ${medications.length} medications');
      return medications;
    }
    final query = searchQuery.value.toLowerCase();
    final filtered = medications.where((med) {
      return (med.genericName?.toLowerCase().contains(query) ?? false) ||
          (med.brandName?.toLowerCase().contains(query) ?? false);
    }).toList();
    print('🔍 Filtered ${filtered.length} medications for query: $query');
    return filtered;
  }

  Future<void> changeLanguage(String displayLang) async {
    final langCode = languageCodes[displayLang] ?? 'en';
    if (selectedLanguage.value == langCode) return;
    selectedLanguage.value = langCode;
    languageCode.value = langCode;
    await _setTtsLanguage();
    await fetchMedications();
  }

  void updateGlobalLanguage(String langCode) {
    globalLanguageCode.value = langCode;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setMedicationId(int id) {
    medicationId.value = id;
  }

  void updateNoteText(String note) {
    noteText.value = note;
  }

  void _showSnackbar(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3)
      );
    }
  }
}