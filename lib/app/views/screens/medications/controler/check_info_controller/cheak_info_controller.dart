

import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:saymymeds/app/views/screens/medications/controler/model/check_info_page_api_model.dart';

class CheckInfoController extends GetxController {
  static String get baseUrl {
    String url = ApiConstants.baseUrl;
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  static String get apiCoreUrl {
    String url = ApiConstants.baseUrl;
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return '$url/api/core';
  }

  static String get mediaBaseUrl {
    String url = ApiConstants.baseUrl;
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    return url;
  }

  final Rx<CheckInfoPageApiModel?> medicationDetails = Rx<CheckInfoPageApiModel?>(null);
  final RxString processedImageUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxString noteText = ''.obs;
  final RxString globalLanguageCode = 'en'.obs;

  final RxMap<String, String> translations = RxMap<String, String>({});

  late final FlutterTts flutterTts;
  int medicationId = 0;

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

  final Map<String, Map<String, String>> allTranslations = {
    'en': {
      'generic_name': 'Generic Name',
      'brand_name': 'Brand Name',
      'manufacturer': 'Manufacturer',
      'drug_class': 'Drug Class',
      'uses': 'Uses',
      'dosage_information': 'Dosage Information',
      'adults': 'Adults',
      'children': 'Children',
      'elderly': 'Elderly',
      'how_to_take': 'How to Take',
      'side_effects': 'Side Effects',
      'common': 'Common',
      'serious': 'Serious',
      'warnings': 'Warnings',
      'storage_instructions': 'Storage Instructions',
      'interactions': 'Interactions',
      'add_notes': 'Add notes',
      'save_note': 'Save Note',
      'play': 'Play',
      'playing': 'Playing...',
    },
    'es': {
      'generic_name': 'Nombre Genérico',
      'brand_name': 'Nombre de Marca',
      'manufacturer': 'Fabricante',
      'drug_class': 'Clase de Droga',
      'uses': 'Usos',
      'dosage_information': 'Información de Dosificación',
      'adults': 'Adultos',
      'children': 'Niños',
      'elderly': 'Ancianos',
      'how_to_take': 'Cómo Tomar',
      'side_effects': 'Efectos Secundarios',
      'common': 'Común',
      'serious': 'Serio',
      'warnings': 'Advertencias',
      'storage_instructions': 'Instrucciones de Almacenamiento',
      'interactions': 'Interacciones',
      'add_notes': 'Agregar Notas',
      'save_note': 'Guardar Nota',
      'play': 'Reproducir',
      'playing': 'Reproduciendo...',
    },
    'fr': {
      'generic_name': 'Nom Générique',
      'brand_name': 'Nom de Marque',
      'manufacturer': 'Fabricant',
      'drug_class': 'Classe de Médicament',
      'uses': 'Utilisations',
      'dosage_information': 'Informations sur la Posologie',
      'adults': 'Adultes',
      'children': 'Enfants',
      'elderly': 'Personnes Âgées',
      'how_to_take': 'Comment Prendre',
      'side_effects': 'Effets Secondaires',
      'common': 'Commun',
      'serious': 'Grave',
      'warnings': 'Avertissements',
      'storage_instructions': 'Instructions de Stockage',
      'interactions': 'Interactions',
      'add_notes': 'Ajouter des Notes',
      'save_note': 'Enregistrer la Note',
      'play': 'Jouer',
      'playing': 'En cours...',
    },
    'pt': {
      'generic_name': 'Nome Genérico',
      'brand_name': 'Nome da Marca',
      'manufacturer': 'Fabricante',
      'drug_class': 'Classe de Droga',
      'uses': 'Usos',
      'dosage_information': 'Informação de Dosagem',
      'adults': 'Adultos',
      'children': 'Crianças',
      'elderly': 'Idosos',
      'how_to_take': 'Como Tomar',
      'side_effects': 'Efeitos Colaterais',
      'common': 'Comum',
      'serious': 'Sério',
      'warnings': 'Avisos',
      'storage_instructions': 'Instruções de Armazenamento',
      'interactions': 'Interações',
      'add_notes': 'Adicionar Notas',
      'save_note': 'Salvar Nota',
      'play': 'Tocar',
      'playing': 'Tocando...',
    },
    'ht': {
      'generic_name': 'Non Jenerik',
      'brand_name': 'Non Mak',
      'manufacturer': 'Manifakti',
      'drug_class': 'Klas Dwòg',
      'uses': 'Itilizasyon',
      'dosage_information': 'Enfòmasyon sou Dozaj',
      'adults': 'Granmoun',
      'children': 'Timoun',
      'elderly': 'Granmoun Aje',
      'how_to_take': 'Kijan pou Pran',
      'side_effects': 'Efè Segondè',
      'common': 'Komen',
      'serious': 'Grav',
      'warnings': 'Avètisman',
      'storage_instructions': 'Enstriksyon pou Estoke',
      'interactions': 'Entèraksyon',
      'add_notes': 'Ajoute Nòt',
      'save_note': 'Anrejistre Nòt',
      'play': 'Jwe',
      'playing': 'Ap jwe...',
    },
    'zh-CN': {
      'generic_name': '通用名称',
      'brand_name': '品牌名称',
      'manufacturer': '制造商',
      'drug_class': '药物类别',
      'uses': '用途',
      'dosage_information': '剂量信息',
      'adults': '成人',
      'children': '儿童',
      'elderly': '老年人',
      'how_to_take': '如何服用',
      'side_effects': '副作用',
      'common': '常见',
      'serious': '严重',
      'warnings': '警告',
      'storage_instructions': '存储说明',
      'interactions': '相互作用',
      'add_notes': '添加备注',
      'save_note': '保存备注',
      'play': '播放',
      'playing': '播放中...',
    },
    'ru': {
      'generic_name': 'Общее Название',
      'brand_name': 'Торговая Марка',
      'manufacturer': 'Производитель',
      'drug_class': 'Класс Препарата',
      'uses': 'Применение',
      'dosage_information': 'Информация о Дозировке',
      'adults': 'Взрослые',
      'children': 'Дети',
      'elderly': 'Пожилые',
      'how_to_take': 'Как Принимать',
      'side_effects': 'Побочные Эффекты',
      'common': 'Обычные',
      'serious': 'Серьёзные',
      'warnings': 'Предупреждения',
      'storage_instructions': 'Инструкции по Хранению',
      'interactions': 'Взаимодействия',
      'add_notes': 'Добавить Заметки',
      'save_note': 'Сохранить Заметку',
      'play': 'Воспроизвести',
      'playing': 'Воспроизведение...',
    },
  };

  @override
  void onInit() {
    super.onInit();
    flutterTts = FlutterTts();
    _setupTts();
    _loadTranslations();
    ever(globalLanguageCode, (_) {
      _syncLanguageFromGlobal();
    });
  }

  void _setupTts() async {
    await _setTtsLanguage();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    // ✅ Fixed: Correct way to set completion handler
    flutterTts.setCompletionHandler(() {
      print('TTS Completed');
      isPlaying.value = false;
    });

    // ✅ Fixed: Correct way to set error handler
    flutterTts.setErrorHandler((msg) {
      print('TTS Error: $msg');
      isPlaying.value = false;
      _showSnackbar('Error', 'Failed to speak: $msg');
    });

    // ✅ Optional: Start handler
    flutterTts.setStartHandler(() {
      print('TTS Started');
    });
  }

  Future<void> _setTtsLanguage() async {
    String ttsLang = ttsLanguageMap[selectedLanguage.value] ?? 'en-US';
    var result = await flutterTts.setLanguage(ttsLang);
    print('TTS Language set to: $ttsLang, result: $result');
  }

  void _syncLanguageFromGlobal() {
    final newLang = globalLanguageCode.value;
    if (selectedLanguage.value != newLang) {
      selectedLanguage.value = newLang;
      _loadTranslations();
      _setTtsLanguage();
      if (medicationId > 0) {
        fetchMedicationDetails(medicationId);
      }
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  void _loadTranslations() {
    final langTranslations = allTranslations[selectedLanguage.value];
    if (langTranslations != null) {
      translations.value = langTranslations;
    } else {
      translations.value = allTranslations['en']!;
    }
  }

  String getTranslation(String key) {
    return translations[key] ?? allTranslations['en']?[key] ?? key;
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    final trimmedPath = imagePath.trim();
    if (trimmedPath.startsWith('http://') || trimmedPath.startsWith('https://')) {
      return trimmedPath;
    }
    final cleanPath = trimmedPath.startsWith('/') ? trimmedPath.substring(1) : trimmedPath;
    return '$mediaBaseUrl/$cleanPath';
  }

  Future<void> fetchMedicationDetails(int id) async {
    try {
      medicationId = id;
      isLoading.value = true;
      final token = await StorageHelper.getToken();

      if (token == null) {
        _showSnackbar('Error', 'No authentication token found');
        return;
      }

      final url = '$apiCoreUrl/medications/$id/?lang=${selectedLanguage.value}';
      print('🌐 Fetching from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = CheckInfoPageApiModel.fromJson(data);

        medicationDetails.value = model;
        processedImageUrl.value = _buildImageUrl(model.originalImage);

        if (data['translations'] != null && data['translations'] is Map) {
          try {
            final apiTranslations = Map<String, String>.from(data['translations'] as Map);
            translations.value = apiTranslations;
          } catch (e) {
            _loadTranslations();
          }
        } else {
          _loadTranslations();
        }

        print('✅ Medication loaded: ${model.genericName}');
      } else {
        _showSnackbar('Error', 'Failed to load details');
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeLanguage(String displayLang) async {
    final langCode = languageCodes[displayLang] ?? 'en';
    if (selectedLanguage.value == langCode) return;

    selectedLanguage.value = langCode;
    _loadTranslations();
    await _setTtsLanguage();

    if (medicationId > 0) {
      await fetchMedicationDetails(medicationId);
    }
  }

  void updateGlobalLanguage(String langCode) {
    globalLanguageCode.value = langCode;
  }

  String _getTextToSpeak() {
    final details = medicationDetails.value;
    if (details == null) return '';

    final text = '''
      ${getTranslation('generic_name')}: ${details.genericName}. 
      ${getTranslation('brand_name')}: ${details.brandName}. 
      ${getTranslation('manufacturer')}: ${details.manufacturer}. 
      ${getTranslation('drug_class')}: ${details.drugClass}. 
      ${getTranslation('uses')}: ${details.uses}. 
      ${getTranslation('dosage_information')}: 
        ${getTranslation('adults')}: ${details.dosageInformation.adultsDosage}. 
        ${getTranslation('children')}: ${details.dosageInformation.childrenDosage}. 
        ${getTranslation('elderly')}: ${details.dosageInformation.elderlyDosage}. 
      ${getTranslation('how_to_take')}: ${details.howToTake}. 
      ${getTranslation('side_effects')}: 
        ${getTranslation('common')}: ${details.sideEffects.common}. 
        ${getTranslation('serious')}: ${details.sideEffects.serious}. 
      ${getTranslation('warnings')}: ${details.warnings}. 
      ${getTranslation('storage_instructions')}: ${details.storageInstructions}. 
      ${getTranslation('interactions')}: ${details.interactions}.
    ''';

    return text;
  }

  // check_info_controller.dart - ডিবাগ মেথড যোগ করুন

// ==================== DEBUG: FETCH AND PRINT FULL DATA ====================

  Future<void> debugPrintFullData(int id, String langCode) async {
    print('🐞 ===== DEBUG: CHECK INFO PAGE =====');
    print('📌 Medication ID: $id');
    print('📌 Language: $langCode');
    print('=====================================');

    try {
      final token = await StorageHelper.getToken();
      if (token == null) {
        print('❌ No token found!');
        return;
      }

      final url = '$apiCoreUrl/medications/$id/?lang=$langCode';
      print('🌐 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📥 Status Code: ${response.statusCode}');
      print('📥 Full Response:');
      print('=====================================');
      print(response.body);
      print('=====================================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Parsed JSON Keys: ${data.keys}');

        if (data.containsKey('generic_name')) {
          print('📄 generic_name: ${data['generic_name']}');
        }
        if (data.containsKey('通用名')) {
          print('📄 通用名: ${data['通用名']}');
        }
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  Future<void> toggleAudio() async {
    try {
      if (isPlaying.value) {
        await flutterTts.stop();
        isPlaying.value = false;
        return;
      }

      final textToSpeak = _getTextToSpeak();
      if (textToSpeak.isEmpty) {
        _showSnackbar('Error', 'No content to speak');
        return;
      }

      print('🔊 Speaking...');
      isPlaying.value = true;
      await flutterTts.speak(textToSpeak);

    } catch (e) {
      print('❌ TTS error: $e');
      isPlaying.value = false;
      _showSnackbar('Error', 'Failed to speak: $e');
    }
  }

  Future<void> createNote() async {
    try {
      if (noteText.value.isEmpty) {
        _showSnackbar('Warning', 'Please enter a note');
        return;
      }

      final token = await StorageHelper.getToken();
      if (token == null) {
        _showSnackbar('Error', 'No authentication token found');
        return;
      }

      final response = await http.post(
        Uri.parse('$apiCoreUrl/notes/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'note': noteText.value,
          'medication': medicationId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackbar('Success', 'Note added successfully');
        noteText.value = '';
        await fetchMedicationDetails(medicationId);
      } else {
        _showSnackbar('Error', 'Failed to add note');
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to add note: $e');
    }
  }

  void _showSnackbar(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: title == 'Error' ? Colors.redAccent : Colors.green,
        colorText: Colors.white,
      );
    }
  }
}