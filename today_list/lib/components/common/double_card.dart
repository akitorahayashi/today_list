import '../../model/user/setting_data.dart';
import '../../model/tl_theme.dart';
import 'package:flutter/material.dart';

class DoubleCard extends StatelessWidget {
  final Widget child;
  const DoubleCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: tlThemeDataList[SettingData.shared.selectedThemeIndex]!
          .niceAppsCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}