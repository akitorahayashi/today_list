import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/model/design/tl_theme/tl_theme.dart';
import 'package:today_list/model/design/tl_theme/tl_theme_config.dart';
import 'package:today_list/model/todo/tl_workspace.dart';
import 'package:today_list/redux/action/tl_workspace_action.dart';
import 'package:today_list/redux/store/tl_app_state_provider.dart';
import 'package:today_list/view/component/common_ui_part/tl_appbar.dart';
import 'change_workspace_card.dart';
import 'add_workspace_button.dart';

class TLWorkspaceDrawer extends ConsumerWidget {
  final bool isContentMode;
  const TLWorkspaceDrawer({super.key, required this.isContentMode});

  // MARK: - UI (Build)
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeConfig tlThemeConfig = TLTheme.of(context);
    final String currentWorkspaceId = ref.watch(
      tlAppStateProvider.select((state) => state.currentWorkspaceID),
    );
    final workspaces = ref.watch(
      tlAppStateProvider.select((state) => state.tlWorkspaces),
    );

    return Drawer(
      child: Stack(
        children: [
          Container(color: tlThemeConfig.backgroundColor),
          Column(
            children: [
              _buildAppBar(context),
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, left: 3.0, right: 3.0),
                child: _buildWorkspaceList(
                    context, ref, currentWorkspaceId, workspaces),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MARK: - AppBar
  Widget _buildAppBar(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: TLTheme.of(context).gradientOfNavBar,
      ),
      child: TLAppBar(
        context: context,
        pageTitle: "Workspace",
        leadingButtonOnPressed: null,
        leadingIcon: null,
        trailingButtonOnPressed: null,
        trailingIcon: null,
      ),
    );
  }

  // MARK: - Workspace List
  Widget _buildWorkspaceList(BuildContext context, WidgetRef ref,
      String currentWorkspaceId, List<TLWorkspace> workspaces) {
    final TLThemeConfig tlThemeData = TLTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: tlThemeData.tlDoubleCardBorderColor,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 3.0),
          child: Column(
            children: [
              // デフォルトワークスペース
              ChangeWorkspaceCard(
                  isDefaultWorkspace: true, corrWorkspace: workspaces.first),
              // デフォルト以外のワークスペース
              _buildReorderableWorkspaceList(
                  ref, currentWorkspaceId, workspaces),
              const AddWorkspaceButton(),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Reorderable Workspace List
  Widget _buildReorderableWorkspaceList(
      WidgetRef ref, String currentWorkspaceId, List<TLWorkspace> workspaces) {
    return SingleChildScrollView(
      child: ReorderableColumn(
        children: [
          for (var workspace in workspaces.skip(1)) // 最初のワークスペースは固定
            ChangeWorkspaceCard(
              key: ValueKey(workspace.id),
              isDefaultWorkspace: false,
              corrWorkspace: workspace,
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          _handleReorder(ref, oldIndex, newIndex);
        },
      ),
    );
  }

  // MARK: - Handle Reordering Logic (Index → ID ベースに変更)
  void _handleReorder(WidgetRef ref, int oldIndex, int newIndex) {
    if (newIndex == oldIndex) return;

    final revisedOldIndex = oldIndex + 1;
    final revisedNewIndex = newIndex + 1;

    final workspaces = ref.read(tlAppStateProvider).tlWorkspaces;

    List<TLWorkspace> copiedWorkspaces = List.from(workspaces);
    final TLWorkspace movedWorkspace =
        copiedWorkspaces.removeAt(revisedOldIndex);
    copiedWorkspaces.insert(revisedNewIndex, movedWorkspace);

    ref.read(tlAppStateProvider.notifier).dispatchWorkspaceAction(
        TLWorkspaceAction.updateWorkspaceList(copiedWorkspaces));
  }
}
