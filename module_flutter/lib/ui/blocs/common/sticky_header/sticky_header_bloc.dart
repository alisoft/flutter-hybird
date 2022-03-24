import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sticky_header_event.dart';
part 'sticky_header_state.dart';

class StickyHeaderBloc extends Bloc<StickyHeaderEvent, StickyHeaderState> {
  StickyHeaderBloc() : super(const StickyHeaderPreInitState());

  @override
  Stream<StickyHeaderState> mapEventToState(
    StickyHeaderEvent event,
  ) async* {
    if (event is StickyHeaderSortToggleEvent) {
      yield* _mapStickyHeaderSortToggleToState();
    } else {
      // todo exception
    }
  }

  Stream<StickyHeaderState> _mapStickyHeaderSortToggleToState() async* {
    if (state is StickyHeaderPreInitState ||
        state is StickyHeaderInitializedState) {
      final isDesc = state.isDesc!;
      yield StickyHeaderInitializedState(isDesc: !isDesc);
    }
  }

}
