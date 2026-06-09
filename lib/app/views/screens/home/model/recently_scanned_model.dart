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

class Medication {
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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AdditionalNote> additionalNotes;

  Medication({
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
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      originalImage: json['original_image']?.toString() ?? '',
      genericName: json['generic_name']?.toString() ?? '',
      brandName: json['brand_name']?.toString() ?? '',
      manufacturer: json['manufacturer']?.toString() ?? '',
      drugClass: json['drug_class']?.toString() ?? '',
      uses: json['uses']?.toString() ?? '',
      totPills: json['tot_pills']?.toString() ?? '',
      dosageInformation: DosageInformation.fromJson(
        json['dosage_information'] as Map<String, dynamic>? ?? {},
      ),
      howToTake: json['how_to_take']?.toString() ?? '',
      sideEffects: SideEffects.fromJson(
        json['side_effects'] as Map<String, dynamic>? ?? {},
      ),
      warnings: json['warnings']?.toString() ?? '',
      storageInstructions: json['storage_instructions']?.toString() ?? '',
      interactions: json['interactions']?.toString() ?? '',
      aiAdditionalNotes: json['ai_additional_notes']?.toString() ?? '',
      isActive: json['is_active'] == null ? false : (json['is_active'] as bool),
      createdAt: _tryParseDateTime(json['created_at']),
      updatedAt: _tryParseDateTime(json['updated_at']),
      additionalNotes:
          (json['additional_notes'] as List<dynamic>?)
              ?.map((e) => AdditionalNote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
    'dosage_information': dosageInformation.toJson(),
    'how_to_take': howToTake,
    'side_effects': sideEffects.toJson(),
    'warnings': warnings,
    'storage_instructions': storageInstructions,
    'interactions': interactions,
    'ai_additional_notes': aiAdditionalNotes,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'additional_notes': additionalNotes.map((e) => e.toJson()).toList(),
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
