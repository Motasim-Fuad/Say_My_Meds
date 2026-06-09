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

  factory CheckInfoPageApiModel.fromJson(Map<String, dynamic> json) {
    return CheckInfoPageApiModel(
      id: json['id'],
      originalImage: json['original_image'],
      genericName: json['generic_name'],
      brandName: json['brand_name'],
      manufacturer: json['manufacturer'],
      drugClass: json['drug_class'],
      uses: json['uses'],
      totPills: json['tot_pills'],
      dosageInformation: DosageInformation.fromJson(json['dosage_information']),
      howToTake: json['how_to_take'],
      sideEffects: SideEffects.fromJson(json['side_effects']),
      warnings: json['warnings'],
      storageInstructions: json['storage_instructions'],
      interactions: json['interactions'],
      aiAdditionalNotes: json['ai_additional_notes'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      additionalNotes: json['additional_notes'] ?? [],
      language: json['language'],
      audioUrls: AudioUrls.fromJson(json['audio_urls']),
      audioDirectUrl: json['audio_direct_url'],
      audioInstructions: AudioInstructions.fromJson(json['audio_instructions']),
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
      adultsDosage: json['adults_dosage'],
      childrenDosage: json['children_dosage'],
      elderlyDosage: json['elderly_dosage'],
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

class SideEffects {
  final String common;
  final String serious;

  SideEffects({required this.common, required this.serious});

  factory SideEffects.fromJson(Map<String, dynamic> json) {
    return SideEffects(common: json['common'], serious: json['serious']);
  }

  Map<String, dynamic> toJson() {
    return {'common': common, 'serious': serious};
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
      en: json['en'],
      es: json['es'],
      fr: json['fr'],
      pt: json['pt'],
      ht: json['ht'],
      zhCn: json['zh-CN'],
      ru: json['ru'],
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
      description: json['description'],
      languages: List<String>.from(json['languages']),
      example: json['example'],
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
