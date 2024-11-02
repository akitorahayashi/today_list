import 'package:today_list/components/for_todo/icon_for_checkbox.dart';
import '../../../model/tl_theme.dart';
import '../../../model/todo/tl_todo.dart';
import '../../../model/todo/tl_todos.dart';
import '../../../model/todo/tl_step.dart';
import '../../../model/todo/tl_category.dart';
import '../../../model/external/tl_vibration.dart';
import '../../../model/workspace/tl_workspace.dart';
import '../../../dialogs/notify_todo_or_step_is_edited.dart';
import '../../../view/edit_todo_page/edit_todo_page.dart';
import '../step_card.dart';
import './slidable_for_todo_card.dart';
import 'package:flutter/material.dart';

import 'package:reorderables/reorderables.dart';

class ToDoCard extends StatefulWidget {
  final bool ifInToday;
  final int indexOfThisToDoInToDos;
  final TLCategory bigCategoryOfThisToDo;
  // smallCategoryならこれがある
  final TLCategory? smallCategoryOfThisToDo;
  // workspace系
  final int selectedWorkspaceIndex;
  final TLWorkspace selectedWorkspace;

  const ToDoCard({
    Key? key,
    required this.ifInToday,
    required this.indexOfThisToDoInToDos,
    required this.bigCategoryOfThisToDo,
    this.smallCategoryOfThisToDo,
    // workspace系
    required this.selectedWorkspaceIndex,
    required this.selectedWorkspace,
  }) : super(key: key);

  @override
  ToDoCardState createState() => ToDoCardState();
}

class ToDoCardState extends State<ToDoCard> {
  @override
  Widget build(BuildContext context) {
    final TLThemeData _tlThemeData = TLTheme.of(context);
    final TLCategory categoryOfThisToDo = widget.smallCategoryOfThisToDo == null
        ? widget.bigCategoryOfThisToDo
        : widget.smallCategoryOfThisToDo!;
    final TLToDos toDosOfThisCardBelong =
        widget.selectedWorkspace.toDos[categoryOfThisToDo.id]!;
    List<TLToDo> toDoArrayOfThisToDo = widget.ifInToday
        ? toDosOfThisCardBelong.toDosInToday
        : toDosOfThisCardBelong.toDosInWhenever;
    final TLToDo toDoData = toDoArrayOfThisToDo[widget.indexOfThisToDoInToDos];
    // 全体を囲むカード
    return GestureDetector(
      onTap: () {
        // チェックの状態を切り替える
        toDoData.isChecked = !toDoData.isChecked;
        // stepsがあるならその全てのstepsのcheck状態を同じにする
        for (TLStep step in toDoData.steps) {
          step.isChecked = toDoData.isChecked;
        }
        TLToDo.reorderWhenToggle(
            categoryId: categoryOfThisToDo.id,
            indexOfThisToDoInToDos: widget.indexOfThisToDoInToDos,
            toDoArrayOfThisToDo: toDoArrayOfThisToDo);
        TLVibration.vibrate();
        notifyToDoOrStepIsEditted(
          context: context,
          newName: toDoData.title,
          newCheckedState: toDoData.isChecked,
          quickChangeToToday: null,
        );
        TLWorkspace.saveSelectedWorkspace(
            selectedWorkspaceIndex: TLWorkspace.currentWorkspaceIndex);
      },
      onLongPress: toDoData.isChecked ? () {} : null,
      child: Card(
          // 色
          color: _tlThemeData.panelColor,
          // 浮き具合
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SlidableForToDoCard(
              isModelCard: false,
              toDoData: toDoData,
              toDoArrayOfThisToDo: toDoArrayOfThisToDo,
              indexOfThisToDoInToDos: widget.indexOfThisToDoInToDos,
              ifInToday: widget.ifInToday,
              // category
              bigCategoryOfThisToDo: widget.bigCategoryOfThisToDo,
              smallCategoryOfThisToDo: widget.smallCategoryOfThisToDo,
              // workspace
              selectedWorkspaceIndex: widget.selectedWorkspaceIndex,
              selectedWorkspace: widget.selectedWorkspace,
              editAction: () async {
                // タップしたらEditToDoCardをpushする
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return EditToDoPage(
                    toDoTitle: toDoData.title,
                    belogedSteps: toDoData.steps,
                    isInToday: widget.ifInToday,
                    indexOfThisToDoInToDos: widget.indexOfThisToDoInToDos,
                    bigCategory: widget.bigCategoryOfThisToDo,
                    smallCategory: widget.smallCategoryOfThisToDo,
                    oldCategoryId: widget.smallCategoryOfThisToDo?.id ??
                        widget.bigCategoryOfThisToDo.id,
                  );
                }));
              },
              // child
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        16, 18, 16, toDoData.steps.isNotEmpty ? 15 : 18),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // 左側のチェックボックス
                        Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                            // const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                            child: Transform.scale(
                              scale: 1.2,
                              child: IconForCheckBox(
                                  isChecked: toDoData.isChecked),
                            )),
                        // toDoのタイトル
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              toDoData.title,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(
                                      toDoData.isChecked ? 0.3 : 0.6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // stepsのリスト
                  if (toDoData.steps.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ReorderableColumn(
                        children: List<Widget>.generate(
                            toDoData.steps.length,
                            (int indexOfThisStepInToDo) => Padding(
                                  key: Key(UniqueKey().toString()),
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 2, 0),
                                  child: StepInToDoCard(
                                    toDoData: toDoData,
                                    indexOfThisStepInToDo:
                                        indexOfThisStepInToDo,
                                  ),
                                )),
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex != newIndex) {
                            final reOrderedToDo = toDoData.steps[oldIndex];
                            toDoData.steps.remove(reOrderedToDo);
                            toDoData.steps.insert(newIndex, reOrderedToDo);
                            setState(() {});
                            // toDosを保存する
                            TLWorkspace.saveSelectedWorkspace(
                                selectedWorkspaceIndex:
                                    widget.selectedWorkspaceIndex);
                          }
                        },
                      ),
                    )
                ],
              ),
            ),
          )),
    );
  }
}