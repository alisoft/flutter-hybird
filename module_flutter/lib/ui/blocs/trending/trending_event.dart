part of 'trending_bloc.dart';

@immutable
abstract class TrendingEvent {
  final String? currentTab;

  const TrendingEvent(this.currentTab);
}

class TrendingLoadEvent extends TrendingEvent {
  const TrendingLoadEvent({currentTab}) : super(currentTab);

  @override
  String toString() => 'TrendingLoadEvent';
}

class TrendingAddEvent extends TrendingEvent {
  const TrendingAddEvent(currentTab) : super(currentTab);

  @override
  String toString() => 'TrendingAddEvent { currentTab: $currentTab }';
}
