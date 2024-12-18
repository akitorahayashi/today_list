import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_list/view_model/todo/tl_workspaces_state.dart';
import '../dialog/for_workspace/add_or_edit_workspace_dialog.dart';
import '../dialog/for_workspace/delete_workspace_dialog.dart';
import '../../../model/todo/tl_workspace.dart';
import '../../../model/design/tl_theme.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableForWorkspaceCard extends ConsumerWidget {
  final bool isCurrentWorkspace;
  final int indexInTLWorkspaces;
  final Widget child;
  const SlidableForWorkspaceCard({
    super.key,
    required this.isCurrentWorkspace,
    required this.indexInTLWorkspaces,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TLThemeData tlThemeData = TLTheme.of(context);
    // provider
    final List<TLWorkspace> tlWorkspaces =
        ref.watch(tlWorkspacesStateProvider).tlWorkspaces;
    // other
    final TLWorkspace corrWorkspace = tlWorkspaces[indexInTLWorkspaces];
    return Slidable(
      // currentWorkspaceの時や
      startActionPane: isCurrentWorkspace ||
              // デフォルトワークスペースの時は削除できないようにする
              indexInTLWorkspaces == 0
          ? null
          : ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.35,
              children: [
                // For deleting workspace
                SlidableAction(
                  autoClose: true,
                  spacing: 8,
                  backgroundColor: tlThemeData.panelColor,
                  foregroundColor: tlThemeData.accentColor,
                  onPressed: (BuildContext context) async {
                    await showDialog(
                        context: context,
                        builder: (context) => DeleteWorkspaceDialog(
                            corrWorkspaceIndex: indexInTLWorkspaces,
                            willDeletedWorkspace: corrWorkspace));
                  },
                  icon: Icons.remove,
                  label: "Delete",
                ),
              ],
            ),
      endActionPane: // デフォルトワークスペースの時は編集できないようにする
          indexInTLWorkspaces == 0
              ? null
              : ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.35,
                  children: [
                    SlidableAction(
                      autoClose: true,
                      spacing: 8,
                      backgroundColor: tlThemeData.panelColor,
                      foregroundColor: tlThemeData.accentColor,
                      onPressed: (BuildContext context) async {
                        AddOrEditWorkspaceDialog(
                                oldIndexInWorkspaces: indexInTLWorkspaces)
                            .show(context: context);
                      },
                      icon: Icons.edit,
                      label: "Edit",
                    ),
                  ],
                ),
      child: child,
    );
  }
}
