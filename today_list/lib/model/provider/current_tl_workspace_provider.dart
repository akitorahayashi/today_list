import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../external/tl_pref.dart';
import '../todo/tl_todo.dart';
import './tl_workspace.dart';
import './tl_workspaces_provider.dart';
import '../todo/tl_category.dart';
import '../todo/tl_todos.dart';

// currentWorkspaceを提供するProvider
final currentTLWorkspaceProvider =
    StateNotifierProvider.autoDispose<CurrentTLWorkspaceNotifier, TLWorkspace>(
        (ref) {
  final _tlWorkspaces = ref.watch(tlWorkspacesProvider);
  return CurrentTLWorkspaceNotifier(ref, _tlWorkspaces);
});

// currentWorkspaceを管理するNotifier
class CurrentTLWorkspaceNotifier extends StateNotifier<TLWorkspace> {
  final Ref ref;
  int currentTLWorkspaceIndex;

  CurrentTLWorkspaceNotifier(this.ref, List<TLWorkspace> tlWorkspaces)
      : currentTLWorkspaceIndex = 0,
        super(tlWorkspaces[0]) {
    // 初期化処理
    _loadCurrentWorkspace(tlWorkspaces);
  }

  Future<void> _loadCurrentWorkspace(List<TLWorkspace> tlWorkspaces) async {
    final pref = await TLPref().getPref;
    this.currentTLWorkspaceIndex = pref.getInt('currentWorkspaceIndex') ?? 0;
    state = tlWorkspaces[currentTLWorkspaceIndex];
  }

  // 現在のワークスペースインデックスを変更する関数
  Future<void> changeCurrentWorkspaceIndex(
      {required int newCurrentWorkspaceIndex}) async {
    currentTLWorkspaceIndex = newCurrentWorkspaceIndex;
    state = ref.read(tlWorkspacesProvider)[currentTLWorkspaceIndex];
    await TLPref().getPref.then((pref) {
      pref.setInt('currentWorkspaceIndex', newCurrentWorkspaceIndex);
    });
  }

  // 現在のworkspaceの今日でチェック済みtodoを全て削除するための関数
  Future<void> deleteCheckedToDosInTodayInCurrentWorkspace() async {
    final _tlWorkspacesNotifier = ref.read(tlWorkspacesProvider.notifier);
    final _updatedCurrentTLWorkspace = state;

    for (TLCategory bigCategory in _updatedCurrentTLWorkspace.bigCategories) {
      // bigCategoryに関するチェック済みToDoの削除
      deleteAllCheckedToDosInAToDos(
        onlyToday: true,
        selectedWorkspaceIndex: currentTLWorkspaceIndex,
        selectedWorkspace: _updatedCurrentTLWorkspace,
        selectedToDos: _updatedCurrentTLWorkspace.toDos[bigCategory.id]!,
      );
      for (TLCategory smallCategory
          in _updatedCurrentTLWorkspace.smallCategories[bigCategory.id]!) {
        // smallCategoryに関するチェック済みToDoの削除
        deleteAllCheckedToDosInAToDos(
            onlyToday: true,
            selectedWorkspaceIndex: this.currentTLWorkspaceIndex,
            selectedWorkspace: _updatedCurrentTLWorkspace,
            selectedToDos: _updatedCurrentTLWorkspace.toDos[smallCategory.id]!);
      }
    }

    // 更新されたワークスペースを保存
    _tlWorkspacesNotifier.updateSpecificTLWorkspace(
        specificWorkspaceIndex: currentTLWorkspaceIndex,
        updatedWorkspace: _updatedCurrentTLWorkspace);
  }

  // 指定されたToDos内のチェック済みToDoを全て削除する関数
  void deleteAllCheckedToDosInAToDos({
    required bool onlyToday,
    int? selectedWorkspaceIndex,
    TLWorkspace? selectedWorkspace,
    required TLToDos selectedToDos,
  }) {
    // チェックされているToDoを削除
    selectedToDos.toDosInToday.removeWhere((todo) => todo.isChecked);
    if (!onlyToday) {
      selectedToDos.toDosInWhenever.removeWhere((todo) => todo.isChecked);
    }
    // 残っているToDo内のチェックされているステップを削除
    for (TLToDo todo in selectedToDos.toDosInToday) {
      todo.steps.removeWhere((step) => step.isChecked);
    }
    for (TLToDo todo in selectedToDos.toDosInWhenever) {
      todo.steps.removeWhere((step) => step.isChecked);
    }
  }
}