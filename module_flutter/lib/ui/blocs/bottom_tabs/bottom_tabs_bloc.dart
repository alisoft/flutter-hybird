import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:module_flutter/common/constant/home_constants.dart';
import 'package:meta/meta.dart';

part 'bottom_tabs_event.dart';

part 'bottom_tabs_state.dart';

class BottomTabsBloc extends Bloc<BottomTabsEvent, BottomTabsState> {
  BottomTabsBloc() : super(const BottomTabsPreInitial());

  @override
  Stream<BottomTabsState> mapEventToState(
    BottomTabsEvent event,
  ) async* {
    if (event is BottomTabsInitEvent) {
      yield* _mapBottomTabsToState(event);
    } else {
      // todo exception
    }
  }

  Stream<BottomTabsState> _mapBottomTabsToState(
      BottomTabsEvent bottomTabsEvent) async* {
    final refresh = bottomTabsEvent.refresh;
    final module = bottomTabsEvent.module;
    yield BottomTabsInitialized(refresh, module);
  }
}
