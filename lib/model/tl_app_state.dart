import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:today_list/model/todo/tl_workspace.dart';
import 'package:today_list/resource/tl_theme_type.dart';

part 'generate/tl_app_state.freezed.dart';
part 'generate/tl_app_state.g.dart';

// $ dart run build_runner build

const String noneID = "defaultID";

@freezed
class TLAppState with _$TLAppState {
  const TLAppState._();

  const factory TLAppState({
    @Default([]) List<TLWorkspace> tlWorkspaces,
    @Default(noneID) String currentWorkspaceID,
    @Default(TLThemeType.sunOrange) TLThemeType selectedThemeType,
  }) = _TLAppState;

  factory TLAppState.fromJson(Map<String, dynamic> json) =>
      _$TLAppStateFromJson(json);

  /// 現在のワークスペースを取得する
  TLWorkspace get getCurrentWorkspace => tlWorkspaces.firstWhere(
        (workspace) => workspace.id == currentWorkspaceID,
        orElse: () =>
            tlWorkspaces.firstWhere((workspace) => workspace.id == noneID),
      );
}
