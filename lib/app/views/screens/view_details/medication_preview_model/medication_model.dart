// lib/app/views/screens/view_details/medication_preview_model/medication_model.dart

class MedicationPreviewModel {
  final String previewId;
  final AiAnalysis aiAnalysis;
  final UploadedImage uploadedImage;
  final String language;
  final AudioUrls audioUrls;

  MedicationPreviewModel({
    required this.previewId,
    required this.aiAnalysis,
    required this.uploadedImage,
    required this.language,
    required this.audioUrls,
  });

  factory MedicationPreviewModel.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      throw Exception('Empty or null response');
    }

    Map<String, dynamic> analysisData = {};
    if (json['ai_analysis'] != null && json['ai_analysis'] is Map<String, dynamic>) {
      analysisData = Map<String, dynamic>.from(json['ai_analysis']);
    } else {
      analysisData = _extractTranslatedFields(json);
    }

    return MedicationPreviewModel(
      previewId: json['preview_id']?.toString() ?? '',
      aiAnalysis: AiAnalysis.fromJson(analysisData),
      uploadedImage: UploadedImage.fromJson(
          json['uploaded_image'] ?? {'filename': '', 'url': ''}
      ),
      language: json['language']?.toString() ?? 'en',
      audioUrls: AudioUrls.fromJson(
          json['audio_urls'] ?? {'en': '', 'es': '', 'fr': '', 'pt': '', 'ht': '', 'zh-CN': '', 'ru': ''}
      ),
    );
  }

  // 🔍 ট্রান্সলেটেড ফিল্ড খুঁজে বের করার হেলপার
  static Map<String, dynamic> _extractTranslatedFields(Map<String, dynamic> data) {
    print('🔍 Extracting translated fields from response...');
    Map<String, dynamic> result = {};

    // সব ভাষার ফিল্ড নামের ম্যাপ
    final Map<String, List<String>> fieldMappings = {
      'tot_pills': ['tot_pills', 'total_pastillas', 'total_comprimes', 'total_pilulas', 'total_gelil', 'всего_таблеток', '总药片', '总片数'],
      'generic_name': ['generic_name', 'nombre_generico', 'nom_generique', 'nome_generico', 'non_jenerik', 'генерическое_название', '通用名', 'genericName'],
      'brand_name': ['brand_name', 'nombre_marca', 'nom_marque', 'nome_marca', 'non_mak', 'торговое_название', '品牌名称', 'brandName'],
      'manufacturer': ['manufacturer', 'fabricante', 'fabricant', 'fabricante', 'fabrikant', 'производитель', '制造商'],
      'drug_class': ['drug_class', 'clase_medicamento', 'classe_medicament', 'classe_medicamento', 'klas_medikaman', 'класс_препарата', '药物类别'],
      'uses': ['uses', 'usos', 'utilisations', 'usos', 'itilizasyon', 'применение', '用途', '适应症'],
      'how_to_take': ['how_to_take', 'como_tomar', 'comment_prendre', 'como_tomar', 'kijan_pou_pran', 'как_принимать', '如何服用', '用法用量'],
      'warnings': ['warnings', 'advertencias', 'avertissements', 'avisos', 'avis', 'предупреждения', '警告', '注意事项'],
      'storage_instructions': ['storage_instructions', 'instrucciones_almacenamiento', 'instructions_stockage', 'instrucoes_armazenamento', 'enstriksyon_stokaj', 'инструкции_хранению', '存储说明', '贮藏'],
      'interactions': ['interactions', 'interacciones', 'interactions', 'interacoes', 'entèraksyon', 'взаимодействия', '相互作用', '药物相互作用'],
    };

    // প্রতিটি ফিল্ড খুঁজে বের করা
    fieldMappings.forEach((englishKey, possibleKeys) {
      for (var key in possibleKeys) {
        if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
          result[englishKey] = data[key].toString();
          print('   ✅ Found: $englishKey = ${data[key]}');
          break;
        }
      }
    });

    // Dosage Information - nested
    List<String> dosageKeys = [
      'dosage_information', 'informacion_dosificacion', 'information_dosage',
      'informacao_dosagem', 'enfomason_dosaj', 'информация_дозировки',
      '给药信息', '剂量信息'
    ];

    Map<String, dynamic> dosageData = {};
    for (var key in dosageKeys) {
      if (data.containsKey(key) && data[key] is Map<String, dynamic>) {
        dosageData = Map<String, dynamic>.from(data[key]);
        print('   ✅ Found dosage_information');
        break;
      }
    }

    if (dosageData.isNotEmpty) {
      Map<String, dynamic> dosage = {};

      List<String> adultKeys = ['adults_dosage', 'dosificacion_adultos', 'dosage_adultes', 'dosagem_adultos', 'dosaj_granmoun', 'дозировка_взрослых', '成人用量'];
      List<String> childKeys = ['children_dosage', 'dosificacion_ninos', 'dosage_enfants', 'dosagem_criancas', 'dosaj_timoun', 'дозировка_детей', '儿童用量'];
      List<String> elderlyKeys = ['elderly_dosage', 'dosificacion_ancianos', 'dosage_personnes_agees', 'dosagem_idosos', 'dosaj_moun_vye', 'дозировка_пожилых', '老年人用量'];

      for (var key in adultKeys) {
        if (dosageData.containsKey(key) && dosageData[key] != null && dosageData[key].toString().isNotEmpty) {
          dosage['adults_dosage'] = dosageData[key].toString();
          break;
        }
      }
      for (var key in childKeys) {
        if (dosageData.containsKey(key) && dosageData[key] != null && dosageData[key].toString().isNotEmpty) {
          dosage['children_dosage'] = dosageData[key].toString();
          break;
        }
      }
      for (var key in elderlyKeys) {
        if (dosageData.containsKey(key) && dosageData[key] != null && dosageData[key].toString().isNotEmpty) {
          dosage['elderly_dosage'] = dosageData[key].toString();
          break;
        }
      }

      if (dosage.isNotEmpty) {
        result['dosage_information'] = dosage;
      }
    }

    // Side Effects - nested
    List<String> sideEffectKeys = [
      'side_effects', 'efectos_secundarios', 'effets_secondaires',
      'efeitos_colaterais', 'efet_segondè', 'побочные_эффекты',
      '副作用'
    ];

    Map<String, dynamic> sideEffectsData = {};
    for (var key in sideEffectKeys) {
      if (data.containsKey(key) && data[key] is Map<String, dynamic>) {
        sideEffectsData = Map<String, dynamic>.from(data[key]);
        print('   ✅ Found side_effects');
        break;
      }
    }

    if (sideEffectsData.isNotEmpty) {
      Map<String, dynamic> sideEffects = {};

      List<String> commonKeys = ['common', 'comunes', 'courants', 'comuns', 'ordinè', 'частые', '常见'];
      List<String> seriousKeys = ['serious', 'graves', 'graves', 'graves', 'grav', 'серьезные', '严重'];

      for (var key in commonKeys) {
        if (sideEffectsData.containsKey(key) && sideEffectsData[key] != null && sideEffectsData[key].toString().isNotEmpty) {
          sideEffects['common'] = sideEffectsData[key].toString();
          break;
        }
      }
      for (var key in seriousKeys) {
        if (sideEffectsData.containsKey(key) && sideEffectsData[key] != null && sideEffectsData[key].toString().isNotEmpty) {
          sideEffects['serious'] = sideEffectsData[key].toString();
          break;
        }
      }

      if (sideEffects.isNotEmpty) {
        result['side_effects'] = sideEffects;
      }
    }

    print('✅ Extracted fields: ${result.keys}');
    return result;
  }
}

class AiAnalysis {
  final String totPills;
  final String genericName;
  final String brandName;
  final String manufacturer;
  final String drugClass;
  final String uses;
  final DosageInformation dosageInformation;
  final String howToTake;
  final SideEffects sideEffects;
  final String warnings;
  final String storageInstructions;
  final String interactions;

  AiAnalysis({
    required this.totPills,
    required this.genericName,
    required this.brandName,
    required this.manufacturer,
    required this.drugClass,
    required this.uses,
    required this.dosageInformation,
    required this.howToTake,
    required this.sideEffects,
    required this.warnings,
    required this.storageInstructions,
    required this.interactions,
  });

  factory AiAnalysis.fromJson(Map<String, dynamic> json) {
    // 🔍 হেলপার ফাংশন
    String? findField(Map<String, dynamic> data, List<String> possibleKeys) {
      for (var key in possibleKeys) {
        if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
          return data[key].toString();
        }
      }
      return null;
    }

    return AiAnalysis(
      totPills: findField(json, [
        'tot_pills', 'total_pastillas', 'total_comprimes',
        'total_pilulas', 'total_gelil', 'всего_таблеток',
        '总药片', '总片数'
      ]) ?? '',
      genericName: findField(json, [
        'generic_name', 'nombre_generico', 'nom_generique',
        'nome_generico', 'non_jenerik', 'генерическое_название',
        '通用名', 'genericName'
      ]) ?? 'Unknown',
      brandName: findField(json, [
        'brand_name', 'nombre_marca', 'nom_marque',
        'nome_marca', 'non_mak', 'торговое_название',
        '品牌名称', 'brandName'
      ]) ?? 'Unknown',
      manufacturer: findField(json, [
        'manufacturer', 'fabricante', 'fabricant',
        'fabricante', 'fabrikant', 'производитель',
        '制造商'
      ]) ?? '',
      drugClass: findField(json, [
        'drug_class', 'clase_medicamento', 'classe_medicament',
        'classe_medicamento', 'klas_medikaman', 'класс_препарата',
        '药物类别', '药品分类'
      ]) ?? '',
      uses: findField(json, [
        'uses', 'usos', 'utilisations',
        'usos', 'itilizasyon', 'применение',
        '用途', '适应症'
      ]) ?? '',
      howToTake: findField(json, [
        'how_to_take', 'como_tomar', 'comment_prendre',
        'como_tomar', 'kijan_pou_pran', 'как_принимать',
        '如何服用', '用法用量'
      ]) ?? '',
      warnings: findField(json, [
        'warnings', 'advertencias', 'avertissements',
        'avisos', 'avis', 'предупреждения',
        '警告', '注意事项'
      ]) ?? '',
      storageInstructions: findField(json, [
        'storage_instructions', 'instrucciones_almacenamiento', 'instructions_stockage',
        'instrucoes_armazenamento', 'enstriksyon_stokaj', 'инструкции_хранению',
        '存储说明', '贮藏'
      ]) ?? '',
      interactions: findField(json, [
        'interactions', 'interacciones', 'interactions',
        'interacoes', 'entèraksyon', 'взаимодействия',
        '相互作用', '药物相互作用'
      ]) ?? '',
      dosageInformation: DosageInformation.fromJson(
          json['dosage_information'] ??
              json['给药信息'] ??
              json['剂量信息'] ??
              {}
      ),
      sideEffects: SideEffects.fromJson(
          json['side_effects'] ??
              json['副作用'] ??
              {}
      ),
    );
  }
}

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
    String? findField(Map<String, dynamic> data, List<String> possibleKeys) {
      for (var key in possibleKeys) {
        if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
          return data[key].toString();
        }
      }
      return null;
    }

    return DosageInformation(
      adultsDosage: findField(json, [
        'adults_dosage', 'dosificacion_adultos', 'dosage_adultes',
        'dosagem_adultos', 'dosaj_granmoun', 'дозировка_взрослых',
        '成人用量'
      ]) ?? '',
      childrenDosage: findField(json, [
        'children_dosage', 'dosificacion_ninos', 'dosage_enfants',
        'dosagem_criancas', 'dosaj_timoun', 'дозировка_детей',
        '儿童用量'
      ]) ?? '',
      elderlyDosage: findField(json, [
        'elderly_dosage', 'dosificacion_ancianos', 'dosage_personnes_agees',
        'dosagem_idosos', 'dosaj_moun_vye', 'дозировка_пожилых',
        '老年人用量'
      ]) ?? '',
    );
  }
}

class SideEffects {
  final String common;
  final String serious;

  SideEffects({required this.common, required this.serious});

  factory SideEffects.fromJson(Map<String, dynamic> json) {
    String? findField(Map<String, dynamic> data, List<String> possibleKeys) {
      for (var key in possibleKeys) {
        if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
          return data[key].toString();
        }
      }
      return null;
    }

    return SideEffects(
      common: findField(json, [
        'common', 'comunes', 'courants',
        'comuns', 'ordinè', 'частые',
        '常见'
      ]) ?? '',
      serious: findField(json, [
        'serious', 'graves', 'graves',
        'graves', 'grav', 'серьезные',
        '严重'
      ]) ?? '',
    );
  }
}

class UploadedImage {
  final String filename;
  final String url;

  UploadedImage({required this.filename, required this.url});

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      filename: json['filename']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }
}

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

  String getUrlForLanguage(String lang) {
    switch (lang) {
      case 'English':
        return en;
      case 'Spanish':
        return es;
      case 'French':
        return fr;
      case 'Portuguese':
        return pt;
      case 'Creole':
        return ht;
      case 'Chinese':
        return zhCn;
      case 'Russian':
        return ru;
      default:
        return en;
    }
  }
}