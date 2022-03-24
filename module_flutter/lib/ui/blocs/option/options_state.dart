part of 'options_bloc.dart';

@immutable
abstract class OptionsState {
  final int? optionTabIndex;
  final Language? optionLanguage;

  const OptionsState(this.optionTabIndex, this.optionLanguage);
}

class OptionsPreInitState extends OptionsState {
  const OptionsPreInitState(int optionTabIndex, Language optionLanguage)
      : super(optionTabIndex, optionLanguage);

  @override
  String toString() =>
      'OptionsPreInitState { optionTabIndex: $optionTabIndex, optionLanguage: $optionLanguage }';
}

class OptionsInitializedState extends OptionsState {
  const OptionsInitializedState(int? optionTabIndex, Language? optionLanguage)
      : super(optionTabIndex, optionLanguage);

  @override
  String toString() =>
      'OptionsInitializedState { optionTabIndex: $optionTabIndex, optionLanguage: $optionLanguage }';
}

class OptionsUninitializedState extends OptionsState {
  const OptionsUninitializedState({int? optionTabIndex, Language? optionLanguage})
      : super(optionTabIndex, optionLanguage);

  @override
  String toString() => 'OptionsUninitializedState';
}
