part of 'theme_bloc.dart';

@immutable
abstract class ThemeState {
  final int? color;

  const ThemeState(this.color);
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({int? color = 0xfffe9401}) : super(color);

  @override
  String toString() => 'ThemeInitial';
}

class ThemeChanged extends ThemeState {
  const ThemeChanged({int? color}) : super(color);

  @override
  String toString() => 'ThemeChanged { color: $color }';
}
