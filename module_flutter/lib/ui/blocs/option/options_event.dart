part of 'options_bloc.dart';

@immutable
abstract class OptionsEvent {
  final int? optionTabIndex;
  final Language? optionLanguage;

  final String? currentTab;

  const OptionsEvent(this.optionTabIndex, this.optionLanguage, this.currentTab);
}

class OptionsInitEvent extends OptionsEvent {
  const OptionsInitEvent(int? optionTabIndex, Language? optionLanguage, currentTab)
      : super(optionTabIndex, optionLanguage, currentTab);

  @override
  String toString() {
    return 'OptionsInitEvent { currentTab: $currentTab }';
  }
}

class OptionsTabIndexAddEvent extends OptionsEvent {
  const OptionsTabIndexAddEvent(String? currentTab, optionTabIndex, {Language? optionLanguage})
      : super(optionTabIndex, optionLanguage, currentTab);

  @override
  String toString() {
    return 'OptionsTabIndexAddEvent { optionTabIndex: $optionTabIndex, currentTab: $currentTab }';
  }
}

class OptionsLanguageAddEvent extends OptionsEvent {
  const OptionsLanguageAddEvent(String? currentTab,  Language? optionLanguage, {int? optionTabIndex})
      : super(optionTabIndex, optionLanguage, currentTab);

  @override
  String toString() {
    return 'OptionsLanguageAddEvent { optionLanguage: $optionLanguage, currentTab: $currentTab }';
  }
}
