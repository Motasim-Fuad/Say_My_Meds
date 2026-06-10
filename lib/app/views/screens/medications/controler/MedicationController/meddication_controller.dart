// lib/app/views/screens/medications/controler/MedicationController/meddication_controller.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'dart:convert';
import 'package:saymymeds/app/views/screens/medications/controler/model/medication_api_model.dart';

class MedicationController extends GetxController {
  static const String baseUrl = ApiConstants.baseUrl + '/api/core';
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
        return;
      }

      final url = '$baseUrl/medications/?lang=${selectedLanguage.value}';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = MedicationApiModel.fromJson(data);

        if (model.results != null && model.results!.isNotEmpty) {
          for (var med in model.results!) {
            med.originalImage = _buildImageUrl(med.originalImage);
          }
          medications.value = model.results!;
        } else {
          errorMessage.value = 'No medications available';
        }
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
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

      final response = await http.delete(
        Uri.parse('$baseUrl/medications/$medId/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        medications.removeWhere((med) => med.id == medId);
        _showSnackbar('Success', 'Medication deleted');
        return true;
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
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
    if (searchQuery.value.isEmpty) return medications;
    final query = searchQuery.value.toLowerCase();
    return medications.where((med) {
      return (med.genericName?.toLowerCase().contains(query) ?? false) ||
          (med.brandName?.toLowerCase().contains(query) ?? false);
    }).toList();
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
      Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 3));
    }
  }
}