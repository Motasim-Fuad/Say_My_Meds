class MedicationApiModel {
  List<Results>? results;
  String? language;

  MedicationApiModel({this.results, this.language});

  MedicationApiModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['language'] = this.language;
    return data;
  }
}

class Results {
  int? id;
  String? originalImage;
  String? genericName;
  String? brandName;
  String? manufacturer;
  String? drugClass;
  String? uses;
  String? totPills;
  DosageInformation? dosageInformation;
  String? howToTake;
  SideEffects? sideEffects;
  String? warnings;
  String? storageInstructions;
  String? interactions;
  String? aiAdditionalNotes;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  List<AdditionalNotes>? additionalNotes;

  Results({
    this.id,
    this.originalImage,
    this.genericName,
    this.brandName,
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

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    originalImage = json['original_image'];
    genericName = json['generic_name'];
    brandName = json['brand_name'];
    manufacturer = json['manufacturer'];
    drugClass = json['drug_class'];
    uses = json['uses'];
    totPills = json['tot_pills'];
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
    aiAdditionalNotes = json['ai_additional_notes'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['additional_notes'] != null) {
      additionalNotes = <AdditionalNotes>[];
      json['additional_notes'].forEach((v) {
        additionalNotes!.add(new AdditionalNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['original_image'] = this.originalImage;
    data['generic_name'] = this.genericName;
    data['brand_name'] = this.brandName;
    data['manufacturer'] = this.manufacturer;
    data['drug_class'] = this.drugClass;
    data['uses'] = this.uses;
    data['tot_pills'] = this.totPills;
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
    data['ai_additional_notes'] = this.aiAdditionalNotes;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.additionalNotes != null) {
      data['additional_notes'] = this.additionalNotes!
          .map((v) => v.toJson())
          .toList();
    }
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
  String? common;
  String? serious;

  SideEffects({this.common, this.serious});

  SideEffects.fromJson(Map<String, dynamic> json) {
    common = json['common'];
    serious = json['serious'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['common'] = this.common;
    data['serious'] = this.serious;
    return data;
  }
}

class AdditionalNotes {
  int? id;
  int? medication;
  int? user;
  String? note;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  AdditionalNotes({
    this.id,
    this.medication,
    this.user,
    this.note,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  AdditionalNotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    medication = json['medication'];
    user = json['user'];
    note = json['note'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['medication'] = this.medication;
    data['user'] = this.user;
    data['note'] = this.note;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
