// ignore: camel_case_types
class homePage {
  String? previewId;
  Null? medicationId;
  AiAnalysis? aiAnalysis;
  UploadedImage? uploadedImage;
  int? expiresInDays;
  String? message;
  String? language;
  AudioUrls? audioUrls;
  String? audioDirectUrl;
  AudioInstructions? audioInstructions;

  homePage({
    this.previewId,
    this.medicationId,
    this.aiAnalysis,
    this.uploadedImage,
    this.expiresInDays,
    this.message,
    this.language,
    this.audioUrls,
    this.audioDirectUrl,
    this.audioInstructions,
  });

  homePage.fromJson(Map<String, dynamic> json) {
    previewId = json['preview_id'];
    medicationId = json['medication_id'];
    aiAnalysis = json['ai_analysis'] != null
        ? new AiAnalysis.fromJson(json['ai_analysis'])
        : null;
    uploadedImage = json['uploaded_image'] != null
        ? new UploadedImage.fromJson(json['uploaded_image'])
        : null;
    expiresInDays = json['expires_in_days'];
    message = json['message'];
    language = json['language'];
    audioUrls = json['audio_urls'] != null
        ? new AudioUrls.fromJson(json['audio_urls'])
        : null;
    audioDirectUrl = json['audio_direct_url'];
    audioInstructions = json['audio_instructions'] != null
        ? new AudioInstructions.fromJson(json['audio_instructions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preview_id'] = this.previewId;
    data['medication_id'] = this.medicationId;
    if (this.aiAnalysis != null) {
      data['ai_analysis'] = this.aiAnalysis!.toJson();
    }
    if (this.uploadedImage != null) {
      data['uploaded_image'] = this.uploadedImage!.toJson();
    }
    data['expires_in_days'] = this.expiresInDays;
    data['message'] = this.message;
    data['language'] = this.language;
    if (this.audioUrls != null) {
      data['audio_urls'] = this.audioUrls!.toJson();
    }
    data['audio_direct_url'] = this.audioDirectUrl;
    if (this.audioInstructions != null) {
      data['audio_instructions'] = this.audioInstructions!.toJson();
    }
    return data;
  }
}

class AiAnalysis {
  String? totPills;
  String? genericName;
  String? brandName;
  String? manufacturer;
  String? drugClass;
  String? uses;
  DosageInformation? dosageInformation;
  String? howToTake;
  SideEffects? sideEffects;
  String? warnings;
  String? storageInstructions;
  String? interactions;
  String? additionalNotes;

  AiAnalysis({
    this.totPills,
    this.genericName,
    this.brandName,
    this.manufacturer,
    this.drugClass,
    this.uses,
    this.dosageInformation,
    this.howToTake,
    this.sideEffects,
    this.warnings,
    this.storageInstructions,
    this.interactions,
    this.additionalNotes,
  });

  AiAnalysis.fromJson(Map<String, dynamic> json) {
    totPills = json['tot_pills'];
    genericName = json['generic_name'];
    brandName = json['brand_name'];
    manufacturer = json['manufacturer'];
    drugClass = json['drug_class'];
    uses = json['uses'];
    dosageInformation = json['dosage_information'] != null
        ? new DosageInformation.fromJson(json['dosage_information'])
        : null;
    howToTake = json['how_to_take'];
    sideEffects = json['side_effects'] != null
        ? new SideEffects.fromJson(json['side_effects'])
        : null;
    warnings = json['warnings'];
    storageInstructions = json['storage_instructions'];
    interactions = json['interactions'];
    additionalNotes = json['additional_notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tot_pills'] = this.totPills;
    data['generic_name'] = this.genericName;
    data['brand_name'] = this.brandName;
    data['manufacturer'] = this.manufacturer;
    data['drug_class'] = this.drugClass;
    data['uses'] = this.uses;
    if (this.dosageInformation != null) {
      data['dosage_information'] = this.dosageInformation!.toJson();
    }
    data['how_to_take'] = this.howToTake;
    if (this.sideEffects != null) {
      data['side_effects'] = this.sideEffects!.toJson();
    }
    data['warnings'] = this.warnings;
    data['storage_instructions'] = this.storageInstructions;
    data['interactions'] = this.interactions;
    data['additional_notes'] = this.additionalNotes;
    return data;
  }
}

class DosageInformation {
  String? adultsDosage;
  String? childrenDosage;
  String? elderlyDosage;

  DosageInformation({
    this.adultsDosage,
    this.childrenDosage,
    this.elderlyDosage,
  });

  DosageInformation.fromJson(Map<String, dynamic> json) {
    adultsDosage = json['adults_dosage'];
    childrenDosage = json['children_dosage'];
    elderlyDosage = json['elderly_dosage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adults_dosage'] = this.adultsDosage;
    data['children_dosage'] = this.childrenDosage;
    data['elderly_dosage'] = this.elderlyDosage;
    return data;
  }
}

class SideEffects {
  List<String>? common;
  List<String>? serious;

  SideEffects({this.common, this.serious});

  SideEffects.fromJson(Map<String, dynamic> json) {
    common = json['common'].cast<String>();
    serious = json['serious'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['common'] = this.common;
    data['serious'] = this.serious;
    return data;
  }
}

class UploadedImage {
  String? filename;
  int? size;
  String? contentType;

  UploadedImage({this.filename, this.size, this.contentType});

  UploadedImage.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    size = json['size'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['size'] = this.size;
    data['content_type'] = this.contentType;
    return data;
  }
}

class AudioUrls {
  String? en;
  String? es;
  String? fr;
  String? pt;
  String? ht;
  String? zhCN;
  String? ru;

  AudioUrls({this.en, this.es, this.fr, this.pt, this.ht, this.zhCN, this.ru});

  AudioUrls.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    es = json['es'];
    fr = json['fr'];
    pt = json['pt'];
    ht = json['ht'];
    zhCN = json['zh-CN'];
    ru = json['ru'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['es'] = this.es;
    data['fr'] = this.fr;
    data['pt'] = this.pt;
    data['ht'] = this.ht;
    data['zh-CN'] = this.zhCN;
    data['ru'] = this.ru;
    return data;
  }
}

class AudioInstructions {
  String? getAudio;
  String? example;
  List<String>? languages;

  AudioInstructions({this.getAudio, this.example, this.languages});

  AudioInstructions.fromJson(Map<String, dynamic> json) {
    getAudio = json['get_audio'];
    example = json['example'];
    languages = json['languages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['get_audio'] = this.getAudio;
    data['example'] = this.example;
    data['languages'] = this.languages;
    return data;
  }
}
