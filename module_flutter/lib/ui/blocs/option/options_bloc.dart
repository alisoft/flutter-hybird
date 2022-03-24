import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:module_flutter/common/constant/home_constants.dart';
import 'package:module_flutter/common/enums/home_types.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/model/language_model.dart';
import 'package:module_flutter/common/utils/cache_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:meta/meta.dart';

part 'options_event.dart';

part 'options_state.dart';

class OptionsBloc extends Bloc<OptionsEvent, OptionsState> {
  OptionsBloc()
      : super(
          OptionsPreInitState(
            0,
            Language(text: StringUtil.empty, color: '#cccccc'),
          ),
        );

  @override
  Stream<OptionsState> mapEventToState(OptionsEvent event) async* {
    if (event is OptionsInitEvent) {
      yield* _mapOptionsInitToState(event);
    } else if (event is OptionsTabIndexAddEvent) {
      yield* _mapOptionsTabIndexAddToState(event);
    } else if (event is OptionsLanguageAddEvent) {
      yield* _mapOptionsLanguageAddToState(event);
    } else {
      // todo exception
    }
  }

  Stream<OptionsState> _mapOptionsInitToState(
      OptionsEvent optionsEvent) async* {
    if (state is OptionsPreInitState || state is OptionsInitializedState) {
      final currentTab = optionsEvent.currentTab;
      final tabIndex = await CacheUtil.getCache(
          _optionSinceKey(currentTab),
          checkValidTimes: false);
      final dynamic languageJson = await CacheUtil.getCache(
          _optionLanguageKey(currentTab),
          checkValidTimes: false);
      final optionTabIndex = tabIndex ?? 0;
      final optionLanguage = languageJson != null
          ? Language.fromJson(languageJson)
          : Language(text: StringUtil.empty, color: '#cccccc');
      yield OptionsInitializedState(optionTabIndex, optionLanguage);
      _print(
          'optionTabIndex: $optionTabIndex, optionLanguage: $optionLanguage');
    }
  }

  Stream<OptionsState> _mapOptionsTabIndexAddToState(
      OptionsEvent optionsEvent) async* {
    if (state is OptionsInitializedState) {
      final currentTab = optionsEvent.currentTab;
      final optionLanguage =
          (state as OptionsInitializedState).optionLanguage;
      final optionTabIndex =
          (optionsEvent as OptionsTabIndexAddEvent).optionTabIndex;
      yield OptionsInitializedState(optionTabIndex, optionLanguage);
      await CacheUtil.setCache(
          _optionSinceKey(currentTab), optionTabIndex);
      _print(
          'optionTabIndex: $optionTabIndex, optionLanguage: $optionLanguage');
    }
  }

  Stream<OptionsState> _mapOptionsLanguageAddToState(
      OptionsEvent optionsEvent) async* {
    if (state is OptionsInitializedState) {
      final currentTab = optionsEvent.currentTab;
      final optionTabIndex =
          (state as OptionsInitializedState).optionTabIndex;
      final optionLanguage =
          (optionsEvent as OptionsLanguageAddEvent).optionLanguage;
      yield OptionsInitializedState(optionTabIndex, optionLanguage);
      await CacheUtil.setCache(
          _optionLanguageKey(currentTab), optionLanguage);
      _print(
          'optionTabIndex: $optionTabIndex, optionLanguage: $optionLanguage');
    }
  }

  String _optionSinceKey(String? currentTab) {
    return currentTab == HomeType.news
            ? HomeConstants.trendingRepositorySince
            : HomeConstants.trendingDeveloperSince;
  }

  String _optionLanguageKey(String? currentTab) {
    return currentTab == HomeType.news
            ? HomeConstants.trendingRepositoryLanguage
            : HomeConstants.trendingDeveloperLanguage;
  }

  void _print(String msg) {
    printInfoLog(msg);
  }
}
