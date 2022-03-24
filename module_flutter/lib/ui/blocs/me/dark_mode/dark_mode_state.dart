part of 'dark_mode_bloc.dart';

@immutable
abstract class DarkModeState {
  final ThemeMode? themeMode;
  const DarkModeState(this.themeMode);
}

class DarkModeInitial extends DarkModeState {
  const DarkModeInitial({ThemeMode themeMode = ThemeMode.system}) : super(themeMode);

  @override
  String toString() =>
      'DarkModeInitial { themeMode: $themeMode }';
}

class DarkModeInitializedState extends DarkModeState {
  const DarkModeInitializedState(ThemeMode? themeMode) : super(themeMode);

  @override
  String toString() =>
      'DarkModeInitializedState { themeMode: $themeMode }';
}

class DarkModeUninitializedState extends DarkModeState {
  const DarkModeUninitializedState({ThemeMode themeMode = ThemeMode.system}) : super(themeMode);

  @override
  String toString() =>
      'DarkModeUninitializedState { themeMode: $themeMode }';
}
