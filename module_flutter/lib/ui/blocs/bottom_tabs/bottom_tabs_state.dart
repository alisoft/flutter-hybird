part of 'bottom_tabs_bloc.dart';

@immutable
abstract class BottomTabsState {
  final bool refresh;
  final String? module;

  const BottomTabsState(this.refresh, this.module);
}

class BottomTabsPreInitial extends BottomTabsState {
  const BottomTabsPreInitial({
    bool refresh = false,
    String module = HomeConstants.module,
  }) : super(refresh, module);

  @override
  String toString() => 'BottomTabsPreInitial';
}

class BottomTabsInitialized extends BottomTabsState {
  const BottomTabsInitialized(bool refresh, String? module) : super(refresh, module);

  @override
  String toString() => 'BottomTabsInitialized { refresh: $refresh, module: $module }';
}
