import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/model/design/icon_for_checkbox.dart';
import 'package:today_list/model/design/tl_icon_data.dart';
import 'package:today_list/view_model/design/tl_icon_data_provider.dart';
import 'package:today_list/model/design/tl_theme.dart';

final List<String> fontawesomeCategories = ["Default"];

class TLCheckBox extends ConsumerWidget {
  final bool isChecked;
  final Color? iconColor;
  final double? iconSize;

  const TLCheckBox({
    super.key,
    required this.isChecked,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    final TLIconData tlIconData = ref.watch(tlIconDataProvider);
    // このカテゴリーで指定されたアイコンがない場合、デフォルトのものを使う

    IconForCheckBox thisIconData = (() {
      // 指定したアイコンがなければ、チェックボックスを使う
      if (iconsForCheckBox[tlIconData.category] != null &&
          iconsForCheckBox[tlIconData.category]![tlIconData.rarity] != null &&
          iconsForCheckBox[tlIconData.category]![tlIconData.rarity]![
                  tlIconData.name] !=
              null) {
        return iconsForCheckBox[tlIconData.category]![tlIconData.rarity]![
            tlIconData.name]!;
      } else {
        return iconsForCheckBox["Default"]!["Common"]!["box"]!;
      }
    }());
    return Icon(
      isChecked ? thisIconData.checkedIcon : thisIconData.notCheckedIcon,
      color: iconColor ??
          (isChecked
              ? tlThemeData.checkmarkColor
              : Colors.black.withOpacity(0.56)),
      size: iconSize ??
          (fontawesomeCategories.contains(tlIconData.category) ? 17 : 19),
    );
  }
}
