import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/questionnaire_models.dart';

/// Questionnaire State
class QuestionnaireState {
  final QuestionnaireAnswer answer;
  final bool isLoading;
  final String? errorMessage;

  const QuestionnaireState({
    required this.answer,
    this.isLoading = false,
    this.errorMessage,
  });

  QuestionnaireState copyWith({
    QuestionnaireAnswer? answer,
    bool? isLoading,
    String? errorMessage,
  }) {
    return QuestionnaireState(
      answer: answer ?? this.answer,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Questionnaire Controller with Riverpod StateNotifier
class QuestionnaireController extends StateNotifier<QuestionnaireState> {
  QuestionnaireController() : super(QuestionnaireState(answer: const QuestionnaireAnswer())) {
    _loadDraft();
  }

  static const String _draftKey = 'quizDraft';

  /// Load saved draft from SharedPreferences
  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(_draftKey);
      
      if (draftJson != null) {
        final draftData = jsonDecode(draftJson) as Map<String, dynamic>;
        final answer = QuestionnaireAnswer.fromJson(draftData);
        state = state.copyWith(answer: answer);
      }
    } catch (e) {
      // Silently fail - start with empty form
      print('Error loading draft: $e');
    }
  }

  /// Save current state to SharedPreferences
  Future<void> _saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(state.answer.toJson());
      await prefs.setString(_draftKey, jsonString);
    } catch (e) {
      print('Error saving draft: $e');
    }
  }

  /// Update Step 1 fields
  void updateWhoFor(WhoFor? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(whoFor: value),
    );
    _saveDraft();
  }

  void updateCurrentGlasses(CurrentGlasses? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(currentGlasses: value),
    );
    _saveDraft();
  }

  void updateVisionNeed(VisionNeed? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(visionNeed: value),
    );
    _saveDraft();
  }

  void updatePowerStrength(PowerStrength? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(powerStrength: value),
    );
    _saveDraft();
  }

  /// Update Step 2 fields
  void updateScreenTimeHours(double? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(screenTimeHours: value),
    );
    _saveDraft();
  }

  void updateWorkSetting(WorkSetting? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(workSetting: value),
    );
    _saveDraft();
  }

  void updateReflectionBother(ReflectionBother? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(reflectionBother: value),
    );
    _saveDraft();
  }

  /// Update Step 3 fields
  void updateSunlightTime(SunlightTime? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(sunlightTime: value),
    );
    _saveDraft();
  }

  void updatePreferAutoOutdoor(PreferAutoOutdoor? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(preferAutoOutdoor: value),
    );
    _saveDraft();
  }

  void updateNightDriving(NightDriving? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(nightDriving: value),
    );
    _saveDraft();
  }

  void updateLightSensitivity(LightSensitivity? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(lightSensitivity: value),
    );
    _saveDraft();
  }

  /// Update Step 4 fields
  void updateActivities(Set<Activity>? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(activities: value),
    );
    _saveDraft();
  }

  void updateRoughUse(RoughUse? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(roughUse: value),
    );
    _saveDraft();
  }

  void updateLensWeightPref(LensWeightPref? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(lensWeightPref: value),
    );
    _saveDraft();
  }

  void updateHandling(Handling? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(handling: value),
    );
    _saveDraft();
  }

  /// Update Step 5 fields
  void updateComforts(Set<Comfort>? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(comforts: value),
    );
    _saveDraft();
  }

  void updateBudgetPKR(double? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(budgetPKR: value),
    );
    _saveDraft();
  }

  void updateAdditionalNotes(String? value) {
    state = state.copyWith(
      answer: state.answer.copyWith(additionalNotes: value),
    );
    _saveDraft();
  }

  /// Validation logic for each step
  bool isStepValid(int step) {
    switch (step) {
      case 1:
        return state.answer.whoFor != null &&
            state.answer.currentGlasses != null &&
            state.answer.visionNeed != null &&
            state.answer.powerStrength != null;
      case 2:
        return state.answer.screenTimeHours != null &&
            state.answer.workSetting != null &&
            state.answer.reflectionBother != null;
      case 3:
        return state.answer.sunlightTime != null &&
            state.answer.preferAutoOutdoor != null &&
            state.answer.nightDriving != null &&
            state.answer.lightSensitivity != null;
      case 4:
        return state.answer.activities != null &&
            state.answer.activities!.isNotEmpty &&
            state.answer.roughUse != null &&
            state.answer.lensWeightPref != null &&
            state.answer.handling != null;
      case 5:
        return state.answer.comforts != null &&
            state.answer.comforts!.isNotEmpty &&
            state.answer.budgetPKR != null;
      default:
        return false;
    }
  }

  /// Clear all data (for testing or reset)
  Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
      state = QuestionnaireState(answer: const QuestionnaireAnswer());
    } catch (e) {
      print('Error clearing draft: $e');
    }
  }

  /// Generate recommendation using local rule-based engine
  RecommendationData generateRecommendation() {
    final answer = state.answer;
    
    // Rule 1: Adaptive Day-Night Lenses
    if (answer.preferAutoOutdoor == PreferAutoOutdoor.yes ||
        answer.sunlightTime == SunlightTime.h2to4 ||
        answer.sunlightTime == SunlightTime.h4plus) {
      return RecommendationData(
        title: 'Adaptive Day–Night Lenses',
        blurb: 'These lenses are your perfect partner for daily life. They automatically adjust to light, darkening in the sun and clearing up indoors, so your vision is always comfortable and protected.',
        bullets: [
          'Seamlessly adapt to any light.',
          'Enjoy clear, glare-free vision.',
          'Block 100% of UV rays.',
        ],
        notice: [
          'All-day comfort',
          'Crisp, clear vision everywhere',
          'Effortless transitions outdoors',
          'Less squinting from night glare',
        ],
        goodToKnow: 'With proper care, these lenses typically last about 2 years.',
      );
    }

    // Rule 2: Anti-Reflective Lenses
    if ((answer.screenTimeHours ?? 0) >= 5 ||
        (answer.comforts?.contains(Comfort.reduceEyeStrain) ?? false)) {
      return RecommendationData(
        title: 'Anti-Reflective Lenses',
        blurb: 'Perfect for digital work and reducing eye strain. These lenses minimize reflections and glare, giving you clearer vision and less fatigue during long screen sessions.',
        bullets: [
          'Reduce eye strain from screens.',
          'Minimize reflections and glare.',
          'Improve night vision clarity.',
        ],
        notice: [
          'Less eye fatigue',
          'Clearer screen viewing',
          'Better night driving',
          'Reduced glare indoors',
        ],
        goodToKnow: 'These lenses are especially beneficial for computer work and night driving.',
      );
    }

    // Rule 3: Thin & Light Lenses
    if (answer.lensWeightPref == LensWeightPref.lightThin ||
        answer.powerStrength == PowerStrength.moderate ||
        answer.powerStrength == PowerStrength.strong) {
      return RecommendationData(
        title: 'Thin & Light Lenses',
        blurb: 'Ultra-thin and lightweight lenses that provide maximum comfort without compromising on clarity. Perfect for higher prescriptions and active lifestyles.',
        bullets: [
          'Ultra-thin profile.',
          'Lightweight comfort.',
          'Crystal clear vision.',
        ],
        notice: [
          'Comfortable all day',
          'Less lens thickness',
          'Modern appearance',
          'Easy to wear',
        ],
        goodToKnow: 'Thin lenses are ideal for higher prescriptions and active wear.',
      );
    }

    // Rule 4: Impact-Resistant Lenses
    if ((answer.roughUse != null && answer.roughUse != RoughUse.low) ||
        (answer.activities?.contains(Activity.sports) ?? false)) {
      return RecommendationData(
        title: 'Impact-Resistant Lenses',
        blurb: 'Durable and tough lenses designed for active lifestyles. These lenses resist impacts and scratches while maintaining excellent optical clarity.',
        bullets: [
          'Impact-resistant material.',
          'Scratch-resistant coating.',
          'Safe for active use.',
        ],
        notice: [
          'Durable construction',
          'Scratch protection',
          'Safe for sports',
          'Long-lasting clarity',
        ],
        goodToKnow: 'These lenses are perfect for sports, outdoor activities, and rough handling.',
      );
    }

    // Default recommendation
    return RecommendationData(
      title: 'Standard Clear Lenses',
      blurb: 'High-quality clear lenses that provide excellent vision correction with standard features. A reliable choice for everyday wear.',
      bullets: [
        'Crystal clear vision.',
        'Durable construction.',
        'Comfortable wear.',
      ],
      notice: [
        'Reliable performance',
        'Clear vision',
        'Comfortable fit',
        'Good value',
      ],
      goodToKnow: 'These lenses provide excellent vision correction for everyday use.',
    );
  }
}

/// Riverpod provider for the questionnaire controller
final questionnaireProvider = StateNotifierProvider<QuestionnaireController, QuestionnaireState>((ref) {
  return QuestionnaireController();
});

/// Convenience providers for specific state properties
final questionnaireAnswerProvider = Provider<QuestionnaireAnswer>((ref) {
  return ref.watch(questionnaireProvider).answer;
});

final questionnaireLoadingProvider = Provider<bool>((ref) {
  return ref.watch(questionnaireProvider).isLoading;
});

final questionnaireErrorProvider = Provider<String?>((ref) {
  return ref.watch(questionnaireProvider).errorMessage;
});
