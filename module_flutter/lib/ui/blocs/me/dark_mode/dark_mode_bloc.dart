import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'dark_mode_event.dart';
part 'dark_mode_state.dart';

class DarkModeBloc extends Bloc<DarkModeEvent, DarkModeState> {
  DarkModeBloc() : super(const DarkModeInitial());

  @override
  Stream<DarkModeState> mapEventToState(
    DarkModeEvent event,
  ) async* {
    if (event is DarkModeInitEvent) {
      yield* _mapDarkModePreInitToState(event);
    } else {
      // todo exception
    }
  }

  Stream<DarkModeState> _mapDarkModePreInitToState(
      DarkModeEvent darkModeEvent) async* {
    if (state is DarkModeInitial || state is DarkModeInitializedState) {

      final themeMode = darkModeEvent.themeMode;

      yield DarkModeInitializedState(themeMode);
    }
  }
}
