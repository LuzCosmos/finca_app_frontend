import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';


enum CattleGender {
  MALE,
  FEMALE;

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case CattleGender.MALE:
        return l10n.genderMale;
      case CattleGender.FEMALE:
        return l10n.genderFemale;
    }
  }

  static CattleGender fromString(String value) {
    return CattleGender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CattleGender.MALE,
    );
  }
}

enum CattleStatusEnum {
  ACTIVE,
  SOLD,
  DEAD,
  LOST;

  static List<String> getStatusList() {
    return ["ACTIVE", "SOLD", "DEAD", "LOST"];
  }

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case CattleStatusEnum.ACTIVE:
        return l10n.statusActive;
      case CattleStatusEnum.DEAD:
        return l10n.statusDead;
      case CattleStatusEnum.SOLD:
        return l10n.statusSold;
      case CattleStatusEnum.LOST:
        return l10n.statusLost;
    }
  }

  static CattleStatusEnum fromString(String value) {
    return CattleStatusEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CattleStatusEnum.ACTIVE,
    );
  }
}

enum CattleColor {
  BLACK,
  WHITE,
  BROWN,
  BLACK_BROWN,
  LIGHT_BROWN,
  GREY;

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case CattleColor.BLACK:
        return l10n.colorBlack;
      case CattleColor.WHITE:
        return l10n.colorWhite;
      case CattleColor.BROWN:
        return l10n.colorBrown;
      case CattleColor.BLACK_BROWN:
        return l10n.colorBlackBrown;
      case CattleColor.LIGHT_BROWN:
        return l10n.colorLightBrown;
      case CattleColor.GREY:
        return l10n.colorGrey;
    }
  }

  static CattleColor fromString(String value) {
    return CattleColor.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CattleColor.WHITE,
    );
  }
}

enum CattleCharacteristic {
  BLACK_BELLY,
  WHITE_BELLY,
  BROWN_BELLY,
  LIGHT_BROWN_BELLY,
  GREY_BELLY,
  BLACK_HEAD,
  WHITE_HEAD,
  BROWN_HEAD,
  LIGHT_BROWN_HEAD,
  GREY_HEAD,
  BLACK_HALF_HEAD,
  WHITE_HALF_HEAD,
  BROWN_HALF_HEAD,
  LIGHT_BROWN_HALF_HEAD,
  GREY_HALF_HEAD,
  BLACK_LEGS,
  WHITE_LEGS,
  BROWN_LEGS,
  LIGHT_BROWN_LEGS,
  GREY_LEGS,
  BLACK_FEET,
  WHITE_FEET,
  BROWN_FEET,
  LIGHT_BROWN_FEET,
  GREY_FEET,
  BLACK_SPOTS,
  BROWN_SPOTS,
  LIGHT_BROWN_SPOTS,
  GREY_SPOTS,
  BLACK_PATTERN,
  BROWN_PATTERN;

  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case CattleCharacteristic.BLACK_BELLY: return l10n.charBlackBelly;
      case CattleCharacteristic.WHITE_BELLY: return l10n.charWhiteBelly;
      case CattleCharacteristic.BROWN_BELLY: return l10n.charBrownBelly;
      case CattleCharacteristic.LIGHT_BROWN_BELLY: return l10n.charLightBrownBelly;
      case CattleCharacteristic.GREY_BELLY: return l10n.charGreyBelly;
      case CattleCharacteristic.BLACK_HEAD: return l10n.charBlackHead;
      case CattleCharacteristic.WHITE_HEAD: return l10n.charWhiteHead;
      case CattleCharacteristic.BROWN_HEAD: return l10n.charBrownHead;
      case CattleCharacteristic.LIGHT_BROWN_HEAD: return l10n.charLightBrownHead;
      case CattleCharacteristic.GREY_HEAD: return l10n.charGreyHead;
      case CattleCharacteristic.BLACK_HALF_HEAD: return l10n.charBlackHalfHead;
      case CattleCharacteristic.WHITE_HALF_HEAD: return l10n.charWhiteHalfHead;
      case CattleCharacteristic.BROWN_HALF_HEAD: return l10n.charBrownHalfHead;
      case CattleCharacteristic.LIGHT_BROWN_HALF_HEAD: return l10n.charLightBrownHalfHead;
      case CattleCharacteristic.GREY_HALF_HEAD: return l10n.charGreyHalfHead;
      case CattleCharacteristic.BLACK_LEGS: return l10n.charBlackLegs;
      case CattleCharacteristic.WHITE_LEGS: return l10n.charWhiteLegs;
      case CattleCharacteristic.BROWN_LEGS: return l10n.charBrownLegs;
      case CattleCharacteristic.LIGHT_BROWN_LEGS: return l10n.charLightBrownLegs;
      case CattleCharacteristic.GREY_LEGS: return l10n.charGreyLegs;
      case CattleCharacteristic.BLACK_FEET: return l10n.charBlackFeet;
      case CattleCharacteristic.WHITE_FEET: return l10n.charWhiteFeet;
      case CattleCharacteristic.BROWN_FEET: return l10n.charBrownFeet;
      case CattleCharacteristic.LIGHT_BROWN_FEET: return l10n.charLightBrownFeet;
      case CattleCharacteristic.GREY_FEET: return l10n.charGreyFeet;
      case CattleCharacteristic.BLACK_SPOTS: return l10n.charBlackSpots;
      case CattleCharacteristic.BROWN_SPOTS: return l10n.charBrownSpots;
      case CattleCharacteristic.LIGHT_BROWN_SPOTS: return l10n.charLightBrownSpots;
      case CattleCharacteristic.GREY_SPOTS: return l10n.charGreySpots;
      case CattleCharacteristic.BLACK_PATTERN: return l10n.charBlackPattern;
      case CattleCharacteristic.BROWN_PATTERN: return l10n.charBrownPattern;
    }
  }

  static CattleCharacteristic? fromString(String value) {
    try {
      return CattleCharacteristic.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}
