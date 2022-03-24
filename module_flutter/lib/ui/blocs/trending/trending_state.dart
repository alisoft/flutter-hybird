part of 'trending_bloc.dart';

@immutable
abstract class TrendingState {
  final String? currentTab;

  const TrendingState(this.currentTab);
}

class TrendingLoading extends TrendingState {
  const TrendingLoading({currentTab = HomeType.news}) : super(currentTab);

  @override
  String toString() => 'TrendingLoading';
}

class TrendingLoaded extends TrendingState {
  const TrendingLoaded(String? currentTab) : super(currentTab);

  @override
  String toString() {
    return 'TrendingLoaded { currentTab: $currentTab }';
  }
}

class TrendingUnLoaded extends TrendingState {
  const TrendingUnLoaded({currentTab}) : super(currentTab);

  @override
  String toString() => 'TrendingLoaded';
}
