part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {
  final String? text;
  final bool tapped;

  const SearchEvent(this.text, this.tapped);
}

class SearchInitEvent extends SearchEvent {
  const SearchInitEvent({
    String? text,
    bool tapped = false,
  }) : super(text, tapped);

  @override
  String toString() => 'SearchInitEvent { text: $text, tapped: $tapped }';
}
