part of 'dark_mode_bloc.dart';

@immutable
abstract class DarkModeEvent {
  final ThemeMode? themeMode;
  const DarkModeEvent(this.themeMode);
}

class DarkModeInitEvent extends DarkModeEvent {
  const DarkModeInitEvent({ThemeMode? themeMode = ThemeMode.system}) : super(themeMode);

  @override
  String toString() {
    return 'DarkModeInitEvent { themeMode: $themeMode }';
  }
}
