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

// lib/app/views/screens/medications/controler/model/medication_api_model.dart

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

  // 🔍 সব ভাষার ফিল্ড খুঁজে বের করার হেলপার
  String? _findField(Map<String, dynamic> json, List<String> possibleKeys) {
    for (var key in possibleKeys) {
      if (json.containsKey(key) && json[key] != null && json[key].toString().isNotEmpty) {
        return json[key].toString();
      }
    }
    return null;
  }

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    // 🌍 ট্রান্সলেটেড ফিল্ড খুঁজে বের করা
    originalImage = _findField(json, [
      'original_image', 'imagen_original', 'image_originale',
      'imagem_original', 'imaj_orijinal', 'исходное_изображение',
      '原始图像'
    ]);

    genericName = _findField(json, [
      'generic_name', 'nombre_generico', 'nom_generique',
      'nome_generico', 'non_jenerik', 'генерическое_название',
      '通用名', 'genericName'
    ]);

    brandName = _findField(json, [
      'brand_name', 'nombre_marca', 'nom_marque',
      'nome_marca', 'non_mak', 'торговое_название',
      '品牌名称', 'brandName'
    ]);

    manufacturer = _findField(json, [
      'manufacturer', 'fabricante', 'fabricant',
      'fabricante', 'fabrikant', 'производитель',
      '制造商'
    ]);

    drugClass = _findField(json, [
      'drug_class', 'clase_medicamento', 'classe_medicament',
      'classe_medicamento', 'klas_medikaman', 'класс_препарата',
      '药物类别'
    ]);

    uses = _findField(json, [
      'uses', 'usos', 'utilisations',
      'usos', 'itilizasyon', 'применение',
      '用途'
    ]);

    totPills = _findField(json, [
      'tot_pills', 'total_pastillas', 'total_comprimes',
      'total_pilulas', 'total_gelil', 'всего_таблеток',
      '总药片'
    ]);

    howToTake = _findField(json, [
      'how_to_take', 'como_tomar', 'comment_prendre',
      'como_tomar', 'kijan_pou_pran', 'как_принимать',
      '如何服用'
    ]);

    warnings = _findField(json, [
      'warnings', 'advertencias', 'avertissements',
      'avisos', 'avis', 'предупреждения',
      '警告'
    ]);

    storageInstructions = _findField(json, [
      'storage_instructions', 'instrucciones_almacenamiento', 'instructions_stockage',
      'instrucoes_armazenamento', 'enstriksyon_stokaj', 'инструкции_хранению',
      '存储说明'
    ]);

    interactions = _findField(json, [
      'interactions', 'interacciones', 'interactions',
      'interacoes', 'entèraksyon', 'взаимодействия',
      '相互作用'
    ]);

    // Dosage Information
    if (json['dosage_information'] != null) {
      dosageInformation = DosageInformation.fromJson(json['dosage_information']);
    } else if (json['informacion_dosificacion'] != null) {
      dosageInformation = DosageInformation.fromJson(json['informacion_dosificacion']);
    } else if (json['information_dosage'] != null) {
      dosageInformation = DosageInformation.fromJson(json['information_dosage']);
    } else if (json['informacao_dosagem'] != null) {
      dosageInformation = DosageInformation.fromJson(json['informacao_dosagem']);
    } else if (json['enfomason_dosaj'] != null) {
      dosageInformation = DosageInformation.fromJson(json['enfomason_dosaj']);
    } else if (json['информация_дозировки'] != null) {
      dosageInformation = DosageInformation.fromJson(json['информация_дозировки']);
    } else if (json['给药信息'] != null) {
      dosageInformation = DosageInformation.fromJson(json['给药信息']);
    }

    // Side Effects
    if (json['side_effects'] != null) {
      sideEffects = SideEffects.fromJson(json['side_effects']);
    } else if (json['efectos_secundarios'] != null) {
      sideEffects = SideEffects.fromJson(json['efectos_secundarios']);
    } else if (json['effets_secondaires'] != null) {
      sideEffects = SideEffects.fromJson(json['effets_secondaires']);
    } else if (json['efeitos_colaterais'] != null) {
      sideEffects = SideEffects.fromJson(json['efeitos_colaterais']);
    } else if (json['efet_segondè'] != null) {
      sideEffects = SideEffects.fromJson(json['efet_segondè']);
    } else if (json['побочные_эффекты'] != null) {
      sideEffects = SideEffects.fromJson(json['побочные_эффекты']);
    } else if (json['副作用'] != null) {
      sideEffects = SideEffects.fromJson(json['副作用']);
    }

    aiAdditionalNotes = json['ai_additional_notes'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['additional_notes'] != null) {
      additionalNotes = <AdditionalNotes>[];
      json['additional_notes'].forEach((v) {
        additionalNotes!.add(AdditionalNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['original_image'] = originalImage;
    data['generic_name'] = genericName;
    data['brand_name'] = brandName;
    data['manufacturer'] = manufacturer;
    data['drug_class'] = drugClass;
    data['uses'] = uses;
    data['tot_pills'] = totPills;
    if (dosageInformation != null) {
      data['dosage_information'] = dosageInformation!.toJson();
    }
    data['how_to_take'] = howToTake;
    if (sideEffects != null) {
      data['side_effects'] = sideEffects!.toJson();
    }
    data['warnings'] = warnings;
    data['storage_instructions'] = storageInstructions;
    data['interactions'] = interactions;
    data['ai_additional_notes'] = aiAdditionalNotes;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (additionalNotes != null) {
      data['additional_notes'] = additionalNotes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// DosageInformation and SideEffects classes also need translation support
class DosageInformation {
  String? adultsDosage;
  String? childrenDosage;
  String? elderlyDosage;

  DosageInformation({this.adultsDosage, this.childrenDosage, this.elderlyDosage});

  DosageInformation.fromJson(Map<String, dynamic> json) {
    adultsDosage = json['adults_dosage'] ??
        json['dosificacion_adultos'] ??
        json['dosage_adultes'] ??
        json['dosagem_adultos'] ??
        json['dosaj_granmoun'] ??
        json['дозировка_взрослых'] ??
        json['成人用量'];

    childrenDosage = json['children_dosage'] ??
        json['dosificacion_ninos'] ??
        json['dosage_enfants'] ??
        json['dosagem_criancas'] ??
        json['dosaj_timoun'] ??
        json['дозировка_детей'] ??
        json['儿童用量'];

    elderlyDosage = json['elderly_dosage'] ??
        json['dosificacion_ancianos'] ??
        json['dosage_personnes_agees'] ??
        json['dosagem_idosos'] ??
        json['dosaj_moun_vye'] ??
        json['дозировка_пожилых'] ??
        json['老年人用量'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adults_dosage'] = adultsDosage;
    data['children_dosage'] = childrenDosage;
    data['elderly_dosage'] = elderlyDosage;
    return data;
  }
}

class SideEffects {
  String? common;
  String? serious;

  SideEffects({this.common, this.serious});

  SideEffects.fromJson(Map<String, dynamic> json) {
    common = json['common'] ??
        json['comunes'] ??
        json['courants'] ??
        json['comuns'] ??
        json['ordinè'] ??
        json['частые'] ??
        json['常见'];

    serious = json['serious'] ??
        json['graves'] ??
        json['graves'] ??
        json['graves'] ??
        json['grav'] ??
        json['серьезные'] ??
        json['严重'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['common'] = common;
    data['serious'] = serious;
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
