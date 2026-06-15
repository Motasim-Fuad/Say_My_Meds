// lib/app/views/screens/view_details/view_controlr/view_detiails_controller.dart

import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:saymymeds/app/views/screens/view_details/medication_preview_model/medication_model.dart';
import 'package:saymymeds/app/views/screens/settings/view/setting_all_page_cntroller/global_languages_contrlooer.dart';

class ViewDetailsController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = RxBool(false);
  final RxBool isSaving = RxBool(false); // ✅ নতুন: শুধু save এর জন্য loading
  final RxBool isPlaying = RxBool(false);
  final RxString selectedLanguage = RxString('en');
  final RxString notes = RxString('');
  final Rx<MedicationPreviewModel?> medicationData = Rx<MedicationPreviewModel?>(null);
  final RxInt refreshUI = RxInt(0);
  final RxString loadingMessage = RxString(''); // ✅ নতুন: loading message দেখানোর জন্য

  late final FlutterTts _flutterTts;
  bool _ttsInitialized = false;

  final ImagePicker _picker = ImagePicker();

  GlobalLanguageController? _globalLanguageController;

  final Map<String, String> languageMap = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'Portugese': 'pt',
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
    _initTts();

    try {
      _globalLanguageController = Get.find<GlobalLanguageController>();
      final currentLangCode = _globalLanguageController!.languageMap[_globalLanguageController!.selectedDisplayLanguage.value] ?? 'en';
      selectedLanguage.value = currentLangCode;
      print('✅ Synced with GlobalLanguageController: $currentLangCode');
    } catch (e) {
      print('⚠️ GlobalLanguageController not found');
    }
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();
      await Future.delayed(const Duration(milliseconds: 500));
      await _setTtsLanguage();
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setCompletionHandler(() {
        print('🎤 TTS Completed');
        isPlaying.value = false;
      });

      _flutterTts.setErrorHandler((msg) {
        print('🎤 TTS Error: $msg');
        isPlaying.value = false;
      });

      _flutterTts.setStartHandler(() {
        print('🎤 TTS Started');
      });

      _ttsInitialized = true;
      print('✅ TTS Initialized successfully');
    } catch (e) {
      print('❌ TTS Init failed: $e');
      _ttsInitialized = false;
    }
  }

  Future<void> _setTtsLanguage() async {
    try {
      String ttsLang = ttsLanguageMap[selectedLanguage.value] ?? 'en-US';
      await _flutterTts.setLanguage(ttsLang);
      print('🎤 TTS Language set to: $ttsLang');
    } catch (e) {
      print('🎤 Error setting TTS language: $e');
    }
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }

  Future<String?> _getToken() async => await StorageHelper.getToken();

  String _toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }

  // ==================== IMAGE PICKING METHODS ====================

  Future<void> pickImageFromCamera(BuildContext context) async {
    print('📸 Picking image from camera...');
    try {
      loadingMessage.value = 'Opening camera...'.tr;
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('✅ Image captured: ${pickedFile.path}');
        await uploadImage(context);
      } else {
        print('⚠️ No image captured');
        loadingMessage.value = '';
      }
    } catch (e) {
      print('❌ Failed to capture image: $e');
      loadingMessage.value = '';
      _showError('Failed to capture image: $e', context);
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    print('🖼️ Picking image from gallery...');
    try {
      loadingMessage.value = 'Opening gallery...'.tr;
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        print('✅ Image picked: ${pickedFile.path}');
        await uploadImage(context);
      } else {
        print('⚠️ No image selected');
        loadingMessage.value = '';
      }
    } catch (e) {
      print('❌ Failed to pick image: $e');
      loadingMessage.value = '';
      _showError('Failed to pick image: $e', context);
    }
  }

  // ==================== UPLOAD IMAGE FOR AI ANALYSIS ====================

  Future<void> uploadImage(BuildContext context) async {
    if (selectedImage.value == null) {
      print('⚠️ No image selected');
      return;
    }

    try {
      isLoading.value = true;
      loadingMessage.value = 'Analyzing image...'.tr;
      print('🚀 Starting image upload for AI analysis...');

      final token = await _getToken();
      if (token == null) {
        print('❌ No authentication token found');
        loadingMessage.value = '';
        _showError('Authentication token not found', context);
        return;
      }

      final cleanedToken = token.trim().replaceAll('"', '');
      final apiLang = selectedLanguage.value;

      final uri = Uri.parse('${ApiConstants.aiAnalysis}?lang=$apiLang');
      print('🌐 API URL: $uri');

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
      request.files.add(
        await http.MultipartFile.fromPath('image', selectedImage.value!.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('✅ AI Analysis successful!');

        loadingMessage.value = 'Processing medication data...'.tr;
        await Future.delayed(const Duration(milliseconds: 500)); // Small delay for UX

        if (jsonData is Map<String, dynamic>) {
          final sanitizedData = _sanitizeApiResponse(jsonData);
          medicationData.value = MedicationPreviewModel.fromJson(sanitizedData);
          refreshUI.value++;

          print('💊 Medication detected: ${medicationData.value?.aiAnalysis.brandName}');
          loadingMessage.value = '';

          if (context.mounted) {
            context.push(AppRoutes.medicineDetailPage, extra: medicationData.value);
          }
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('❌ Unauthorized - Status: ${response.statusCode}');
        loadingMessage.value = '';
        _showError('Unauthorized — please log in again', context);
      } else {
        print('❌ Upload failed with status: ${response.statusCode}');
        loadingMessage.value = '';
        _showError('Failed to upload image (${response.statusCode})', context);
      }
    } catch (e) {
      print('❌ Upload error: $e');
      loadingMessage.value = '';
      _showError('Failed to upload image: $e', context);
    } finally {
      isLoading.value = false;
      print('🏁 Upload process completed');
    }
  }

  Map<String, dynamic> _sanitizeApiResponse(Map<String, dynamic> data) {
    print('🔧 Sanitizing API response...');
    final sanitized = Map<String, dynamic>.from(data);

    if (sanitized['ai_analysis'] is Map<String, dynamic>) {
      final analysis = Map<String, dynamic>.from(sanitized['ai_analysis']);

      analysis['tot_pills'] = _toStringValue(analysis['tot_pills']);
      analysis['generic_name'] = _toStringValue(analysis['generic_name']);
      analysis['brand_name'] = _toStringValue(analysis['brand_name']);
      analysis['manufacturer'] = _toStringValue(analysis['manufacturer']);
      analysis['drug_class'] = _toStringValue(analysis['drug_class']);
      analysis['uses'] = _toStringValue(analysis['uses']);
      analysis['how_to_take'] = _toStringValue(analysis['how_to_take']);
      analysis['warnings'] = _toStringValue(analysis['warnings']);
      analysis['storage_instructions'] = _toStringValue(analysis['storage_instructions']);
      analysis['interactions'] = _toStringValue(analysis['interactions']);

      if (analysis['dosage_information'] is Map<String, dynamic>) {
        final dosage = Map<String, dynamic>.from(analysis['dosage_information']);
        dosage['adults_dosage'] = _toStringValue(dosage['adults_dosage']);
        dosage['children_dosage'] = _toStringValue(dosage['children_dosage']);
        dosage['elderly_dosage'] = _toStringValue(dosage['elderly_dosage']);
        analysis['dosage_information'] = dosage;
      }

      if (analysis['side_effects'] is Map<String, dynamic>) {
        final sideEffects = Map<String, dynamic>.from(analysis['side_effects']);
        sideEffects['common'] = _toStringValue(sideEffects['common']);
        sideEffects['serious'] = _toStringValue(sideEffects['serious']);
        analysis['side_effects'] = sideEffects;
      }

      sanitized['ai_analysis'] = analysis;
    }

    print('✅ Response sanitized successfully');
    return sanitized;
  }

  // ==================== LANGUAGE CHANGE ====================

  Future<void> changeLanguage(String displayName, BuildContext context) async {
    print('🌍 Changing language to: $displayName');

    try {
      isLoading.value = true;
      loadingMessage.value = 'Changing language...'.tr;

      if (_globalLanguageController != null) {
        await _globalLanguageController!.changeLanguage(displayName);
        final langCode = _globalLanguageController!.languageMap[displayName] ?? 'en';
        selectedLanguage.value = langCode;
      } else {
        final langCode = languageMap[displayName] ?? 'en';
        final locale = localeMap[langCode] ?? const Locale('en', 'US');
        await Get.updateLocale(locale);
        selectedLanguage.value = langCode;
      }

      print('✅ Language changed to: ${selectedLanguage.value}');
      await _setTtsLanguage();

      if (isPlaying.value) {
        await _flutterTts.stop();
        isPlaying.value = false;
      }

      // ✅ শুধু যদি ইমেজ থাকে তাহলে রি-অ্যানালাইসিস করবে
      if (selectedImage.value != null) {
        loadingMessage.value = 'Re-analyzing with new language...'.tr;
        print('🔄 Re-analyzing image with new language...');

        final token = await _getToken();
        if (token == null) {
          loadingMessage.value = '';
          _showError('Authentication token not found', context);
          return;
        }

        final cleanedToken = token.trim().replaceAll('"', '');
        final langCode = selectedLanguage.value;

        final uri = Uri.parse('${ApiConstants.aiAnalysis}?lang=$langCode');
        final request = http.MultipartRequest('POST', uri);
        request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
        request.files.add(
          await http.MultipartFile.fromPath('image', selectedImage.value!.path),
        );

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            final sanitizedData = _sanitizeApiResponse(decoded);
            medicationData.value = MedicationPreviewModel.fromJson(sanitizedData);
            refreshUI.value++;
            print('✅ Re-analysis successful');
          }
        } else {
          print('❌ Re-analysis failed with status: ${response.statusCode}');
          _showError('Failed to re-analyze in $langCode', context);
        }
      }

      loadingMessage.value = '';
      _showSuccess('Language changed successfully', context);

    } catch (e) {
      print('❌ Language change error: $e');
      loadingMessage.value = '';
      _showError('Failed to change language: $e', context);
    } finally {
      isLoading.value = false;
    }
  }

  void updateGlobalLanguage(String langCode) {
    print('🌍 Updating global language to: $langCode');
    selectedLanguage.value = langCode;
    _setTtsLanguage();
  }

  // ==================== NOTES ====================

  Future<void> saveNotes(BuildContext context) async {
    if (medicationData.value?.previewId == null) {
      print('⚠️ Cannot save notes: No preview ID');
      return;
    }

    if (notes.value.isEmpty) {
      print('⚠️ Cannot save notes: Note is empty');
      return;
    }

    print('📝 Saving note...');
    print('📝 Preview ID: ${medicationData.value!.previewId}');

    try {
      final token = await _getToken();
      if (token == null) {
        print('❌ Cannot save notes: No token');
        return;
      }

      final url = Uri.parse(ApiConstants.notes);
      print('🌐 Notes API URL: $url');

      // ✅ Retry mechanism for notes
      const maxRetries = 3;
      int retryCount = 0;
      bool success = false;

      while (retryCount < maxRetries && !success) {
        if (retryCount > 0) {
          print('🔄 Note save retry ${retryCount + 1}/$maxRetries...');
          await Future.delayed(const Duration(milliseconds: 800));
        }

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'preview_id': medicationData.value!.previewId,
            'note': notes.value,
          }),
        ).timeout(const Duration(seconds: 15));

        print('📥 Notes save response status: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          success = true;
          print('✅ Note saved successfully');
        } else if (response.statusCode == 404) {
          print('⚠️ Preview not ready, retrying...');
          retryCount++;
        } else {
          print('❌ Failed to save note: ${response.statusCode}');
          break;
        }
      }

      if (!success) {
        print('⚠️ Could not save note after $maxRetries attempts');
      }
    } catch (e) {
      print('❌ Error saving notes: $e');
    }
  }

  // ==================== TTS (TEXT TO SPEECH) ====================

  String _getTextToSpeak() {
    final data = medicationData.value;
    if (data == null) return '';

    final analysis = data.aiAnalysis;

    final text = '''
      Generic Name: ${analysis.genericName}. 
      Brand Name: ${analysis.brandName}. 
      Manufacturer: ${analysis.manufacturer}. 
      Drug Class: ${analysis.drugClass}. 
      Uses: ${analysis.uses}. 
      Dosage Information: 
        Adults: ${analysis.dosageInformation.adultsDosage}. 
        Children: ${analysis.dosageInformation.childrenDosage}. 
        Elderly: ${analysis.dosageInformation.elderlyDosage}. 
      How to Take: ${analysis.howToTake}. 
      Side Effects: 
        Common: ${analysis.sideEffects.common}. 
        Serious: ${analysis.sideEffects.serious}. 
      Warnings: ${analysis.warnings}. 
      Storage Instructions: ${analysis.storageInstructions}. 
      Interactions: ${analysis.interactions}.
    ''';

    return text;
  }

  Future<void> toggleAudio(BuildContext context) async {
    if (medicationData.value == null) {
      _showError('No medication data available.', context);
      return;
    }

    if (!_ttsInitialized) {
      _showError('TTS not ready. Please try again.', context);
      await _initTts();
      return;
    }

    try {
      if (isPlaying.value) {
        await _flutterTts.stop();
        isPlaying.value = false;
        return;
      }

      final textToSpeak = _getTextToSpeak();
      if (textToSpeak.isEmpty) {
        _showError('No content to speak.', context);
        return;
      }

      print('🔊 Speaking medication details...');
      isPlaying.value = true;
      await _flutterTts.speak(textToSpeak);

    } catch (e) {
      print('❌ TTS error: $e');
      isPlaying.value = false;
      _showError('Failed to speak: $e', context);
    }
  }

  // ==================== SAVE MEDICATION (WITH PROPER LOADING AND RETRY) ====================

  Future<void> saveMedication(BuildContext context) async {
    if (medicationData.value?.previewId == null) {
      _showError('No medication data to save.', context);
      return;
    }

    // ✅ Prevent multiple save attempts
    if (isSaving.value) {
      print('⚠️ Save already in progress');
      return;
    }

    try {
      isSaving.value = true;
      loadingMessage.value = 'Preparing to save medication...'.tr;

      print('💾 Starting save medication process...');
      print('💊 Preview ID: ${medicationData.value!.previewId}');

      // ✅ Initial delay for server to be ready
      await Future.delayed(const Duration(seconds: 1));

      loadingMessage.value = 'Saving medication, please wait...'.tr;

      // ✅ Save note if exists
      if (notes.value.isNotEmpty) {
        print('📝 Saving note before medication...');
        loadingMessage.value = 'Saving your note...'.tr;
        await saveNotes(context);
        await Future.delayed(const Duration(milliseconds: 300));
      }

      loadingMessage.value = 'Saving to cloud...'.tr;
      loadingMessage.value = 'Please wait...'.tr;

      final token = await _getToken();
      if (token == null) {
        loadingMessage.value = '';
        _showError('Authentication token not found', context);
        return;
      }

      final url = Uri.parse(ApiConstants.saveAiAnalysis);
      print('🌐 Save medication API URL: $url');

      final requestBody = json.encode({
        'preview_id': medicationData.value!.previewId,
      });
      print('📤 Request body: $requestBody');

      // ✅ Retry mechanism - 3 attempts with delays
      const maxRetries = 3;
      int retryCount = 0;
      bool success = false;
      http.Response? lastResponse;

      while (retryCount < maxRetries && !success) {
        if (retryCount > 0) {
          print('🔄 Save attempt ${retryCount + 1}/$maxRetries...');
          loadingMessage.value = 'Retrying (${retryCount + 1}/$maxRetries)...'.tr;
          await Future.delayed(const Duration(milliseconds: 800));
        }

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: requestBody,
        ).timeout(const Duration(seconds: 30));

        print('📥 Save attempt ${retryCount + 1} - Status: ${response.statusCode}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          success = true;
          print('✅ Medication saved successfully!');
          loadingMessage.value = 'Success!'.tr;
          await Future.delayed(const Duration(milliseconds: 500));
          _showSuccess('Medication saved successfully!', context);

          if (context.mounted) {
            print('🏠 Navigating to home page...');
            loadingMessage.value = '';
            context.go(AppRoutes.homeViewPage);
          }
          return;
        } else {
          lastResponse = response;
          retryCount++;
        }
      }

      // All retries failed
      if (lastResponse != null && !success) {
        print('❌ All save attempts failed');
        loadingMessage.value = '';
        String errorMsg = 'Failed to save medication';
        try {
          final errorBody = json.decode(lastResponse.body);
          if (errorBody['error'] != null) {
            errorMsg = errorBody['error'];
          }
        } catch (e) {}
        _showError(errorMsg, context);
      }

    } catch (e) {
      print('❌ Save error: $e');
      loadingMessage.value = '';
      _showError('Failed to save medication. Please try again.', context);
    } finally {
      isSaving.value = false;
      loadingMessage.value = '';
      print('🏁 Save medication process completed');
    }
  }

  void updateNotes(String value) {
    notes.value = value;
    print('📝 Note updated: ${value.substring(0, value.length > 50 ? 50 : value.length)}...');
  }

  AiAnalysis? get currentAnalysis => medicationData.value?.aiAnalysis;

  String get currentImageUrl {
    final medVal = medicationData.value;
    if (medVal == null) return '';

    final url = medVal.uploadedImage?.url;
    if (url == null || url.isEmpty) return '';

    // URL already has base? check
    if (url.startsWith('http')) return url;

    // Clean base URL
    String cleanBaseUrl = ApiConstants.baseUrl;
    if (cleanBaseUrl.endsWith('/')) {
      cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
    }

    // Clean path
    String cleanPath = url;
    if (cleanPath.startsWith('/')) {
      cleanPath = cleanPath.substring(1);
    }

    final fullUrl = '$cleanBaseUrl/$cleanPath';
    print('🖼️ Current image URL: $fullUrl');
    return fullUrl;
  }

  // ==================== LOADING STATUS GETTERS ====================

  bool get isAnalyzing => isLoading.value;
  bool get isSavingData => isSaving.value;
  String get getLoadingMessage => loadingMessage.value;
  bool get hasLoadingMessage => loadingMessage.value.isNotEmpty;

  // ==================== HELPER METHODS ====================

  void _showSuccess(String message, BuildContext context) {
    print('✅ Success: $message');
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message, BuildContext context) {
    print('❌ Error: $message');
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}