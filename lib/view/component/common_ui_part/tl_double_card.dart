import 'package:flutter/material.dart';
import 'package:today_list/model/design/tl_theme/tl_theme.dart';
import 'package:today_list/model/design/tl_theme/tl_theme_config.dart';

class TLDoubleCard extends StatelessWidget {
  final double? borderRadius;
  final Widget child;
  const TLDoubleCard({super.key, this.borderRadius, required this.child});

  @override
  Widget build(BuildContext context) {
    final TLThemeConfig tlThemeData = TLTheme.of(context);
    return Card(
      color: tlThemeData.tlDoubleCardBorderColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      child: Card(
        color: tlThemeData.whiteBasedCardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10)),
        child: child,
      ),
    );
  }
}
