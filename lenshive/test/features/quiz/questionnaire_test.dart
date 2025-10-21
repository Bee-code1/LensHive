import 'package:flutter_test/flutter_test.dart';
import 'package:lenshive/features/quiz/models/questionnaire_models.dart';
import 'package:lenshive/features/quiz/state/questionnaire_controller.dart';

void main() {
  // Initialize Flutter binding for SharedPreferences
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('QuestionnaireAnswer JSON Serialization', () {
    test('should serialize and deserialize correctly', () {
      // Arrange
      final originalAnswer = QuestionnaireAnswer(
        whoFor: WhoFor.myself,
        currentGlasses: CurrentGlasses.yes,
        visionNeed: VisionNeed.bothEqually,
        powerStrength: PowerStrength.moderate,
        screenTimeHours: 6.5,
        workSetting: WorkSetting.mixedIndoorOutdoor,
        reflectionBother: ReflectionBother.sometimes,
        sunlightTime: SunlightTime.h2to4,
        preferAutoOutdoor: PreferAutoOutdoor.yes,
        nightDriving: NightDriving.h1to3,
        lightSensitivity: LightSensitivity.medium,
        activities: {Activity.office, Activity.sports},
        roughUse: RoughUse.medium,
        lensWeightPref: LensWeightPref.lightThin,
        handling: Handling.careful,
        comforts: {Comfort.reduceEyeStrain, Comfort.reduceGlare},
        budgetPKR: 15000,
        additionalNotes: 'Test notes',
      );

      // Act
      final json = originalAnswer.toJson();
      final deserializedAnswer = QuestionnaireAnswer.fromJson(json);

      // Assert
      expect(deserializedAnswer.whoFor, equals(originalAnswer.whoFor));
      expect(deserializedAnswer.currentGlasses, equals(originalAnswer.currentGlasses));
      expect(deserializedAnswer.visionNeed, equals(originalAnswer.visionNeed));
      expect(deserializedAnswer.powerStrength, equals(originalAnswer.powerStrength));
      expect(deserializedAnswer.screenTimeHours, equals(originalAnswer.screenTimeHours));
      expect(deserializedAnswer.workSetting, equals(originalAnswer.workSetting));
      expect(deserializedAnswer.reflectionBother, equals(originalAnswer.reflectionBother));
      expect(deserializedAnswer.sunlightTime, equals(originalAnswer.sunlightTime));
      expect(deserializedAnswer.preferAutoOutdoor, equals(originalAnswer.preferAutoOutdoor));
      expect(deserializedAnswer.nightDriving, equals(originalAnswer.nightDriving));
      expect(deserializedAnswer.lightSensitivity, equals(originalAnswer.lightSensitivity));
      expect(deserializedAnswer.activities, equals(originalAnswer.activities));
      expect(deserializedAnswer.roughUse, equals(originalAnswer.roughUse));
      expect(deserializedAnswer.lensWeightPref, equals(originalAnswer.lensWeightPref));
      expect(deserializedAnswer.handling, equals(originalAnswer.handling));
      expect(deserializedAnswer.comforts, equals(originalAnswer.comforts));
      expect(deserializedAnswer.budgetPKR, equals(originalAnswer.budgetPKR));
      expect(deserializedAnswer.additionalNotes, equals(originalAnswer.additionalNotes));
    });

    test('should handle null values correctly', () {
      // Arrange
      final originalAnswer = QuestionnaireAnswer();

      // Act
      final json = originalAnswer.toJson();
      final deserializedAnswer = QuestionnaireAnswer.fromJson(json);

      // Assert
      expect(deserializedAnswer.whoFor, isNull);
      expect(deserializedAnswer.currentGlasses, isNull);
      expect(deserializedAnswer.visionNeed, isNull);
      expect(deserializedAnswer.powerStrength, isNull);
      expect(deserializedAnswer.screenTimeHours, isNull);
      expect(deserializedAnswer.workSetting, isNull);
      expect(deserializedAnswer.reflectionBother, isNull);
      expect(deserializedAnswer.sunlightTime, isNull);
      expect(deserializedAnswer.preferAutoOutdoor, isNull);
      expect(deserializedAnswer.nightDriving, isNull);
      expect(deserializedAnswer.lightSensitivity, isNull);
      expect(deserializedAnswer.activities, isNull);
      expect(deserializedAnswer.roughUse, isNull);
      expect(deserializedAnswer.lensWeightPref, isNull);
      expect(deserializedAnswer.handling, isNull);
      expect(deserializedAnswer.comforts, isNull);
      expect(deserializedAnswer.budgetPKR, isNull);
      expect(deserializedAnswer.additionalNotes, isNull);
    });

    test('should handle empty sets correctly', () {
      // Arrange
      final originalAnswer = QuestionnaireAnswer(
        activities: <Activity>{},
        comforts: <Comfort>{},
      );

      // Act
      final json = originalAnswer.toJson();
      final deserializedAnswer = QuestionnaireAnswer.fromJson(json);

      // Assert
      expect(deserializedAnswer.activities, isEmpty);
      expect(deserializedAnswer.comforts, isEmpty);
    });
  });

  group('QuestionnaireController Recommendation Engine', () {
    late QuestionnaireController controller;

    setUp(() {
      controller = QuestionnaireController();
    });

    test('should recommend Adaptive Day-Night Lenses for outdoor preference', () {
      // Arrange
      controller.updatePreferAutoOutdoor(PreferAutoOutdoor.yes);

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Adaptive Day–Night Lenses'));
      expect(recommendation.bullets, contains('Seamlessly adapt to any light.'));
    });

    test('should recommend Adaptive Day-Night Lenses for high sunlight exposure', () {
      // Arrange
      controller.updateSunlightTime(SunlightTime.h4plus);

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Adaptive Day–Night Lenses'));
      expect(recommendation.bullets, contains('Seamlessly adapt to any light.'));
    });

    test('should recommend Anti-Reflective Lenses for high screen time', () {
      // Arrange
      controller.updateScreenTimeHours(6.0);

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Anti-Reflective Lenses'));
      expect(recommendation.bullets, contains('Reduce eye strain from screens.'));
    });

    test('should recommend Anti-Reflective Lenses for eye strain comfort', () {
      // Arrange
      controller.updateComforts({Comfort.reduceEyeStrain});

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Anti-Reflective Lenses'));
      expect(recommendation.bullets, contains('Reduce eye strain from screens.'));
    });

    test('should recommend Thin & Light Lenses for light weight preference', () {
      // Arrange
      controller.updateLensWeightPref(LensWeightPref.lightThin);

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Thin & Light Lenses'));
      expect(recommendation.bullets, contains('Ultra-thin profile.'));
    });

    test('should recommend Thin & Light Lenses for moderate power strength', () {
      // Arrange
      controller.updatePowerStrength(PowerStrength.moderate);

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Thin & Light Lenses'));
      expect(recommendation.bullets, contains('Ultra-thin profile.'));
    });

    test('should recommend Impact-Resistant Lenses for rough use', () {
      // Arrange
      controller.updateRoughUse(RoughUse.high);

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Impact-Resistant Lenses'));
      expect(recommendation.bullets, contains('Impact-resistant material.'));
    });

    test('should recommend Impact-Resistant Lenses for sports activities', () {
      // Arrange
      controller.updateActivities({Activity.sports});

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Impact-Resistant Lenses'));
      expect(recommendation.bullets, contains('Impact-resistant material.'));
    });

    test('should recommend Standard Clear Lenses as default', () {
      // Arrange - no specific preferences set

      // Act
      final recommendation = controller.generateRecommendation();

      // Assert
      expect(recommendation.title, equals('Standard Clear Lenses'));
      expect(recommendation.bullets, contains('Crystal clear vision.'));
    });
  });

  group('QuestionnaireController Step Validation', () {
    late QuestionnaireController controller;

    setUp(() {
      controller = QuestionnaireController();
    });

    test('should validate step 1 correctly', () {
      // Arrange - empty state
      expect(controller.isStepValid(1), isFalse);

      // Act - fill step 1
      controller.updateWhoFor(WhoFor.myself);
      controller.updateCurrentGlasses(CurrentGlasses.yes);
      controller.updateVisionNeed(VisionNeed.bothEqually);
      controller.updatePowerStrength(PowerStrength.moderate);

      // Assert
      expect(controller.isStepValid(1), isTrue);
    });

    test('should validate step 2 correctly', () {
      // Arrange - empty state
      expect(controller.isStepValid(2), isFalse);

      // Act - fill step 2
      controller.updateScreenTimeHours(6.0);
      controller.updateWorkSetting(WorkSetting.mixedIndoorOutdoor);
      controller.updateReflectionBother(ReflectionBother.sometimes);

      // Assert
      expect(controller.isStepValid(2), isTrue);
    });

    test('should validate step 3 correctly', () {
      // Arrange - empty state
      expect(controller.isStepValid(3), isFalse);

      // Act - fill step 3
      controller.updateSunlightTime(SunlightTime.h2to4);
      controller.updatePreferAutoOutdoor(PreferAutoOutdoor.yes);
      controller.updateNightDriving(NightDriving.h1to3);
      controller.updateLightSensitivity(LightSensitivity.medium);

      // Assert
      expect(controller.isStepValid(3), isTrue);
    });

    test('should validate step 4 correctly', () {
      // Arrange - empty state
      expect(controller.isStepValid(4), isFalse);

      // Act - fill step 4
      controller.updateActivities({Activity.office});
      controller.updateRoughUse(RoughUse.medium);
      controller.updateLensWeightPref(LensWeightPref.lightThin);
      controller.updateHandling(Handling.careful);

      // Assert
      expect(controller.isStepValid(4), isTrue);
    });

    test('should validate step 5 correctly', () {
      // Arrange - empty state
      expect(controller.isStepValid(5), isFalse);

      // Act - fill step 5
      controller.updateComforts({Comfort.reduceEyeStrain});
      controller.updateBudgetPKR(15000);

      // Assert
      expect(controller.isStepValid(5), isTrue);
    });
  });
}
