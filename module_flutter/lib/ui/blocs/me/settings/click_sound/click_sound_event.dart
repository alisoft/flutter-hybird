part of 'click_sound_bloc.dart';

@immutable
abstract class ClickSoundEvent {
  final bool switchOn;

  const ClickSoundEvent(this.switchOn);
}

class ClickSoundInitEvent extends ClickSoundEvent {
  const ClickSoundInitEvent(bool switchOn) : super(switchOn);

  @override
  String toString() {
    return 'ClickSoundInitEvent { switchOn: $switchOn }';
  }
}
