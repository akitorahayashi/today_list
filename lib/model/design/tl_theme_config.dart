import 'package:flutter/material.dart';

/// テーマの構成情報を管理するクラス
class TLThemeConfig {
  // Theme Name
  final String themeName;
  final String themeTitleInSettings;

  // Settings Page
  final Color navigationTitleColor;
  final Color settingPanelColor;
  final Color titleColorOfSettingPage;
  // other apps
  final Color otherAppsElevatedButtonColor;
  final Color otherAppsPressedElevatedButtonColor;

  // Home Page
  final Color backgroundColor;

  // Navigation Bar
  final Gradient gradientOfNavBar;

  // Basics
  final Color accentColor; // デフォルトのアクセントカラー
  final Color canTapCardColor;
  final Color whiteBasedColor;
  final Color tlDoubleCardBorderColor;

  // Alert
  final Color alertBackgroundColor;

  // Category List
  final Color bigCategoryChipColor;

  // Edit Page
  final Color toggleButtonsBackgroundColor;
  final Color toggleButtonsBackgroundSplashColor;

  const TLThemeConfig({
    // Theme Name
    required this.themeName,
    required this.themeTitleInSettings,

    // Settings Page
    required this.navigationTitleColor,
    required this.settingPanelColor,
    required this.titleColorOfSettingPage,
    // Home Page
    required this.backgroundColor,

    // Navigation Bar
    required this.gradientOfNavBar,

    // Other Apps
    required this.otherAppsElevatedButtonColor,
    required this.otherAppsPressedElevatedButtonColor,

    // Basics
    required this.accentColor,
    required this.canTapCardColor,
    required this.whiteBasedColor,
    required this.tlDoubleCardBorderColor,

    // Alert
    required this.alertBackgroundColor,

    // Category List
    required this.bigCategoryChipColor,

    // Edit Page
    required this.toggleButtonsBackgroundColor,
    required this.toggleButtonsBackgroundSplashColor,
  });

  // カスタムアクセントカラーを設定した新しいインスタンスを作成
  TLThemeConfig copyWithCustomAccentColor(Color customAccentColor) {
    return TLThemeConfig(
      themeName: themeName,
      themeTitleInSettings: themeTitleInSettings,
      navigationTitleColor: navigationTitleColor,
      settingPanelColor: settingPanelColor,
      titleColorOfSettingPage: titleColorOfSettingPage,
      backgroundColor: backgroundColor,
      gradientOfNavBar: gradientOfNavBar,
      otherAppsElevatedButtonColor: otherAppsElevatedButtonColor,
      otherAppsPressedElevatedButtonColor: otherAppsPressedElevatedButtonColor,
      accentColor: accentColor,
      canTapCardColor: canTapCardColor,
      whiteBasedColor: whiteBasedColor,
      tlDoubleCardBorderColor: tlDoubleCardBorderColor,
      alertBackgroundColor: alertBackgroundColor,
      bigCategoryChipColor: bigCategoryChipColor,
      toggleButtonsBackgroundColor: toggleButtonsBackgroundColor,
      toggleButtonsBackgroundSplashColor: toggleButtonsBackgroundSplashColor,
    );
  }
}
