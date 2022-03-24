part of 'bottom_tabs_bloc.dart';

@immutable
abstract class BottomTabsEvent {
  final bool refresh;
  final String? module;

  const BottomTabsEvent(this.refresh, this.module);
}

class BottomTabsInitEvent extends BottomTabsEvent {
  const BottomTabsInitEvent(bool refresh, String? module) : super(refresh, module);

  @override
  String toString() => 'BottomTabsInitEvent { refresh: $refresh, module: $module }';
}
