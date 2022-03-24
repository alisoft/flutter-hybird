part of 'click_sound_bloc.dart';

@immutable
abstract class ClickSoundState {
  final bool switchOn;

  const ClickSoundState(this.switchOn);
}

class ClickSoundPreInitState extends ClickSoundState {
  const ClickSoundPreInitState({bool switchOn = true}) : super(switchOn);

  @override
  String toString() => 'ClickSoundPreInitState';
}

class ClickSoundInitializedState extends ClickSoundState {
  const ClickSoundInitializedState(bool switchOn) : super(switchOn);

  @override
  String toString() => 'ClickSoundInitializedState { switchOn: $switchOn }';
}
