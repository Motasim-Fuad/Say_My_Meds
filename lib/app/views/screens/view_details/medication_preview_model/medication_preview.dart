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
    return MedicationPreviewModel(
      previewId: json['preview_id'],
      aiAnalysis: AiAnalysis.fromJson(json['ai_analysis']),
      uploadedImage: UploadedImage.fromJson(json['uploaded_image']),
      language: json['language'],
      audioUrls: AudioUrls.fromJson(json['audio_urls']),
    );
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
    return AiAnalysis(
      totPills: json['tot_pills'],
      genericName: json['generic_name'],
      brandName: json['brand_name'],
      manufacturer: json['manufacturer'],
      drugClass: json['drug_class'],
      uses: json['uses'],
      dosageInformation: DosageInformation.fromJson(json['dosage_information']),
      howToTake: json['how_to_take'],
      sideEffects: SideEffects.fromJson(json['side_effects']),
      warnings: json['warnings'],
      storageInstructions: json['storage_instructions'],
      interactions: json['interactions'],
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
    return DosageInformation(
      adultsDosage: json['adults_dosage'],
      childrenDosage: json['children_dosage'],
      elderlyDosage: json['elderly_dosage'],
    );
  }
}

class SideEffects {
  final String common;
  final String serious;

  SideEffects({required this.common, required this.serious});

  factory SideEffects.fromJson(Map<String, dynamic> json) {
    return SideEffects(common: json['common'], serious: json['serious']);
  }
}

class UploadedImage {
  final String filename;
  final String url;

  UploadedImage({required this.filename, required this.url});

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(filename: json['filename'], url: json['url']);
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
