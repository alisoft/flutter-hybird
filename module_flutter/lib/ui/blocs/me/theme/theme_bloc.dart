import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with HydratedMixin {
  ThemeBloc() : super(const ThemeInitial()) {
    hydrate();
  }

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if(event is ThemeChangedEvent) {
      yield* _mapThemeChangedToState(event);
    }
  }

  Stream<ThemeState> _mapThemeChangedToState(
      ThemeEvent event) async* {
    final color = event.color;
    yield ThemeChanged(color: color);
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) =>
      ThemeInitial(color: json['color'] as int?);

  @override
  Map<String, dynamic> toJson(ThemeState state) => {'color': state.color};
}
