import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchPreInitState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchInitEvent) {
      yield* _mapSearchInitToState(event);
    } else {
      // todo exception
    }
  }

  Stream<SearchState> _mapSearchInitToState(SearchEvent searchEvent) async* {
    yield SearchInitializedState(
      searchEvent.text ?? StringUtil.empty,
      searchEvent.tapped,
    );
  }
}
