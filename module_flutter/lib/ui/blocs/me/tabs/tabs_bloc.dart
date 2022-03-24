import 'dart:async';

import 'package:module_flutter/common/mock/tabs.dart';
import 'package:module_flutter/common/model/tab.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'tabs_event.dart';

part 'tabs_state.dart';

class TabsBloc extends Bloc<TabsEvent, TabsState> with HydratedMixin {
  TabsBloc() : super(TabsInitial()) {
    hydrate();
  }

  @override
  Stream<TabsState> mapEventToState(
    TabsEvent event,
  ) async* {
    if (event is TabChangedEvent) {
      yield* _mapTabChangedToState(event);
    } else {
      // todo exception
    }
  }

  Stream<TabsState> _mapTabChangedToState(TabsEvent tabsEvent) async* {
    final tabs = tabsEvent.tabs;
    yield TabsChanged(tabs);
  }

  @override
  TabsState fromJson(Map<String, dynamic> json) {
    final tabs = (json['tabs'] as List?)
        ?.map((e) => Tab.fromJson(e as Map<String, dynamic>))
        .toList();
    return TabsChanged(tabs == null || tabs.isEmpty ? bottomTabs : tabs);
  }

  @override
  Map<String, dynamic> toJson(TabsState state) => <String, dynamic>{
        'tabs': state.tabs,
      };
}
