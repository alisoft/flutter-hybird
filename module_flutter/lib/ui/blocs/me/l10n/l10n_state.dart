part of 'l10n_bloc.dart';

@immutable
abstract class L10nState {
  final Locale? locale;

  const L10nState(this.locale);

}

class L10nInitial extends L10nState {
  const L10nInitial({Locale? locale}) : super(locale);

  @override
  String toString() =>
      'L10nInitial { locale: $locale }';
}

class L10nInitialized extends L10nState {
  const L10nInitialized(Locale? locale) : super(locale);

  @override
  String toString() =>
      'L10nInitialized { locale: $locale }';
}
