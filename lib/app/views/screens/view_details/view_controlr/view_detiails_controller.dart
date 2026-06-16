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
  final RxBool isSaving = RxBool(false);
  final RxBool isPlaying = RxBool(false);
  final RxString selectedLanguage = RxString('en');
  final RxString notes = RxString('');
  final Rx<MedicationPreviewModel?> medicationData = Rx<MedicationPreviewModel?>(null);
  final RxInt refreshUI = RxInt(0);
  final RxString loadingMessage = RxString('');

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

  // ==================== HELPER: FIND TRANSLATED FIELDS ====================

  String? _findField(Map<String, dynamic> data, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
        return data[key].toString();
      }
    }
    return null;
  }

  Map<String, dynamic> _findNestedField(Map<String, dynamic> data, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (data.containsKey(key) && data[key] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data[key]);
      }
    }
    return {};
  }

  Map<String, dynamic> _extractTranslatedFields(Map<String, dynamic> data) {
    print('🔍 Extracting translated fields...');
    Map<String, dynamic> result = {};

    // Generic Name
    String? genericName = _findField(data, [
      'generic_name', 'nombre_generico', 'nom_generique',
      'nome_generico', 'non_jenerik', 'генерическое_название',
      '通用名', 'genericName'
    ]);
    if (genericName != null) result['generic_name'] = genericName;

    // Brand Name
    String? brandName = _findField(data, [
      'brand_name', 'nombre_marca', 'nom_marque',
      'nome_marca', 'non_mak', 'торговое_название',
      '品牌名称', 'brandName'
    ]);
    if (brandName != null) result['brand_name'] = brandName;

    // Manufacturer
    String? manufacturer = _findField(data, [
      'manufacturer', 'fabricante', 'fabricant',
      'fabricante', 'fabrikant', 'производитель',
      '制造商'
    ]);
    if (manufacturer != null) result['manufacturer'] = manufacturer;

    // Drug Class
    String? drugClass = _findField(data, [
      'drug_class', 'clase_medicamento', 'classe_medicament',
      'classe_medicamento', 'klas_medikaman', 'класс_препарата',
      '药物类别'
    ]);
    if (drugClass != null) result['drug_class'] = drugClass;

    // Uses
    String? uses = _findField(data, [
      'uses', 'usos', 'utilisations',
      'usos', 'itilizasyon', 'применение',
      '用途'
    ]);
    if (uses != null) result['uses'] = uses;

    // How to Take
    String? howToTake = _findField(data, [
      'how_to_take', 'como_tomar', 'comment_prendre',
      'como_tomar', 'kijan_pou_pran', 'как_принимать',
      '如何服用'
    ]);
    if (howToTake != null) result['how_to_take'] = howToTake;

    // Warnings
    String? warnings = _findField(data, [
      'warnings', 'advertencias', 'avertissements',
      'avisos', 'avis', 'предупреждения',
      '警告'
    ]);
    if (warnings != null) result['warnings'] = warnings;

    // Storage Instructions
    String? storageInstructions = _findField(data, [
      'storage_instructions', 'instrucciones_almacenamiento', 'instructions_stockage',
      'instrucoes_armazenamento', 'enstriksyon_stokaj', 'инструкции_хранению',
      '存储说明'
    ]);
    if (storageInstructions != null) result['storage_instructions'] = storageInstructions;

    // Interactions
    String? interactions = _findField(data, [
      'interactions', 'interacciones', 'interactions',
      'interacoes', 'entèraksyon', 'взаимодействия',
      '相互作用'
    ]);
    if (interactions != null) result['interactions'] = interactions;

    // Tot Pills
    String? totPills = _findField(data, [
      'tot_pills', 'total_pastillas', 'total_comprimes',
      'total_pilulas', 'total_gelil', 'всего_таблеток',
      '总药片'
    ]);
    if (totPills != null) result['tot_pills'] = totPills;

    // Dosage Information - find nested
    Map<String, dynamic> dosageData = _findNestedField(data, [
      'dosage_information', 'informacion_dosificacion', 'information_dosage',
      'informacao_dosagem', 'enfomason_dosaj', 'информация_дозировки',
      '给药信息'
    ]);

    if (dosageData.isNotEmpty) {
      Map<String, dynamic> dosage = {};

      String? adultsDosage = _findField(dosageData, [
        'adults_dosage', 'dosificacion_adultos', 'dosage_adultes',
        'dosagem_adultos', 'dosaj_granmoun', 'дозировка_взрослых',
        '成人用量'
      ]);
      if (adultsDosage != null) dosage['adults_dosage'] = adultsDosage;

      String? childrenDosage = _findField(dosageData, [
        'children_dosage', 'dosificacion_ninos', 'dosage_enfants',
        'dosagem_criancas', 'dosaj_timoun', 'дозировка_детей',
        '儿童用量'
      ]);
      if (childrenDosage != null) dosage['children_dosage'] = childrenDosage;

      String? elderlyDosage = _findField(dosageData, [
        'elderly_dosage', 'dosificacion_ancianos', 'dosage_personnes_agees',
        'dosagem_idosos', 'dosaj_moun_vye', 'дозировка_пожилых',
        '老年人用量'
      ]);
      if (elderlyDosage != null) dosage['elderly_dosage'] = elderlyDosage;

      if (dosage.isNotEmpty) {
        result['dosage_information'] = dosage;
      }
    }

    // Side Effects - find nested
    Map<String, dynamic> sideEffectsData = _findNestedField(data, [
      'side_effects', 'efectos_secundarios', 'effets_secondaires',
      'efeitos_colaterais', 'efet_segondè', 'побочные_эффекты',
      '副作用'
    ]);

    if (sideEffectsData.isNotEmpty) {
      Map<String, dynamic> sideEffects = {};

      String? common = _findField(sideEffectsData, [
        'common', 'comunes', 'courants',
        'comuns', 'ordinè', 'частые',
        '常见'
      ]);
      if (common != null) sideEffects['common'] = common;

      String? serious = _findField(sideEffectsData, [
        'serious', 'graves', 'graves',
        'graves', 'grav', 'серьезные',
        '严重'
      ]);
      if (serious != null) sideEffects['serious'] = serious;

      if (sideEffects.isNotEmpty) {
        result['side_effects'] = sideEffects;
      }
    }

    return result;
  }

  Map<String, dynamic> _createEmptyResponse() {
    return {
      'preview_id': '',
      'language': 'en',
      'uploaded_image': {'filename': '', 'url': ''},
      'audio_urls': {'en': '', 'es': '', 'fr': '', 'pt': '', 'ht': '', 'zh-CN': '', 'ru': ''},
      'ai_analysis': {
        'tot_pills': '',
        'generic_name': 'Unknown',
        'brand_name': 'Unknown',
        'manufacturer': '',
        'drug_class': '',
        'uses': '',
        'how_to_take': '',
        'warnings': '',
        'storage_instructions': '',
        'interactions': '',
        'dosage_information': {
          'adults_dosage': '',
          'children_dosage': '',
          'elderly_dosage': '',
        },
        'side_effects': {
          'common': '',
          'serious': '',
        },
      }
    };
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
      loadingMessage.value = '';
      _showError('Please select an image first'.tr, context);
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
        _showError('Please login to continue'.tr, context);
        isLoading.value = false;
        return;
      }

      final cleanedToken = token.trim().replaceAll('"', '');
      final apiLang = selectedLanguage.value;

      final uri = Uri.parse('${ApiConstants.aiAnalysis}?lang=$apiLang');
      print('🌐 API URL: $uri');

      loadingMessage.value = 'Uploading image...'.tr;

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
      request.files.add(
        await http.MultipartFile.fromPath('image', selectedImage.value!.path),
      );

      loadingMessage.value = 'AI is analyzing the image...'.tr;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('✅ AI Analysis successful!');

        loadingMessage.value = 'Processing medication data...'.tr;
        await Future.delayed(const Duration(milliseconds: 500));

        if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('ai_analysis') && jsonData['ai_analysis'] != null) {
            final sanitizedData = _sanitizeApiResponse(jsonData);
            medicationData.value = MedicationPreviewModel.fromJson(sanitizedData);
            refreshUI.value++;

            print('💊 Medication detected: ${medicationData.value?.aiAnalysis.brandName}');
            loadingMessage.value = '';

            if (context.mounted) {
              context.push(AppRoutes.medicineDetailPage, extra: medicationData.value);
            }
          } else {
            print('⚠️ AI Analysis response missing ai_analysis data');
            loadingMessage.value = '';
            _showError('Could not detect medication in image'.tr, context);
          }
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('❌ Unauthorized - Status: ${response.statusCode}');
        loadingMessage.value = '';
        _showError('Session expired. Please login again.'.tr, context);
      } else if (response.statusCode == 400) {
        print('❌ Bad Request - Status: ${response.statusCode}');
        loadingMessage.value = '';
        _showError('Invalid image or format not supported'.tr, context);
      } else if (response.statusCode == 500) {
        print('❌ Server Error - Status: ${response.statusCode}');
        loadingMessage.value = '';
        _showError('Server error. Please try again later.'.tr, context);
      } else {
        print('❌ Upload failed with status: ${response.statusCode}');
        loadingMessage.value = '';
        _showError('Failed to upload image (${response.statusCode})', context);
      }
    } catch (e) {
      print('❌ Upload error: $e');
      loadingMessage.value = '';

      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        _showError('No internet connection. Please check your network.'.tr, context);
      } else if (e.toString().contains('Timeout')) {
        _showError('Request timed out. Please try again.'.tr, context);
      } else {
        _showError('Something went wrong. Please try again.'.tr, context);
      }
    } finally {
      isLoading.value = false;
      loadingMessage.value = '';
      print('🏁 Upload process completed');
    }
  }

  // ==================== SANITIZE API RESPONSE ====================

  Map<String, dynamic> _sanitizeApiResponse(Map<String, dynamic> data) {
    print('🔧 Sanitizing API response...');

    if (data == null || data.isEmpty) {
      print('⚠️ Empty or null response received');
      return _createEmptyResponse();
    }

    final sanitized = Map<String, dynamic>.from(data);

    Map<String, dynamic> analysis = {};

    if (sanitized['ai_analysis'] != null && sanitized['ai_analysis'] is Map<String, dynamic>) {
      analysis = Map<String, dynamic>.from(sanitized['ai_analysis']);
    } else {
      print('⚠️ ai_analysis not found, checking for translated fields...');
      analysis = _extractTranslatedFields(sanitized);
    }

    // ✅ Ensure all fields exist
    analysis['tot_pills'] = _toStringValue(analysis['tot_pills'] ?? analysis['total_pastillas'] ?? analysis['total_comprimes'] ?? '');
    analysis['generic_name'] = _toStringValue(analysis['generic_name'] ?? analysis['nombre_generico'] ?? analysis['nom_generique'] ?? analysis['nome_generico'] ?? analysis['non_jenerik'] ?? analysis['генерическое_название'] ?? analysis['通用名'] ?? 'Unknown');
    analysis['brand_name'] = _toStringValue(analysis['brand_name'] ?? analysis['nombre_marca'] ?? analysis['nom_marque'] ?? analysis['nome_marca'] ?? analysis['non_mak'] ?? analysis['торговое_название'] ?? analysis['品牌名称'] ?? 'Unknown');
    analysis['manufacturer'] = _toStringValue(analysis['manufacturer'] ?? analysis['fabricante'] ?? analysis['fabricant'] ?? analysis['fabricante'] ?? analysis['fabrikant'] ?? analysis['производитель'] ?? analysis['制造商'] ?? '');
    analysis['drug_class'] = _toStringValue(analysis['drug_class'] ?? analysis['clase_medicamento'] ?? analysis['classe_medicament'] ?? analysis['classe_medicamento'] ?? analysis['klas_medikaman'] ?? analysis['класс_препарата'] ?? analysis['药物类别'] ?? '');
    analysis['uses'] = _toStringValue(analysis['uses'] ?? analysis['usos'] ?? analysis['utilisations'] ?? analysis['usos'] ?? analysis['itilizasyon'] ?? analysis['применение'] ?? analysis['用途'] ?? '');
    analysis['how_to_take'] = _toStringValue(analysis['how_to_take'] ?? analysis['como_tomar'] ?? analysis['comment_prendre'] ?? analysis['como_tomar'] ?? analysis['kijan_pou_pran'] ?? analysis['как_принимать'] ?? analysis['如何服用'] ?? '');
    analysis['warnings'] = _toStringValue(analysis['warnings'] ?? analysis['advertencias'] ?? analysis['avertissements'] ?? analysis['avisos'] ?? analysis['avis'] ?? analysis['предупреждения'] ?? analysis['警告'] ?? '');
    analysis['storage_instructions'] = _toStringValue(analysis['storage_instructions'] ?? analysis['instrucciones_almacenamiento'] ?? analysis['instructions_stockage'] ?? analysis['instrucoes_armazenamento'] ?? analysis['enstriksyon_stokaj'] ?? analysis['инструкции_хранению'] ?? analysis['存储说明'] ?? '');
    analysis['interactions'] = _toStringValue(analysis['interactions'] ?? analysis['interacciones'] ?? analysis['interactions'] ?? analysis['interacoes'] ?? analysis['entèraksyon'] ?? analysis['взаимодействия'] ?? analysis['相互作用'] ?? '');

    // ✅ Dosage Information
    Map<String, dynamic> dosageData = {};
    if (analysis['dosage_information'] != null && analysis['dosage_information'] is Map<String, dynamic>) {
      dosageData = Map<String, dynamic>.from(analysis['dosage_information']);
    } else {
      dosageData = _findNestedField(analysis, [
        'dosage_information', 'informacion_dosificacion', 'information_dosage',
        'informacao_dosagem', 'enfomason_dosaj', 'информация_дозировки',
        '给药信息'
      ]);
    }

    analysis['dosage_information'] = {
      'adults_dosage': _toStringValue(dosageData['adults_dosage'] ?? dosageData['dosificacion_adultos'] ?? dosageData['dosage_adultes'] ?? dosageData['dosagem_adultos'] ?? dosageData['dosaj_granmoun'] ?? dosageData['дозировка_взрослых'] ?? dosageData['成人用量'] ?? ''),
      'children_dosage': _toStringValue(dosageData['children_dosage'] ?? dosageData['dosificacion_ninos'] ?? dosageData['dosage_enfants'] ?? dosageData['dosagem_criancas'] ?? dosageData['dosaj_timoun'] ?? dosageData['дозировка_детей'] ?? dosageData['儿童用量'] ?? ''),
      'elderly_dosage': _toStringValue(dosageData['elderly_dosage'] ?? dosageData['dosificacion_ancianos'] ?? dosageData['dosage_personnes_agees'] ?? dosageData['dosagem_idosos'] ?? dosageData['dosaj_moun_vye'] ?? dosageData['дозировка_пожилых'] ?? dosageData['老年人用量'] ?? ''),
    };

    // ✅ Side Effects
    Map<String, dynamic> sideEffectsData = {};
    if (analysis['side_effects'] != null && analysis['side_effects'] is Map<String, dynamic>) {
      sideEffectsData = Map<String, dynamic>.from(analysis['side_effects']);
    } else {
      sideEffectsData = _findNestedField(analysis, [
        'side_effects', 'efectos_secundarios', 'effets_secondaires',
        'efeitos_colaterais', 'efet_segondè', 'побочные_эффекты',
        '副作用'
      ]);
    }

    analysis['side_effects'] = {
      'common': _toStringValue(sideEffectsData['common'] ?? sideEffectsData['comunes'] ?? sideEffectsData['courants'] ?? sideEffectsData['comuns'] ?? sideEffectsData['ordinè'] ?? sideEffectsData['частые'] ?? sideEffectsData['常见'] ?? ''),
      'serious': _toStringValue(sideEffectsData['serious'] ?? sideEffectsData['graves'] ?? sideEffectsData['graves'] ?? sideEffectsData['graves'] ?? sideEffectsData['grav'] ?? sideEffectsData['серьезные'] ?? sideEffectsData['严重'] ?? ''),
    };

    sanitized['ai_analysis'] = analysis;
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
      // উদাহরণ: changeLanguage মেথডের ভিতরে
      await debugFetchMedicationWithLanguage(8, 'zh-CN');
      await _setTtsLanguage();

      if (isPlaying.value) {
        await _flutterTts.stop();
        isPlaying.value = false;
      }

      // ✅ Re-analyze if image exists
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

        try {
          final request = http.MultipartRequest('POST', uri);
          request.headers.addAll({'Authorization': 'Bearer $cleanedToken'});
          request.files.add(
            await http.MultipartFile.fromPath('image', selectedImage.value!.path),
          );

          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          print('📥 Re-analysis response status: ${response.statusCode}');

          if (response.statusCode == 200 || response.statusCode == 201) {
            final decoded = jsonDecode(response.body);
            if (decoded is Map<String, dynamic>) {
              if (decoded.containsKey('ai_analysis') && decoded['ai_analysis'] != null) {
                final sanitizedData = _sanitizeApiResponse(decoded);
                medicationData.value = MedicationPreviewModel.fromJson(sanitizedData);
                refreshUI.value++;
                print('✅ Re-analysis successful');
              } else {
                print('⚠️ Re-analysis response missing ai_analysis data');
              }
            }
          } else if (response.statusCode == 500) {
            print('⚠️ Server returned 500 during re-analysis, keeping existing data');
          } else {
            print('❌ Re-analysis failed with status: ${response.statusCode}');
            if (response.statusCode != 500) {
              _showError('Failed to re-analyze in $langCode', context);
            }
          }
        } catch (e) {
          print('❌ Re-analysis request error: $e');
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

  // ==================== DEBUG: FETCH MEDICATION WITH LANGUAGE ====================

  Future<void> debugFetchMedicationWithLanguage(int medicationId, String langCode) async {
    print('🐞 DEBUG: Fetching medication ID: $medicationId with language: $langCode');

    try {
      final token = await _getToken();
      if (token == null) {
        print('❌ DEBUG: No token found!');
        return;
      }

      final cleanedToken = token.trim().replaceAll('"', '');
      final url = '${ApiConstants.baseUrl}/api/core/medications/$medicationId/?lang=$langCode';
      print('🌐 DEBUG: URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $cleanedToken',
          'Content-Type': 'application/json',
        },
      );

      print('📥 DEBUG: Response Status Code: ${response.statusCode}');
      print('📥 DEBUG: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('✅ DEBUG: Successfully fetched data:');
        print(jsonData);
      } else {
        print('❌ DEBUG: Failed to fetch data. Status: ${response.statusCode}');
        // Try to print error message from response
        try {
          final errorData = jsonDecode(response.body);
          print('❌ DEBUG: Error Response: $errorData');
        } catch (e) {
          print('❌ DEBUG: Could not parse error response: $e');
        }
      }
    } catch (e) {
      print('❌ DEBUG: Exception occurred: $e');
    }
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

  // ==================== SAVE MEDICATION ====================

  Future<void> saveMedication(BuildContext context) async {
    if (medicationData.value?.previewId == null) {
      _showError('No medication data to save.', context);
      return;
    }

    if (isSaving.value) {
      print('⚠️ Save already in progress');
      return;
    }

    try {
      isSaving.value = true;
      loadingMessage.value = 'Preparing to save medication...'.tr;

      print('💾 Starting save medication process...');
      print('💊 Preview ID: ${medicationData.value!.previewId}');

      await Future.delayed(const Duration(seconds: 1));

      loadingMessage.value = 'Saving medication, please wait...'.tr;

      if (notes.value.isNotEmpty) {
        print('📝 Saving note before medication...');
        loadingMessage.value = 'Saving your note...'.tr;
        await saveNotes(context);
        await Future.delayed(const Duration(milliseconds: 300));
      }

      loadingMessage.value = 'Saving to cloud...'.tr;

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

    if (url.startsWith('http')) return url;

    String cleanBaseUrl = ApiConstants.baseUrl;
    if (cleanBaseUrl.endsWith('/')) {
      cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
    }

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