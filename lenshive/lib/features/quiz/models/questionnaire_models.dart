/// Questionnaire Models for Lens Recommendation Feature
/// Contains all enums and data classes for the 5-step wizard

// Step 1 Enums
enum WhoFor { myself, childTeen, senior60 }

enum CurrentGlasses { yes, no, sometimes }

enum VisionNeed { farAway, upClose, bothEqually, notSure }

enum PowerStrength { unknown, mild, moderate, strong }

// Step 2 Enums
enum WorkSetting { mostlyOffice, mixedIndoorOutdoor, mostlyOutdoor, drivingCommuting, workshopLab }

enum ReflectionBother { never, sometimes, often }

// Step 3 Enums
enum SunlightTime { under30min, h30to120, h2to4, h4plus }

enum PreferAutoOutdoor { yes, no, notSure }

enum NightDriving { rare, h1to3, h4plus }

enum LightSensitivity { low, medium, high }

// Step 4 Enums
enum Activity { office, sports, construction, gaming, travel }

enum RoughUse { low, medium, high }

enum LensWeightPref { lightThin, standardThick }

enum Handling { careful, rough, childUse }

// Step 5 Enums
enum Comfort { reduceEyeStrain, reduceGlare, stayClearOutdoors, resistScratches, veryLightweight }

/// Main questionnaire answer data class
class QuestionnaireAnswer {
  // Step 1 fields
  final WhoFor? whoFor;
  final CurrentGlasses? currentGlasses;
  final VisionNeed? visionNeed;
  final PowerStrength? powerStrength;

  // Step 2 fields
  final double? screenTimeHours;
  final WorkSetting? workSetting;
  final ReflectionBother? reflectionBother;

  // Step 3 fields
  final SunlightTime? sunlightTime;
  final PreferAutoOutdoor? preferAutoOutdoor;
  final NightDriving? nightDriving;
  final LightSensitivity? lightSensitivity;

  // Step 4 fields
  final Set<Activity>? activities;
  final RoughUse? roughUse;
  final LensWeightPref? lensWeightPref;
  final Handling? handling;

  // Step 5 fields
  final Set<Comfort>? comforts;
  final double? budgetPKR;
  final String? additionalNotes;

  const QuestionnaireAnswer({
    this.whoFor,
    this.currentGlasses,
    this.visionNeed,
    this.powerStrength,
    this.screenTimeHours,
    this.workSetting,
    this.reflectionBother,
    this.sunlightTime,
    this.preferAutoOutdoor,
    this.nightDriving,
    this.lightSensitivity,
    this.activities,
    this.roughUse,
    this.lensWeightPref,
    this.handling,
    this.comforts,
    this.budgetPKR,
    this.additionalNotes,
  });

  /// Create a copy with updated fields
  QuestionnaireAnswer copyWith({
    WhoFor? whoFor,
    CurrentGlasses? currentGlasses,
    VisionNeed? visionNeed,
    PowerStrength? powerStrength,
    double? screenTimeHours,
    WorkSetting? workSetting,
    ReflectionBother? reflectionBother,
    SunlightTime? sunlightTime,
    PreferAutoOutdoor? preferAutoOutdoor,
    NightDriving? nightDriving,
    LightSensitivity? lightSensitivity,
    Set<Activity>? activities,
    RoughUse? roughUse,
    LensWeightPref? lensWeightPref,
    Handling? handling,
    Set<Comfort>? comforts,
    double? budgetPKR,
    String? additionalNotes,
  }) {
    return QuestionnaireAnswer(
      whoFor: whoFor ?? this.whoFor,
      currentGlasses: currentGlasses ?? this.currentGlasses,
      visionNeed: visionNeed ?? this.visionNeed,
      powerStrength: powerStrength ?? this.powerStrength,
      screenTimeHours: screenTimeHours ?? this.screenTimeHours,
      workSetting: workSetting ?? this.workSetting,
      reflectionBother: reflectionBother ?? this.reflectionBother,
      sunlightTime: sunlightTime ?? this.sunlightTime,
      preferAutoOutdoor: preferAutoOutdoor ?? this.preferAutoOutdoor,
      nightDriving: nightDriving ?? this.nightDriving,
      lightSensitivity: lightSensitivity ?? this.lightSensitivity,
      activities: activities ?? this.activities,
      roughUse: roughUse ?? this.roughUse,
      lensWeightPref: lensWeightPref ?? this.lensWeightPref,
      handling: handling ?? this.handling,
      comforts: comforts ?? this.comforts,
      budgetPKR: budgetPKR ?? this.budgetPKR,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }

  /// Convert to JSON for API calls and persistence
  Map<String, dynamic> toJson() {
    return {
      'whoFor': whoFor?.name,
      'currentGlasses': currentGlasses?.name,
      'visionNeed': visionNeed?.name,
      'powerStrength': powerStrength?.name,
      'screenTimeHours': screenTimeHours,
      'workSetting': workSetting?.name,
      'reflectionBother': reflectionBother?.name,
      'sunlightTime': sunlightTime?.name,
      'preferAutoOutdoor': preferAutoOutdoor?.name,
      'nightDriving': nightDriving?.name,
      'lightSensitivity': lightSensitivity?.name,
      'activities': activities?.map((e) => e.name).toList(),
      'roughUse': roughUse?.name,
      'lensWeightPref': lensWeightPref?.name,
      'handling': handling?.name,
      'comforts': comforts?.map((e) => e.name).toList(),
      'budgetPKR': budgetPKR,
      'additionalNotes': additionalNotes,
    };
  }

  /// Create from JSON
  factory QuestionnaireAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionnaireAnswer(
      whoFor: json['whoFor'] != null ? WhoFor.values.byName(json['whoFor']) : null,
      currentGlasses: json['currentGlasses'] != null ? CurrentGlasses.values.byName(json['currentGlasses']) : null,
      visionNeed: json['visionNeed'] != null ? VisionNeed.values.byName(json['visionNeed']) : null,
      powerStrength: json['powerStrength'] != null ? PowerStrength.values.byName(json['powerStrength']) : null,
      screenTimeHours: json['screenTimeHours']?.toDouble(),
      workSetting: json['workSetting'] != null ? WorkSetting.values.byName(json['workSetting']) : null,
      reflectionBother: json['reflectionBother'] != null ? ReflectionBother.values.byName(json['reflectionBother']) : null,
      sunlightTime: json['sunlightTime'] != null ? SunlightTime.values.byName(json['sunlightTime']) : null,
      preferAutoOutdoor: json['preferAutoOutdoor'] != null ? PreferAutoOutdoor.values.byName(json['preferAutoOutdoor']) : null,
      nightDriving: json['nightDriving'] != null ? NightDriving.values.byName(json['nightDriving']) : null,
      lightSensitivity: json['lightSensitivity'] != null ? LightSensitivity.values.byName(json['lightSensitivity']) : null,
      activities: json['activities'] != null ? (json['activities'] as List).map((e) => Activity.values.byName(e)).toSet() : null,
      roughUse: json['roughUse'] != null ? RoughUse.values.byName(json['roughUse']) : null,
      lensWeightPref: json['lensWeightPref'] != null ? LensWeightPref.values.byName(json['lensWeightPref']) : null,
      handling: json['handling'] != null ? Handling.values.byName(json['handling']) : null,
      comforts: json['comforts'] != null ? (json['comforts'] as List).map((e) => Comfort.values.byName(e)).toSet() : null,
      budgetPKR: json['budgetPKR']?.toDouble(),
      additionalNotes: json['additionalNotes'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionnaireAnswer &&
        other.whoFor == whoFor &&
        other.currentGlasses == currentGlasses &&
        other.visionNeed == visionNeed &&
        other.powerStrength == powerStrength &&
        other.screenTimeHours == screenTimeHours &&
        other.workSetting == workSetting &&
        other.reflectionBother == reflectionBother &&
        other.sunlightTime == sunlightTime &&
        other.preferAutoOutdoor == preferAutoOutdoor &&
        other.nightDriving == nightDriving &&
        other.lightSensitivity == lightSensitivity &&
        other.activities == activities &&
        other.roughUse == roughUse &&
        other.lensWeightPref == lensWeightPref &&
        other.handling == handling &&
        other.comforts == comforts &&
        other.budgetPKR == budgetPKR &&
        other.additionalNotes == additionalNotes;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      whoFor,
      currentGlasses,
      visionNeed,
      powerStrength,
      screenTimeHours,
      workSetting,
      reflectionBother,
      sunlightTime,
      preferAutoOutdoor,
      nightDriving,
      lightSensitivity,
      activities,
      roughUse,
      lensWeightPref,
      handling,
      comforts,
      budgetPKR,
      additionalNotes,
    ]);
  }
}

/// Recommendation data structure returned by the recommendation engine
class RecommendationData {
  final String title;
  final String blurb;
  final List<String> bullets;
  final List<String> notice;
  final String goodToKnow;

  const RecommendationData({
    required this.title,
    required this.blurb,
    required this.bullets,
    required this.notice,
    required this.goodToKnow,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      title: json['title'] ?? '',
      blurb: json['blurb'] ?? '',
      bullets: List<String>.from(json['bullets'] ?? []),
      notice: List<String>.from(json['notice'] ?? []),
      goodToKnow: json['goodToKnow'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'blurb': blurb,
      'bullets': bullets,
      'notice': notice,
      'goodToKnow': goodToKnow,
    };
  }
}
