import 'dart:async';
import 'package:module_flutter/common/enums/home_types.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'trending_event.dart';

part 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState>
    with HydratedMixin {
  TrendingBloc() : super(const TrendingLoading()) {
    hydrate();
  }

  @override
  Stream<TrendingState> mapEventToState(
    TrendingEvent event,
  ) async* {
    if (event is TrendingAddEvent) {
      yield* _mapTrendingAddToState(event);
    }
  }

  Stream<TrendingState> _mapTrendingAddToState(
      TrendingEvent trendingEvent) async* {
    if (state is TrendingLoading || state is TrendingLoaded) {
      final currentTab = trendingEvent.currentTab;
      yield TrendingLoaded(currentTab);
    }
  }

  @override
  TrendingState fromJson(Map<String, dynamic> json) =>
      TrendingLoading(currentTab: json['currentTab']);

  @override
  Map<String, dynamic> toJson(TrendingState state) =>
      {'currentTab': state.currentTab};
}
