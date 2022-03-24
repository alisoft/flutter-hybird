part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {
  final int? color;

  const ThemeEvent(this.color);
}

class ThemeChangedEvent extends ThemeEvent {
  const ThemeChangedEvent({int? color}) : super(color);

  @override
  String toString() {
    return 'ThemeChangedEvent { color: $color }';
  }
}
