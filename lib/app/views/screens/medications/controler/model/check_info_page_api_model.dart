// lib/app/views/screens/medications/controler/model/check_info_page_api_model.dart

class CheckInfoPageApiModel {
  final int id;
  final String originalImage;
  final String genericName;
  final String brandName;
  final String manufacturer;
  final String drugClass;
  final String uses;
  final String totPills;
  final DosageInformation dosageInformation;
  final String howToTake;
  final SideEffects sideEffects;
  final String warnings;
  final String storageInstructions;
  final String interactions;
  final String aiAdditionalNotes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> additionalNotes;
  final String language;
  final AudioUrls audioUrls;
  final String audioDirectUrl;
  final AudioInstructions audioInstructions;

  CheckInfoPageApiModel({
    required this.id,
    required this.originalImage,
    required this.genericName,
    required this.brandName,
    required this.manufacturer,
    required this.drugClass,
    required this.uses,
    required this.totPills,
    required this.dosageInformation,
    required this.howToTake,
    required this.sideEffects,
    required this.warnings,
    required this.storageInstructions,
    required this.interactions,
    required this.aiAdditionalNotes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.additionalNotes,
    required this.language,
    required this.audioUrls,
    required this.audioDirectUrl,
    required this.audioInstructions,
  });

  // 🔍 হেলপার ফাংশন - সব ভাষার ফিল্ড খুঁজে বের করে
  static String? _findField(Map<String, dynamic> data, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
        return data[key].toString();
      }
    }
    return null;
  }

  // 🔍 Nested ফিল্ড খুঁজে বের করার ফাংশন
  static Map<String, dynamic> _findNestedField(Map<String, dynamic> data, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (data.containsKey(key) && data[key] is Map<String, dynamic>) {
        return Map<String, dynamic>.from(data[key]);
      }
    }
    return {};
  }

  factory CheckInfoPageApiModel.fromJson(Map<String, dynamic> json) {
    // 🌍 সব ভাষার ফিল্ড নাম
    String genericName = _findField(json, [
      'generic_name', 'nombre_generico', 'nom_generique',
      'nome_generico', 'non_jenerik', 'генерическое_название',
      '通用名', 'genericName'
    ]) ?? 'Unknown';

    String brandName = _findField(json, [
      'brand_name', 'nombre_marca', 'nom_marque',
      'nome_marca', 'non_mak', 'торговое_название',
      '品牌名称', 'brandName'
    ]) ?? 'Unknown';

    String manufacturer = _findField(json, [
      'manufacturer', 'fabricante', 'fabricant',
      'fabricante', 'fabrikant', 'производитель',
      '制造商'
    ]) ?? '';

    String drugClass = _findField(json, [
      'drug_class', 'clase_medicamento', 'classe_medicament',
      'classe_medicamento', 'klas_medikaman', 'класс_препарата',
      '药物类别', '药品分类'
    ]) ?? '';

    String uses = _findField(json, [
      'uses', 'usos', 'utilisations',
      'usos', 'itilizasyon', 'применение',
      '用途', '适应症'
    ]) ?? '';

    String howToTake = _findField(json, [
      'how_to_take', 'como_tomar', 'comment_prendre',
      'como_tomar', 'kijan_pou_pran', 'как_принимать',
      '如何服用', '用法用量'
    ]) ?? '';

    String warnings = _findField(json, [
      'warnings', 'advertencias', 'avertissements',
      'avisos', 'avis', 'предупреждения',
      '警告', '注意事项'
    ]) ?? '';

    String storageInstructions = _findField(json, [
      'storage_instructions', 'instrucciones_almacenamiento', 'instructions_stockage',
      'instrucoes_armazenamento', 'enstriksyon_stokaj', 'инструкции_хранению',
      '存储说明', '贮藏'
    ]) ?? '';

    String interactions = _findField(json, [
      'interactions', 'interacciones', 'interactions',
      'interacoes', 'entèraksyon', 'взаимодействия',
      '相互作用', '药物相互作用'
    ]) ?? '';

    String totPills = _findField(json, [
      'tot_pills', 'total_pastillas', 'total_comprimes',
      'total_pilulas', 'total_gelil', 'всего_таблеток',
      '总药片', '总片数'
    ]) ?? '';

    String originalImage = _findField(json, [
      'original_image', 'imagen_original', 'image_originale',
      'imagem_original', 'imaj_orijinal', 'исходное_изображение',
      '原始图像', 'image'
    ]) ?? '';

    // 📊 Dosage Information
    Map<String, dynamic> dosageData = _findNestedField(json, [
      'dosage_information', 'informacion_dosificacion', 'information_dosage',
      'informacao_dosagem', 'enfomason_dosaj', 'информация_дозировки',
      '给药信息', '剂量信息'
    ]);

    DosageInformation dosageInfo;
    if (dosageData.isNotEmpty) {
      dosageInfo = DosageInformation(
        adultsDosage: _findField(dosageData, [
          'adults_dosage', 'dosificacion_adultos', 'dosage_adultes',
          'dosagem_adultos', 'dosaj_granmoun', 'дозировка_взрослых',
          '成人用量'
        ]) ?? '',
        childrenDosage: _findField(dosageData, [
          'children_dosage', 'dosificacion_ninos', 'dosage_enfants',
          'dosagem_criancas', 'dosaj_timoun', 'дозировка_детей',
          '儿童用量'
        ]) ?? '',
        elderlyDosage: _findField(dosageData, [
          'elderly_dosage', 'dosificacion_ancianos', 'dosage_personnes_agees',
          'dosagem_idosos', 'dosaj_moun_vye', 'дозировка_пожилых',
          '老年人用量'
        ]) ?? '',
      );
    } else {
      dosageInfo = DosageInformation(
        adultsDosage: '',
        childrenDosage: '',
        elderlyDosage: '',
      );
    }

    // 📊 Side Effects
    Map<String, dynamic> sideEffectsData = _findNestedField(json, [
      'side_effects', 'efectos_secundarios', 'effets_secondaires',
      'efeitos_colaterais', 'efet_segondè', 'побочные_эффекты',
      '副作用'
    ]);

    SideEffects sideEffects;
    if (sideEffectsData.isNotEmpty) {
      sideEffects = SideEffects(
        common: _findField(sideEffectsData, [
          'common', 'comunes', 'courants',
          'comuns', 'ordinè', 'частые',
          '常见'
        ]) ?? '',
        serious: _findField(sideEffectsData, [
          'serious', 'graves', 'graves',
          'graves', 'grav', 'серьезные',
          '严重'
        ]) ?? '',
      );
    } else {
      sideEffects = SideEffects(common: '', serious: '');
    }

    return CheckInfoPageApiModel(
      id: json['id'] ?? 0,
      originalImage: originalImage,
      genericName: genericName,
      brandName: brandName,
      manufacturer: manufacturer,
      drugClass: drugClass,
      uses: uses,
      totPills: totPills,
      dosageInformation: dosageInfo,
      howToTake: howToTake,
      sideEffects: sideEffects,
      warnings: warnings,
      storageInstructions: storageInstructions,
      interactions: interactions,
      aiAdditionalNotes: _findField(json, [
        'ai_additional_notes', '附加说明'
      ]) ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
      additionalNotes: json['additional_notes'] ?? [],
      language: json['language']?.toString() ?? 'en',
      audioUrls: AudioUrls.fromJson(json['audio_urls'] ?? {}),
      audioDirectUrl: json['audio_direct_url']?.toString() ?? '',
      audioInstructions: AudioInstructions.fromJson(json['audio_instructions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_image': originalImage,
      'generic_name': genericName,
      'brand_name': brandName,
      'manufacturer': manufacturer,
      'drug_class': drugClass,
      'uses': uses,
      'tot_pills': totPills,
      'dosage_information': dosageInformation.toJson(),
      'how_to_take': howToTake,
      'side_effects': sideEffects.toJson(),
      'warnings': warnings,
      'storage_instructions': storageInstructions,
      'interactions': interactions,
      'ai_additional_notes': aiAdditionalNotes,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'additional_notes': additionalNotes,
      'language': language,
      'audio_urls': audioUrls.toJson(),
      'audio_direct_url': audioDirectUrl,
      'audio_instructions': audioInstructions.toJson(),
    };
  }
}

// DosageInformation - আপডেট needed
class DosageInformation {
  final String adultsDosage;
  final String childrenDosage;
  final String elderlyDosage;

  DosageInformation({
    required this.adultsDosage,
    required this.childrenDosage,
    required this.elderlyDosage,
  });

  factory DosageInformation.fromJson(Map<String, dynamic> json) {
    return DosageInformation(
      adultsDosage: json['adults_dosage'] ?? '',
      childrenDosage: json['children_dosage'] ?? '',
      elderlyDosage: json['elderly_dosage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adults_dosage': adultsDosage,
      'children_dosage': childrenDosage,
      'elderly_dosage': elderlyDosage,
    };
  }
}

// SideEffects - আপডেট needed
class SideEffects {
  final String common;
  final String serious;

  SideEffects({required this.common, required this.serious});

  factory SideEffects.fromJson(Map<String, dynamic> json) {
    return SideEffects(
      common: json['common'] ?? '',
      serious: json['serious'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'common': common, 'serious': serious};
  }
}

// AudioUrls - আপডেট needed
class AudioUrls {
  final String en;
  final String es;
  final String fr;
  final String pt;
  final String ht;
  final String zhCn;
  final String ru;

  AudioUrls({
    required this.en,
    required this.es,
    required this.fr,
    required this.pt,
    required this.ht,
    required this.zhCn,
    required this.ru,
  });

  factory AudioUrls.fromJson(Map<String, dynamic> json) {
    return AudioUrls(
      en: json['en']?.toString() ?? '',
      es: json['es']?.toString() ?? '',
      fr: json['fr']?.toString() ?? '',
      pt: json['pt']?.toString() ?? '',
      ht: json['ht']?.toString() ?? '',
      zhCn: json['zh-CN']?.toString() ?? '',
      ru: json['ru']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'es': es,
      'fr': fr,
      'pt': pt,
      'ht': ht,
      'zh-CN': zhCn,
      'ru': ru,
    };
  }
}

// AudioInstructions - আপডেট needed
class AudioInstructions {
  final String description;
  final List<String> languages;
  final String example;

  AudioInstructions({
    required this.description,
    required this.languages,
    required this.example,
  });

  factory AudioInstructions.fromJson(Map<String, dynamic> json) {
    return AudioInstructions(
      description: json['description']?.toString() ?? '',
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : [],
      example: json['example']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'languages': languages,
      'example': example,
    };
  }
}