import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/model/design/tl_theme/tl_theme.dart';
import 'package:today_list/model/design/tl_theme/tl_theme_config.dart';
import 'package:today_list/model/tl_app_state.dart';
import 'package:today_list/model/todo/tl_todo_category.dart';
import 'package:today_list/model/todo/tl_workspace.dart';
import 'package:today_list/redux/store/tl_app_state_provider.dart';

class SelectSmallCategoryDropdown extends ConsumerWidget {
  final String bigCategoryID;
  final String? smallCategoryID;
  final Function(String) onSelected;

  const SelectSmallCategoryDropdown({
    super.key,
    required this.bigCategoryID,
    required this.smallCategoryID,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeConfig tlThemeData = TLTheme.of(context);
    final tlAppState = ref.watch(tlAppStateProvider);
    final TLWorkspace currentWorkspace = tlAppState.getCurrentWorkspace;

    final smallCats = currentWorkspace.smallCategories[bigCategoryID] ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: DropdownButton<TLToDoCategory>(
        iconEnabledColor: tlThemeData.accentColor,
        isExpanded: true,
        hint: Text(
          smallCategoryID == null
              ? "小カテゴリー"
              : smallCats
                  .firstWhere(
                    (cat) => cat.id == smallCategoryID,
                    orElse: () => const TLToDoCategory(
                        id: '', parentBigCategoryID: null, name: '小カテゴリー'),
                  )
                  .name,
          style: const TextStyle(
              color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        style:
            const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        items: [
          if (smallCats.isEmpty)
            const TLToDoCategory(
                id: noneID, parentBigCategoryID: null, name: "なし"),
          ...smallCats,
          if (bigCategoryID != noneID)
            const TLToDoCategory(
                id: "---createSmallCategory",
                parentBigCategoryID: null,
                name: "新しく作る"),
        ].map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item.name,
              style: item.id == smallCategoryID
                  ? TextStyle(
                      color: tlThemeData.accentColor,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        onChanged: (TLToDoCategory? selected) {
          if (selected == null) return;
          onSelected(selected.id);
        },
      ),
    );
  }
}
