import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  late final AudioPlayer audioPlayer;
  String authToken = '';

  final Map<String, String> languageCodes = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'Portugese': 'pt',
    'Portuguese': 'pt',
    'Creole': 'ht',
    'Chinese': 'zh-CN',
    'Russian': 'ru',
  };

  @override
  void onInit() {
    super.onInit();
    audioPlayer = AudioPlayer();
    _setupAudioListeners();

    ever(globalLanguageCode, (_) {
      _syncLanguageFromGlobal();
    });

    fetchMedications();
  }

  void _setupAudioListeners() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
    });
  }

  void _syncLanguageFromGlobal() {
    final newLang = globalLanguageCode.value;

    if (selectedLanguage.value != newLang) {
      selectedLanguage.value = newLang;
      languageCode.value = newLang;
      fetchMedications();
      print('Medication: Language synced to $newLang');
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void setAuthToken(String token) {
    authToken = token;
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      print('DEBUG: Image path is null or empty');
      return '';
    }

    final trimmedPath = imagePath.trim();
    print('DEBUG: Original image path: $trimmedPath');

    // Check if it's already a complete URL
    if (trimmedPath.startsWith('http://') ||
        trimmedPath.startsWith('https://')) {
      print('DEBUG: Already complete URL: $trimmedPath');
      return trimmedPath;
    }

    // Build the complete URL
    final cleanPath = trimmedPath.startsWith('/')
        ? trimmedPath
        : '/$trimmedPath';

    final completeUrl = '$mediaBaseUrlForImages$cleanPath';
    print('DEBUG: Built complete URL: $completeUrl');
    return completeUrl;
  }

  Future<void> fetchMedications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await StorageHelper.getToken();
      if (token == null) {
        errorMessage.value = 'No authentication token found';
        print('DEBUG: No auth token found');
        return;
      }

      final url = '$baseUrl/medications/?lang=${selectedLanguage.value}';
      print('DEBUG: Fetching medications from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      print('DEBUG: Response status code: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG: Decoded JSON data: $data');

        final model = MedicationApiModel.fromJson(data);

        if (model.results != null && model.results!.isNotEmpty) {
          print('DEBUG: Found ${model.results!.length} medications');

          for (var med in model.results!) {
            print('DEBUG: Processing medication: ${med.genericName}');
            print('DEBUG: Original image path: ${med.originalImage}');

            med.originalImage = _buildImageUrl(med.originalImage);

            print('DEBUG: Final image URL: ${med.originalImage}');
          }
          medications.value = model.results!;
          print('DEBUG: Medications updated successfully');
        } else {
          errorMessage.value = 'No medications available';
          print('DEBUG: No medications in response');
        }
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('DEBUG: Error fetching medications: $e');
      Get.snackbar('Error', 'Failed to load medications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteMedication(int medId) async {
    try {
      final token = await StorageHelper.getToken();
      if (token == null) {
        Get.snackbar('Error', 'No authentication token');
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/medications/$medId/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        medications.removeWhere((med) => med.id == medId);
        Get.snackbar('Success', 'Medication deleted');
        return true;
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete medication');
      print('DEBUG: Error deleting medication: $e');
      return false;
    }
  }

  String _buildAudioUrl() {
    return '$baseUrl/audio/medication/${medicationId.value}/?lang=${languageCode.value}';
  }

  Future<void> toggleAudio() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.pause();
      } else {
        final audioUrl = _buildAudioUrl();
        print('DEBUG: Playing audio from: $audioUrl');
        await audioPlayer.play(UrlSource(audioUrl));
      }
    } catch (e) {
      Get.snackbar('Error', 'Audio playback failed: $e');
      print('DEBUG: Audio playback error: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await audioPlayer.stop();
      isPlaying.value = false;
    } catch (e) {
      print('Error stopping audio: $e');
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
}
