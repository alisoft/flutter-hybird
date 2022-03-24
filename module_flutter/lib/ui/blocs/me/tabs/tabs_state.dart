part of 'tabs_bloc.dart';

@immutable
abstract class TabsState {
  final List<Tab> tabs;

  const TabsState(this.tabs);
}

class TabsInitial extends TabsState {
  TabsInitial() : super(bottomTabs);

  @override
  String toString() => 'TabsInitial';
}

class TabsChanged extends TabsState {
  const TabsChanged(List<Tab> tabs) : super(tabs);

  @override
  String toString() => 'TabsChanged { tabs: $tabs }';
}
