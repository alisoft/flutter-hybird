part of 'l10n_bloc.dart';

@immutable
abstract class L10nEvent {
  final String? localeName;

  const L10nEvent(this.localeName);
}

class L10nInitEvent extends L10nEvent {
  const L10nInitEvent({String? localeName}) : super(localeName);

  @override
  String toString() {
    return 'L10nInitEvent { localeName: $localeName }';
  }
}
