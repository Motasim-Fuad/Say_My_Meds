// recently_scanned_model.dart

import 'dart:convert';

class RecentlyScanned {
  final List<Medication> results;
  final String language;

  RecentlyScanned({required this.results, required this.language});

  factory RecentlyScanned.fromJson(Map<String, dynamic> json) {
    return RecentlyScanned(
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => Medication.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      language: json['language']?.toString() ?? 'en',
    );
  }

  Map<String, dynamic> toJson() => {
    'results': results.map((e) => e.toJson()).toList(),
    'language': language,
  };
}

// recently_scanned_model.dart - Medication ক্লাস আপডেট করুন

class Medication {
  final int id;
  String originalImage;
  final String genericName;
  final String brandName;
  final String? manufacturer;        // ✅ Optional করা হয়েছে
  final String? drugClass;           // ✅ Optional করা হয়েছে
  final String? uses;                // ✅ Optional করা হয়েছে
  final String? totPills;            // ✅ Optional করা হয়েছে
  final DosageInformation? dosageInformation;  // ✅ Optional করা হয়েছে
  final String? howToTake;           // ✅ Optional করা হয়েছে
  final SideEffects? sideEffects;    // ✅ Optional করা হয়েছে
  final String? warnings;            // ✅ Optional করা হয়েছে
  final String? storageInstructions; // ✅ Optional করা হয়েছে
  final String? interactions;        // ✅ Optional করা হয়েছে
  final String? aiAdditionalNotes;   // ✅ Optional করা হয়েছে
  final bool? isActive;              // ✅ Optional করা হয়েছে
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AdditionalNote>? additionalNotes;  // ✅ Optional করা হয়েছে

  Medication({
    required this.id,
    required this.originalImage,
    required this.genericName,
    required this.brandName,
    this.manufacturer,
    this.drugClass,
    this.uses,
    this.totPills,
    this.dosageInformation,
    this.howToTake,
    this.sideEffects,
    this.warnings,
    this.storageInstructions,
    this.interactions,
    this.aiAdditionalNotes,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.additionalNotes,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    // 🔍 ট্রান্সলেটেড ফিল্ড খুঁজে বের করার ফাংশন
    String? findTranslatedField(Map<String, dynamic> data, List<String> possibleKeys) {
      for (var key in possibleKeys) {
        if (data.containsKey(key) && data[key] != null && data[key].toString().isNotEmpty) {
          return data[key].toString();
        }
      }
      return null;
    }

    // 🌍 বিভিন্ন ভাষার ফিল্ড নাম
    String? genericName = findTranslatedField(json, [
      'generic_name', 'nombre_generico', 'nom_generique',
      'nome_generico', 'non_jenerik', 'генерическое_название',
      '通用名', 'genericName', 'name'
    ]);

    String? brandName = findTranslatedField(json, [
      'brand_name', 'nombre_marca', 'nom_marque',
      'nome_marca', 'non_mak', 'торговое_название',
      '品牌名称', 'brandName'
    ]);

    String? manufacturer = findTranslatedField(json, [
      'manufacturer', 'fabricante', 'fabricant',
      'fabricante', 'fabrikant', 'производитель',
      '制造商'
    ]);

    String? drugClass = findTranslatedField(json, [
      'drug_class', 'clase_medicamento', 'classe_medicament',
      'classe_medicamento', 'klas_medikaman', 'класс_препарата',
      '药物类别'
    ]);

    String? uses = findTranslatedField(json, [
      'uses', 'usos', 'utilisations',
      'usos', 'itilizasyon', 'применение',
      '用途'
    ]);

    String? totPills = findTranslatedField(json, [
      'tot_pills', 'total_pastillas', 'total_comprimes',
      'total_pilulas', 'total_gelil', 'всего_таблеток',
      '总药片'
    ]);

    String? howToTake = findTranslatedField(json, [
      'how_to_take', 'como_tomar', 'comment_prendre',
      'como_tomar', 'kijan_pou_pran', 'как_принимать',
      '如何服用'
    ]);

    String? warnings = findTranslatedField(json, [
      'warnings', 'advertencias', 'avertissements',
      'avisos', 'avis', 'предупреждения',
      '警告'
    ]);

    String? storageInstructions = findTranslatedField(json, [
      'storage_instructions', 'instrucciones_almacenamiento', 'instructions_stockage',
      'instrucoes_armazenamento', 'enstriksyon_stokaj', 'инструкции_хранению',
      '存储说明'
    ]);

    String? interactions = findTranslatedField(json, [
      'interactions', 'interacciones', 'interactions',
      'interacoes', 'entèraksyon', 'взаимодействия',
      '相互作用'
    ]);

    String? imagePath = findTranslatedField(json, [
      'original_image', 'imagen_original', 'image_originale',
      'imagem_original', 'imaj_orijinal', 'исходное_изображение',
      '原始图像', 'image'
    ]);

    // Dosage Information
    DosageInformation? dosageInfo;
    if (json['dosage_information'] != null ||
        json['informacion_dosificacion'] != null ||
        json['information_dosage'] != null ||
        json['informacao_dosagem'] != null ||
        json['enfomason_dosaj'] != null ||
        json['информация_дозировки'] != null ||
        json['给药信息'] != null) {

      Map<String, dynamic> dosageData = {};

      // খুঁজে বের করুন কোন কী-তে ডসেজ ইনফো আছে
      List<String> possibleDosageKeys = [
        'dosage_information', 'informacion_dosificacion', 'information_dosage',
        'informacao_dosagem', 'enfomason_dosaj', 'информация_дозировки',
        '给药信息'
      ];

      for (var key in possibleDosageKeys) {
        if (json[key] != null && json[key] is Map<String, dynamic>) {
          dosageData = json[key];
          break;
        }
      }

      if (dosageData.isNotEmpty) {
        String? adultsDosage = findTranslatedField(dosageData, [
          'adults_dosage', 'dosificacion_adultos', 'dosage_adultes',
          'dosagem_adultos', 'dosaj_granmoun', 'дозировка_взрослых',
          '成人用量'
        ]);

        String? childrenDosage = findTranslatedField(dosageData, [
          'children_dosage', 'dosificacion_ninos', 'dosage_enfants',
          'dosagem_criancas', 'dosaj_timoun', 'дозировка_детей',
          '儿童用量'
        ]);

        String? elderlyDosage = findTranslatedField(dosageData, [
          'elderly_dosage', 'dosificacion_ancianos', 'dosage_personnes_agees',
          'dosagem_idosos', 'dosaj_moun_vye', 'дозировка_пожилых',
          '老年人用量'
        ]);

        dosageInfo = DosageInformation(
          adultsDosage: adultsDosage ?? '',
          childrenDosage: childrenDosage ?? '',
          elderlyDosage: elderlyDosage ?? '',
        );
      }
    }

    // Side Effects
    SideEffects? sideEffects;
    if (json['side_effects'] != null ||
        json['efectos_secundarios'] != null ||
        json['effets_secondaires'] != null ||
        json['efeitos_colaterais'] != null ||
        json['efet_segondè'] != null ||
        json['побочные_эффекты'] != null ||
        json['副作用'] != null) {

      Map<String, dynamic> sideEffectsData = {};
      List<String> possibleSideEffectsKeys = [
        'side_effects', 'efectos_secundarios', 'effets_secondaires',
        'efeitos_colaterais', 'efet_segondè', 'побочные_эффекты',
        '副作用'
      ];

      for (var key in possibleSideEffectsKeys) {
        if (json[key] != null && json[key] is Map<String, dynamic>) {
          sideEffectsData = json[key];
          break;
        }
      }

      if (sideEffectsData.isNotEmpty) {
        List<String> common = [];
        List<String> serious = [];

        // Common side effects
        dynamic commonData = sideEffectsData['common'] ?? sideEffectsData['comunes'] ??
            sideEffectsData['courants'] ?? sideEffectsData['comuns'] ??
            sideEffectsData['ordinè'] ?? sideEffectsData['частые'] ??
            sideEffectsData['常见'];

        if (commonData is List) {
          common = commonData.map((e) => e.toString()).toList();
        } else if (commonData is String && commonData.isNotEmpty) {
          common = commonData.split(',').map((e) => e.trim()).toList();
        }

        // Serious side effects
        dynamic seriousData = sideEffectsData['serious'] ?? sideEffectsData['graves'] ??
            sideEffectsData['graves'] ?? sideEffectsData['graves'] ??
            sideEffectsData['grav'] ?? sideEffectsData['серьезные'] ??
            sideEffectsData['严重'];

        if (seriousData is List) {
          serious = seriousData.map((e) => e.toString()).toList();
        } else if (seriousData is String && seriousData.isNotEmpty) {
          serious = seriousData.split(',').map((e) => e.trim()).toList();
        }

        sideEffects = SideEffects(common: common, serious: serious);
      }
    }

    return Medication(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      originalImage: imagePath ?? '',
      genericName: genericName ?? 'Unknown',
      brandName: brandName ?? '',
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
      aiAdditionalNotes: json['ai_additional_notes']?.toString(),
      isActive: json['is_active'] as bool?,
      createdAt: _tryParseDateTime(json['created_at']),
      updatedAt: _tryParseDateTime(json['updated_at']),
      additionalNotes: (json['additional_notes'] as List<dynamic>?)
          ?.map((e) => AdditionalNote.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'original_image': originalImage,
    'generic_name': genericName,
    'brand_name': brandName,
    'manufacturer': manufacturer,
    'drug_class': drugClass,
    'uses': uses,
    'tot_pills': totPills,
    'dosage_information': dosageInformation?.toJson(),
    'how_to_take': howToTake,
    'side_effects': sideEffects?.toJson(),
    'warnings': warnings,
    'storage_instructions': storageInstructions,
    'interactions': interactions,
    'ai_additional_notes': aiAdditionalNotes,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'additional_notes': additionalNotes?.map((e) => e.toJson()).toList(),
  };

  static DateTime? _tryParseDateTime(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
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
    return DosageInformation(
      adultsDosage: json['adults_dosage']?.toString() ?? '',
      childrenDosage: json['children_dosage']?.toString() ?? '',
      elderlyDosage: json['elderly_dosage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'adults_dosage': adultsDosage,
    'children_dosage': childrenDosage,
    'elderly_dosage': elderlyDosage,
  };
}

class SideEffects {
  final List<String> common;
  final List<String> serious;

  SideEffects({required this.common, required this.serious});

  factory SideEffects.fromJson(Map<String, dynamic> json) {
    List<String> _listFromDynamic(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      if (v is String) {
        String s = v.trim();
        try {
          final decoded = jsonDecode(s);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {}
        s = s.replaceAll('[', '').replaceAll(']', '');
        return s
            .split(',')
            .map((e) => e.replaceAll("'", '').trim())
            .where((e) => e != '')
            .toList();
      }
      return [v.toString()];
    }

    return SideEffects(
      common: _listFromDynamic(json['common']),
      serious: _listFromDynamic(json['serious']),
    );
  }

  Map<String, dynamic> toJson() => {'common': common, 'serious': serious};
}

class AdditionalNote {
  final int id;
  final int medication;
  final int user;
  final String note;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdditionalNote({
    required this.id,
    required this.medication,
    required this.user,
    required this.note,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdditionalNote.fromJson(Map<String, dynamic> json) {
    return AdditionalNote(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      medication: json['medication'] is int
          ? json['medication'] as int
          : int.parse(json['medication'].toString()),
      user: json['user'] is int
          ? json['user'] as int
          : int.parse(json['user'].toString()),
      note: json['note']?.toString() ?? '',
      isActive: json['is_active'] == null ? false : (json['is_active'] as bool),
      createdAt: Medication._tryParseDateTime(json['created_at']),
      updatedAt: Medication._tryParseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medication': medication,
    'user': user,
    'note': note,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
