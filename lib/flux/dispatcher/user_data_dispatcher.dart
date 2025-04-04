import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/flux/action/user_data_action.dart';
import 'package:today_list/flux/store/user_data_store.dart';

/// ユーザーデータ関連のディスパッチャー
class UserDataDispatcher {
  /// ユーザーデータ関連のアクションをディスパッチします
  static Future<void> dispatch(WidgetRef ref, UserDataAction action) async {
    await action.map(
      updateCurrentAppIconName: (action) async {
        await ref
            .read(userDataProvider.notifier)
            .updateCurrentAppIconName(action.newThemeName);
      },
      updateSelectedCheckBoxIcon: (action) async {
        await ref
            .read(userDataProvider.notifier)
            .updateSelectedCheckBoxIcon(action.newCheckBox);
      },
      updateEarnedIcons: (action) async {
        await ref
            .read(userDataProvider.notifier)
            .updateEarnedIcons(action.iconCategory.name, action.iconName.name);
      },
    );
  }
}
