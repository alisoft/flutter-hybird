import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter/common/utils/string_util.dart';

part 'l10n_event.dart';
part 'l10n_state.dart';

class L10nBloc extends Bloc<L10nEvent, L10nState> {
  L10nBloc() : super(const L10nInitial());

  @override
  Stream<L10nState> mapEventToState(
    L10nEvent event,
  ) async* {
    if (event is L10nInitEvent) {
      yield* _mapL10nInitToState(event);
    } else {
      // todo exception
    }
  }

  Stream<L10nState> _mapL10nInitToState(
      L10nEvent l10nEvent) async* {
      final localeName = l10nEvent.localeName!;

      if(localeName.contains('_')) {
        final index = localeName.indexOf('_');
        final languageCode = localeName.substring(0, index);
        final countryCode = localeName.substring(index + 1);
        yield L10nInitialized(Locale(languageCode, countryCode));
      } else {
        yield L10nInitialized(StringUtil.isBlank(localeName) ? null : Locale(localeName));
      }

  }
}
