part of 'search_bloc.dart';

@immutable
abstract class SearchState {
  final String text;
  final bool tapped;

  const SearchState(this.text, this.tapped);
}

class SearchPreInitState extends SearchState {
  const SearchPreInitState({
    String text = StringUtil.empty,
    bool tapped = false,
  }) : super(text, tapped);

  @override
  String toString() => 'SearchPreInitState';
}

class SearchInitializedState extends SearchState {
  const SearchInitializedState(String text, bool tapped) : super(text, tapped);

  @override
  String toString() => 'SearchInitializedState { text: $text, tapped: $tapped }';
}
