import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'click_sound_event.dart';

part 'click_sound_state.dart';

class ClickSoundBloc extends Bloc<ClickSoundEvent, ClickSoundState>
    with HydratedMixin {
  ClickSoundBloc() : super(const ClickSoundPreInitState());

  @override
  Stream<ClickSoundState> mapEventToState(ClickSoundEvent event) async* {
    if (event is ClickSoundInitEvent) {
      yield* _mapClickSoundInitToState(event);
    } else {
      // todo exception
    }
  }

  Stream<ClickSoundState> _mapClickSoundInitToState(
      ClickSoundEvent clickSoundEvent) async* {
    yield ClickSoundInitializedState(clickSoundEvent.switchOn);
  }

  @override
  ClickSoundState? fromJson(Map<String, dynamic> json) =>
      ClickSoundInitializedState(json['switchOn'] as bool);

  @override
  Map<String, dynamic>? toJson(ClickSoundState state) =>
      {'switchOn': state.switchOn};
}
