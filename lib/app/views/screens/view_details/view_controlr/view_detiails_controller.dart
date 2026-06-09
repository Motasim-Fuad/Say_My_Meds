// import 'dart:io';
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:saymymeds/app/core/app_routes/app_routes.dart';
// import 'package:saymymeds/app/core/consants/api_constants.dart';
// import 'package:saymymeds/app/utlies/storage_helper.dart';
// import 'package:saymymeds/app/views/screens/view_details/medication_preview_model/medication_preview.dart';

// class ViewDetailsController extends GetxController {
//   final Rx<File?> selectedImage = Rx<File?>(null);
//   final RxBool isLoading = RxBool(false);
//   final RxBool isPlaying = RxBool(false);
//   final RxString selectedLanguage = RxString('en');
//   final RxString notes = RxString('');
//   final Rx<MedicationPreviewModel?> medicationData =
//       Rx<MedicationPreviewModel?>(null);
//   final RxInt refreshUI = RxInt(0);

//   final AudioPlayer audioPlayer = AudioPlayer();
//   final ImagePicker _picker = ImagePicker();
//   final String baseUrl = ApiConstants.baseUrl;

//   // ✅ SIMPLE LANGUAGE MAP - Display Name to Language Code
//   final Map<String, String> languageMap = {
//     'English': 'en',
//     'Spanish': 'es',
//     'French': 'fr',
//     'Portuguese': 'pt',
//     'Creole': 'ht',
//     'Chinese': 'zh-CN',
//     'Russian': 'ru',
//   };

//   // ✅ Language to GetX Locale Mapping
//   final Map<String, Locale> localeMap = {
//     'en': const Locale('en', 'US'),
//     'es': const Locale('es', 'ES'),
//     'fr': const Locale('fr', 'FR'),
//     'pt': const Locale('pt', 'PT'),
//     'ht': const Locale('ht', 'HT'),
//     'zh-CN': const Locale('zh-CN', 'CN'),
//     'ru': const Locale('ru', 'RU'),
//   };

//   @override
//   void onInit() {
//     super.onInit();
//     audioPlayer.onPlayerStateChanged.listen((state) {
//       isPlaying.value = state == PlayerState.playing;
//     });
//   }

//   @override
//   void onClose() {
//     audioPlayer.dispose();
//     super.onClose();
//   }

//   Future<String?> _getToken() async => await StorageHelper.getToken();

//   String _toStringValue(dynamic value) {
//     if (value == null) return '';
//     if (value is String) return value;
//     if (value is List) return value.join(', ');
//     return value.toString();
//   }

//   Future<void> pickImageFromCamera(BuildContext context) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 85,
//       );
//       if (pickedFile != null) {
//         selectedImage.value = File(pickedFile.path);
//         await uploadImage(context);
//       }
//     } catch (e) {
//       _showError('Failed to capture image: $e', context);
//     }
//   }

//   Future<void> pickImageFromGallery(BuildContext context) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//       );
//       if (pickedFile != null) {
//         selectedImage.value = File(pickedFile.path);
//         await uploadImage(context);
//       }
//     } catch (e) {
//       _showError('Failed to pick image: $e', context);
//     }
//   }

//   Future<void> uploadImage(BuildContext context) async {
//     if (selectedImage.value == null) return;
//     try {
//       isLoading.value = true;
//       final token = await _getToken();
//       if (token == null) {
//         _showError('Authentication token not found', context);
//         return;
//       }

//       final cleanedToken = token.trim().replaceAll('"', '');
//       final apiLang = selectedLanguage.value;

//       final uri = Uri.parse('$baseUrl/api/core/ai-analysis/?lang=$apiLang');
//       final request = http.MultipartRequest('POST', uri);

//       request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
//       request.files.add(
//         await http.MultipartFile.fromPath('image', selectedImage.value!.path),
//       );

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final jsonData = json.decode(response.body);
//         if (jsonData is Map<String, dynamic>) {
//           final sanitizedData = _sanitizeApiResponse(jsonData);
//           medicationData.value = MedicationPreviewModel.fromJson(sanitizedData);
//           refreshUI.value++;
//           if (context.mounted) {
//             context.push(
//               AppRoutes.medicineDetailPage,
//               extra: medicationData.value,
//             );
//           }
//         }
//       } else if (response.statusCode == 401 || response.statusCode == 403) {
//         _showError('Unauthorized — please log in again', context);
//       } else {
//         _showError('Failed to upload image (${response.statusCode})', context);
//       }
//     } catch (e) {
//       _showError('Failed to upload image: $e', context);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Map<String, dynamic> _sanitizeApiResponse(Map<String, dynamic> data) {
//     final sanitized = Map<String, dynamic>.from(data);

//     if (sanitized['ai_analysis'] is Map<String, dynamic>) {
//       final analysis = Map<String, dynamic>.from(sanitized['ai_analysis']);

//       analysis['tot_pills'] = _toStringValue(analysis['tot_pills']);
//       analysis['generic_name'] = _toStringValue(analysis['generic_name']);
//       analysis['brand_name'] = _toStringValue(analysis['brand_name']);
//       analysis['manufacturer'] = _toStringValue(analysis['manufacturer']);
//       analysis['drug_class'] = _toStringValue(analysis['drug_class']);
//       analysis['uses'] = _toStringValue(analysis['uses']);
//       analysis['how_to_take'] = _toStringValue(analysis['how_to_take']);
//       analysis['warnings'] = _toStringValue(analysis['warnings']);
//       analysis['storage_instructions'] = _toStringValue(
//         analysis['storage_instructions'],
//       );
//       analysis['interactions'] = _toStringValue(analysis['interactions']);

//       if (analysis['dosage_information'] is Map<String, dynamic>) {
//         final dosage = Map<String, dynamic>.from(
//           analysis['dosage_information'],
//         );
//         dosage['adults_dosage'] = _toStringValue(dosage['adults_dosage']);
//         dosage['children_dosage'] = _toStringValue(dosage['children_dosage']);
//         dosage['elderly_dosage'] = _toStringValue(dosage['elderly_dosage']);
//         analysis['dosage_information'] = dosage;
//       }

//       if (analysis['side_effects'] is Map<String, dynamic>) {
//         final sideEffects = Map<String, dynamic>.from(analysis['side_effects']);
//         sideEffects['common'] = _toStringValue(sideEffects['common']);
//         sideEffects['serious'] = _toStringValue(sideEffects['serious']);
//         analysis['side_effects'] = sideEffects;
//       }

//       sanitized['ai_analysis'] = analysis;
//     }

//     return sanitized;
//   }

//   /// ✅ LANGUAGE CHANGE - FIXED VERSION
//   Future<void> changeLanguage(String displayName, BuildContext context) async {
//     try {
//       isLoading.value = true;

//       final langCode = languageMap[displayName] ?? 'en';
//       final locale = localeMap[langCode] ?? const Locale('en', 'US');

//       print('🌍 Changing language: $displayName -> $langCode');

//       if (isPlaying.value) await audioPlayer.stop();

//       await Get.updateLocale(locale);

//       selectedLanguage.value = langCode;
//       print('✅ Language changed to: $langCode');

//       if (selectedImage.value != null) {
//         final token = await _getToken();
//         if (token == null) {
//           _showError('Authentication token not found', context);
//           return;
//         }

//         print('🔄 Re-analyzing in: $langCode');

//         final cleanedToken = token.trim().replaceAll('"', '');
//         final uri = Uri.parse('$baseUrl/api/core/ai-analysis/?lang=$langCode');
//         final request = http.MultipartRequest('POST', uri);

//         request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
//         request.files.add(
//           await http.MultipartFile.fromPath('image', selectedImage.value!.path),
//         );

//         final streamedResponse = await request.send();
//         final response = await http.Response.fromStream(streamedResponse);

//         if (response.statusCode == 200 || response.statusCode == 201) {
//           final decoded = jsonDecode(response.body);
//           if (decoded is Map<String, dynamic>) {
//             final sanitizedData = _sanitizeApiResponse(decoded);
//             medicationData.value = MedicationPreviewModel.fromJson(
//               sanitizedData,
//             );
//             refreshUI.value++;
//             print('✅ Data updated in: $langCode');
//           }
//         } else {
//           _showError(
//             'Failed to re-analyze in $langCode (${response.statusCode})',
//             context,
//           );
//         }
//       } else {
//         print('⚠️ No image to re-analyze');
//       }
//     } catch (e) {
//       _showError('Failed to change language: $e', context);
//       print('❌ Error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> saveNotes(BuildContext context) async {
//     if (medicationData.value?.previewId == null || notes.value.isEmpty) return;

//     try {
//       final token = await _getToken();
//       if (token == null) return;

//       await http
//           .post(
//             Uri.parse('${baseUrl}api/core/notes/'),
//             headers: {
//               'Authorization': 'Bearer $token',
//               'Content-Type': 'application/json',
//             },
//             body: json.encode({
//               'preview_id': medicationData.value!.previewId,
//               'note': notes.value,
//             }),
//           )
//           .timeout(const Duration(seconds: 15));
//     } catch (e) {
//       print('❌ Error saving notes: $e');
//     }
//   }

//   String? get currentAudioUrl {
//     if (medicationData.value == null) return null;
//     final previewId = medicationData.value!.previewId;
//     return '$baseUrl/api/core/audio/preview/$previewId/?lang=${selectedLanguage.value}&audio=true';
//   }

//   Future<void> toggleAudio(BuildContext context) async {
//     if (medicationData.value == null) {
//       _showError('No medication data available.', context);
//       return;
//     }

//     try {
//       final token = await _getToken();
//       final audioUrl = currentAudioUrl;

//       if (audioUrl == null) {
//         _showError('Audio not available.', context);
//         return;
//       }

//       if (isPlaying.value) {
//         await audioPlayer.pause();
//         return;
//       }

//       if (token == null) {
//         _showError('Authentication token not found', context);
//         return;
//       }

//       final response = await http
//           .get(Uri.parse(audioUrl), headers: {'Authorization': 'Bearer $token'})
//           .timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         final bytes = response.bodyBytes;
//         final tempDir = await getTemporaryDirectory();
//         final file = File('${tempDir.path}/temp_audio.mp3');
//         await file.writeAsBytes(bytes, flush: true);
//         await audioPlayer.play(DeviceFileSource(file.path));
//       } else {
//         _showError('Failed to load audio', context);
//       }
//     } catch (e) {
//       _showError('Failed to play audio: $e', context);
//     }
//   }

//   Future<void> saveMedication(BuildContext context) async {
//     if (medicationData.value?.previewId == null) {
//       _showError('No medication data to save.', context);
//       return;
//     }

//     try {
//       isLoading.value = true;
//       await saveNotes(context);

//       final token = await _getToken();
//       if (token == null) {
//         _showError('Authentication token not found', context);
//         return;
//       }

//       final url = Uri.parse(
//         '${baseUrl.endsWith("/") ? baseUrl : "$baseUrl/"}api/core/save-ai-analysis/',
//       );

//       final response = await http
//           .post(
//             url,
//             headers: {
//               'Authorization': 'Bearer $token',
//               'Content-Type': 'application/json',
//             },
//             body: json.encode({'preview_id': medicationData.value!.previewId}),
//           )
//           .timeout(const Duration(seconds: 15));

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (context.mounted) context.pop();
//       } else {
//         _showError('Failed to save medication', context);
//       }
//     } catch (e) {
//       _showError('Failed to save medication: $e', context);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void updateNotes(String value) => notes.value = value;

//   AiAnalysis? get currentAnalysis => medicationData.value?.aiAnalysis;

//   String get currentImageUrl {
//     final medVal = medicationData.value;
//     final url = medVal?.uploadedImage?.url;
//     return url != null ? '$baseUrl$url' : '';
//   }

//   void _showError(String message, BuildContext context) {
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.redAccent,
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saymymeds/app/core/app_routes/app_routes.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:saymymeds/app/views/screens/view_details/medication_preview_model/medication_preview.dart';
import 'package:saymymeds/app/views/screens/settings/view/setting_all_page_cntroller/global_languages_contrlooer.dart';

class ViewDetailsController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = RxBool(false);
  final RxBool isPlaying = RxBool(false);
  final RxString selectedLanguage = RxString('en');
  final RxString notes = RxString('');
  final Rx<MedicationPreviewModel?> medicationData =
      Rx<MedicationPreviewModel?>(null);
  final RxInt refreshUI = RxInt(0);

  final AudioPlayer audioPlayer = AudioPlayer();
  final ImagePicker _picker = ImagePicker();
  final String baseUrl = ApiConstants.baseUrl;

  // ✅ Reference to GlobalLanguageController
  GlobalLanguageController? _globalLanguageController;

  // ✅ SIMPLE LANGUAGE MAP - Display Name to Language Code
  final Map<String, String> languageMap = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'Portugese': 'pt',
    'Creole': 'ht',
    'Chinese': 'zh-CN',
    'Russian': 'ru',
  };

  // ✅ Language to GetX Locale Mapping
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

    // ✅ Try to find GlobalLanguageController
    try {
      _globalLanguageController = Get.find<GlobalLanguageController>();
      // Sync initial language
      final currentLangCode =
          _globalLanguageController!.languageMap[_globalLanguageController!
              .selectedDisplayLanguage
              .value] ??
          'en';
      selectedLanguage.value = currentLangCode;
      print('✅ Synced with GlobalLanguageController: $currentLangCode');
    } catch (e) {
      print(
        '⚠️ GlobalLanguageController not found, using local language management',
      );
    }

    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  Future<String?> _getToken() async => await StorageHelper.getToken();

  String _toStringValue(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) return value.join(', ');
    return value.toString();
  }

  Future<void> pickImageFromCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        await uploadImage(context);
      }
    } catch (e) {
      _showError('Failed to capture image: $e', context);
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        await uploadImage(context);
      }
    } catch (e) {
      _showError('Failed to pick image: $e', context);
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (selectedImage.value == null) return;
    try {
      isLoading.value = true;
      final token = await _getToken();
      if (token == null) {
        _showError('Authentication token not found', context);
        return;
      }

      final cleanedToken = token.trim().replaceAll('"', '');
      final apiLang = selectedLanguage.value;

      final uri = Uri.parse('$baseUrl/api/core/ai-analysis/?lang=$apiLang');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
      request.files.add(
        await http.MultipartFile.fromPath('image', selectedImage.value!.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map<String, dynamic>) {
          final sanitizedData = _sanitizeApiResponse(jsonData);
          medicationData.value = MedicationPreviewModel.fromJson(sanitizedData);
          refreshUI.value++;
          if (context.mounted) {
            context.push(
              AppRoutes.medicineDetailPage,
              extra: medicationData.value,
            );
          }
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        _showError('Unauthorized — please log in again', context);
      } else {
        _showError('Failed to upload image (${response.statusCode})', context);
      }
    } catch (e) {
      _showError('Failed to upload image: $e', context);
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _sanitizeApiResponse(Map<String, dynamic> data) {
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
      analysis['storage_instructions'] = _toStringValue(
        analysis['storage_instructions'],
      );
      analysis['interactions'] = _toStringValue(analysis['interactions']);

      if (analysis['dosage_information'] is Map<String, dynamic>) {
        final dosage = Map<String, dynamic>.from(
          analysis['dosage_information'],
        );
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

    return sanitized;
  }

  /// ✅ UPDATED: Integrated with GlobalLanguageController
  Future<void> changeLanguage(String displayName, BuildContext context) async {
    try {
      isLoading.value = true;

      // ✅ Use GlobalLanguageController if available
      if (_globalLanguageController != null) {
        await _globalLanguageController!.changeLanguage(displayName);
        final langCode =
            _globalLanguageController!.languageMap[displayName] ?? 'en';
        selectedLanguage.value = langCode;
        print('✅ Language synced via GlobalLanguageController: $langCode');
      } else {
        // Fallback to local language change
        final langCode = languageMap[displayName] ?? 'en';
        final locale = localeMap[langCode] ?? const Locale('en', 'US');
        await Get.updateLocale(locale);
        selectedLanguage.value = langCode;
        print('✅ Language changed locally: $langCode');
      }

      final langCode = selectedLanguage.value;

      if (isPlaying.value) await audioPlayer.stop();

      // Re-analyze image if available
      if (selectedImage.value != null) {
        final token = await _getToken();
        if (token == null) {
          _showError('Authentication token not found', context);
          return;
        }

        print('🔄 Re-analyzing in: $langCode');

        final cleanedToken = token.trim().replaceAll('"', '');
        final uri = Uri.parse('$baseUrl/api/core/ai-analysis/?lang=$langCode');
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
            medicationData.value = MedicationPreviewModel.fromJson(
              sanitizedData,
            );
            refreshUI.value++;
            print('✅ Data updated in: $langCode');
          }
        } else {
          _showError(
            'Failed to re-analyze in $langCode (${response.statusCode})',
            context,
          );
        }
      } else {
        print('⚠️ No image to re-analyze');
      }
    } catch (e) {
      _showError('Failed to change language: $e', context);
      print('❌ Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ NEW: Update language from global controller
  void updateGlobalLanguage(String langCode) {
    selectedLanguage.value = langCode;
    print('🔄 ViewDetailsController language updated to: $langCode');
  }

  Future<void> saveNotes(BuildContext context) async {
    if (medicationData.value?.previewId == null || notes.value.isEmpty) return;

    try {
      final token = await _getToken();
      if (token == null) return;

      await http
          .post(
            Uri.parse('${baseUrl}api/core/notes/'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'preview_id': medicationData.value!.previewId,
              'note': notes.value,
            }),
          )
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      print('❌ Error saving notes: $e');
    }
  }

  String? get currentAudioUrl {
    if (medicationData.value == null) return null;
    final previewId = medicationData.value!.previewId;
    return '$baseUrl/api/core/audio/preview/$previewId/?lang=${selectedLanguage.value}&audio=true';
  }

  Future<void> toggleAudio(BuildContext context) async {
    if (medicationData.value == null) {
      _showError('No medication data available.', context);
      return;
    }

    try {
      final token = await _getToken();
      final audioUrl = currentAudioUrl;

      if (audioUrl == null) {
        _showError('Audio not available.', context);
        return;
      }

      if (isPlaying.value) {
        await audioPlayer.pause();
        return;
      }

      if (token == null) {
        _showError('Authentication token not found', context);
        return;
      }

      final response = await http
          .get(Uri.parse(audioUrl), headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/temp_audio.mp3');
        await file.writeAsBytes(bytes, flush: true);
        await audioPlayer.play(DeviceFileSource(file.path));
      } else {
        _showError('Failed to load audio', context);
      }
    } catch (e) {
      _showError('Failed to play audio: $e', context);
    }
  }

  Future<void> saveMedication(BuildContext context) async {
    if (medicationData.value?.previewId == null) {
      _showError('No medication data to save.', context);
      return;
    }

    try {
      isLoading.value = true;
      await saveNotes(context);

      final token = await _getToken();
      if (token == null) {
        _showError('Authentication token not found', context);
        return;
      }

      final url = Uri.parse(
        '${baseUrl.endsWith("/") ? baseUrl : "$baseUrl/"}api/core/save-ai-analysis/',
      );

      final response = await http
          .post(
            url,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({'preview_id': medicationData.value!.previewId}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) context.pop();
      } else {
        _showError('Failed to save medication', context);
      }
    } catch (e) {
      _showError('Failed to save medication: $e', context);
    } finally {
      isLoading.value = false;
    }
  }

  void updateNotes(String value) => notes.value = value;

  AiAnalysis? get currentAnalysis => medicationData.value?.aiAnalysis;

  String get currentImageUrl {
    final medVal = medicationData.value;
    final url = medVal?.uploadedImage?.url;
    return url != null ? '$baseUrl$url' : '';
  }

  void _showError(String message, BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
