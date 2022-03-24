part of 'sticky_header_bloc.dart';

@immutable
abstract class StickyHeaderEvent {
  const StickyHeaderEvent();
}

class StickyHeaderPreInitEvent extends StickyHeaderEvent {

  @override
  String toString() => 'StickyHeaderPreInitEvent';
}

class StickyHeaderSortToggleEvent extends StickyHeaderEvent {

  @override
  String toString() => 'StickyHeaderSortToggleEvent';
}

