import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:saymymeds/app/core/consants/api_constants.dart';  // ✅ যোগ কর
import 'package:saymymeds/app/utlies/storage_helper.dart';
import 'package:saymymeds/app/views/screens/medications/controler/model/check_info_page_api_model.dart';

class CheckInfoController extends GetxController {
  // ✅ ApiConstants থেকে baseUrl নাও - double slash problem fix করে
  static String get baseUrl {
    String url = ApiConstants.baseUrl;
    // শেষের slash remove কর
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
  final RxBool isAudioLoading = false.obs;
  final RxBool isPlaying = false.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxString noteText = ''.obs;
  final RxString currentAudioUrl = ''.obs;
  final RxString globalLanguageCode = 'en'.obs;

  final RxMap<String, String> translations = RxMap<String, String>({});
  final AudioPlayer audioPlayer = AudioPlayer();
  int medicationId = 0;

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
    },
  };

  @override
  void onInit() {
    super.onInit();
    _loadTranslations();
    _setupAudioListener();
    ever(globalLanguageCode, (_) {
      _syncLanguageFromGlobal();
    });
  }

  void _setupAudioListener() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
      isAudioLoading.value = state == PlayerState.playing;
      _logAudio('Audio state changed: $state');
    });

    audioPlayer.onPlayerComplete.listen((_) {
      _logAudio('Audio playback completed');
    });
  }

  void _syncLanguageFromGlobal() {
    final newLang = globalLanguageCode.value;
    if (selectedLanguage.value != newLang) {
      selectedLanguage.value = newLang;
      _loadTranslations();
      if (medicationId > 0) {
        fetchMedicationDetails(medicationId);
      }
      print('✅ CheckInfo: Language synced to $newLang');
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
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

      print('🌐 Fetching medication details for ID: $id');
      print('🌐 URL: $baseUrl/medications/$id/?lang=${selectedLanguage.value}');

      final response = await http.get(
        Uri.parse('$baseUrl/medications/$id/?lang=${selectedLanguage.value}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final model = CheckInfoPageApiModel.fromJson(data);

        medicationDetails.value = model;
        processedImageUrl.value = _buildImageUrl(model.originalImage);

        if (data['translations'] != null && data['translations'] is Map) {
          try {
            final apiTranslations = Map<String, String>.from(data['translations'] as Map);
            translations.value = apiTranslations;
            _logDebug('✅ Translations loaded from API: ${translations.length} keys');
          } catch (e) {
            _logDebug('⚠️ Error parsing API translations: $e');
            _loadTranslations();
          }
        } else {
          _loadTranslations();
          _logDebug('ℹ️ Using local translations');
        }

        _logDebug('✅ Medication details loaded (Lang: ${selectedLanguage.value})');
        _logDebug('🖼️ Image URL: ${processedImageUrl.value}');
        _debugAudioUrls();
      } else {
        _showSnackbar('Error', 'Failed to load details: ${response.statusCode}');
        _logDebug('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch details: $e');
      _logDebug('Error fetching details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _debugAudioUrls() {
    final details = medicationDetails.value;
    if (details == null) return;

    _logAudio('📋 Available Audio URLs:');
    _logAudio('EN: ${details.audioUrls.en}');
    _logAudio('ES: ${details.audioUrls.es}');
    _logAudio('FR: ${details.audioUrls.fr}');
    _logAudio('PT: ${details.audioUrls.pt}');
    _logAudio('HT: ${details.audioUrls.ht}');
    _logAudio('ZH-CN: ${details.audioUrls.zhCn}');
    _logAudio('RU: ${details.audioUrls.ru}');
    _logAudio('Direct: ${details.audioDirectUrl}');
  }

  Future<void> changeLanguage(String displayLang) async {
    final langCode = languageCodes[displayLang] ?? 'en';
    if (selectedLanguage.value == langCode) return;

    selectedLanguage.value = langCode;
    _loadTranslations();

    if (medicationId > 0) {
      await fetchMedicationDetails(medicationId);
    }
    print('✅ CheckInfo language changed to: $displayLang ($langCode)');
  }

  void updateGlobalLanguage(String langCode) {
    globalLanguageCode.value = langCode;
  }

  Future<void> toggleAudio() async {
    try {
      if (isPlaying.value) {
        await audioPlayer.pause();
        isAudioLoading.value = false;
      } else {
        await _playAudio();
      }
    } catch (e) {
      isAudioLoading.value = false;
      _showSnackbar('Error', 'Failed to play audio: $e');
      _logAudio('Error playing audio: $e');
    }
  }

  Future<void> _playAudio() async {
    final audioUrl = getAudioUrlForLanguage();
    _logAudio('🎵 Audio URL for ${selectedLanguage.value}: $audioUrl');

    if (audioUrl.isEmpty) {
      _showSnackbar('Error', 'Audio not available for this language');
      return;
    }

    final token = await StorageHelper.getToken();
    if (token == null) {
      _showSnackbar('Error', 'No authentication token found');
      return;
    }

    isAudioLoading.value = true;
    currentAudioUrl.value = audioUrl;

    try {
      _logAudio('📡 Requesting audio from: $audioUrl');

      final response = await http.get(
        Uri.parse(audioUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      _logAudio('📊 Audio response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        _logAudio('✅ Audio bytes received: ${bytes.length}');
        await audioPlayer.play(BytesSource(bytes));
        _logAudio('▶️ Audio playback started');
        isAudioLoading.value = false;
      } else {
        isAudioLoading.value = false;
        _showSnackbar('Error', 'Failed to load audio: ${response.statusCode}');
      }
    } catch (e) {
      isAudioLoading.value = false;
      _logAudio('❌ Exception: $e');
      _showSnackbar('Error', 'Failed to play audio: $e');
    }
  }

  String getAudioUrlForLanguage() {
    final details = medicationDetails.value;
    if (details == null) return '';

    String? url;
    switch (selectedLanguage.value) {
      case 'en':
        url = details.audioUrls.en;
        break;
      case 'es':
        url = details.audioUrls.es;
        break;
      case 'fr':
        url = details.audioUrls.fr;
        break;
      case 'pt':
        url = details.audioUrls.pt;
        break;
      case 'ht':
        url = details.audioUrls.ht;
        break;
      case 'zh-CN':
        url = details.audioUrls.zhCn;
        break;
      case 'ru':
        url = details.audioUrls.ru;
        break;
      default:
        url = details.audioDirectUrl;
    }

    if (url == null || url.isEmpty) {
      _logAudio('⚠️ No URL found for language: ${selectedLanguage.value}');
      return '';
    }

    return _normalizeAudioUrl(url);
  }

  String _normalizeAudioUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    if (url.startsWith('/api')) {
      return '$mediaBaseUrl$url';
    }
    if (url.startsWith('/')) {
      return '$mediaBaseUrl$url';
    }
    return '$mediaBaseUrl/api/core/$url';
  }

  Future<void> saveNote(int noteId) async {
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

      final response = await http.patch(
        Uri.parse('$baseUrl/notes/$noteId/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'note': noteText.value, 'medication': medicationId}),
      );

      if (response.statusCode == 200) {
        _showSnackbar('Success', 'Note saved successfully');
        noteText.value = '';
      } else {
        _showSnackbar('Error', 'Failed to save note: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to save note: $e');
      _logDebug('Error saving note: $e');
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
        Uri.parse('$baseUrl/notes/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'note': noteText.value, 'medication': medicationId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackbar('Success', 'Note added successfully');
        noteText.value = '';
        await fetchMedicationDetails(medicationId);
      } else {
        _showSnackbar('Error', 'Failed to add note: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to add note: $e');
      _logDebug('Error adding note: $e');
    }
  }

  void _showSnackbar(String title, String message) {
    Future.microtask(() {
      if (Get.context != null) {
        Get.snackbar(title, message);
      } else {
        _logDebug('$title: $message');
      }
    });
  }

  void _logDebug(String message) {
    print('🔍 [CheckInfo] $message');
  }

  void _logAudio(String message) {
    print('🔊 [Audio] $message');
  }
}