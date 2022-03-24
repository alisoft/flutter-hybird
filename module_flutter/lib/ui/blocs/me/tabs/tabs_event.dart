part of 'tabs_bloc.dart';

@immutable
abstract class TabsEvent {
  final List<Tab> tabs;

  const TabsEvent(this.tabs);
}

class TabChangedEvent extends TabsEvent {
  const TabChangedEvent(List<Tab> tabs) : super(tabs);

  @override
  String toString() {
    return 'TabChangedEvent { tabs: $tabs }';
  }
}
