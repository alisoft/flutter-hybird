part of 'sticky_header_bloc.dart';

@immutable
abstract class StickyHeaderState {
  final bool? isDesc;

  const StickyHeaderState(this.isDesc);
}

class StickyHeaderPreInitState extends StickyHeaderState {
  const StickyHeaderPreInitState({bool isDesc = true})
      : super(isDesc);

  @override
  String toString() => 'StickyHeaderPreInitState { isDesc: $isDesc }';
}

class StickyHeaderInitializedState extends StickyHeaderState {
  const StickyHeaderInitializedState({bool? isDesc}) : super(isDesc);

  @override
  String toString() => 'StickyHeaderInitializedState { isDesc: $isDesc }';
}

class StickyHeaderUninitializedState extends StickyHeaderState {
  const StickyHeaderUninitializedState({bool? isDesc}) : super(isDesc);

  @override
  String toString() => 'StickyHeaderUninitializedState { isDesc: $isDesc }';
}
