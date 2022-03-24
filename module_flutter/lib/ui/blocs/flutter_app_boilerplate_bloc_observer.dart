
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/common/utils/logger_util.dart';

class ModuleFlutterBlocObserver extends BlocObserver {
  /// Called whenever an [event] is `added` to any [bloc] with the given [bloc]
  /// and [event].
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    printInfoLog(event);
  }

  /// Called whenever a [Change] occurs in any [bloc]
  /// A [change] occurs when a new state is emitted.
  /// [onChange] is called before a bloc's state has been updated.
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  /// Called whenever a transition occurs in any [bloc] with the given [bloc]
  /// and [transition].
  /// A [transition] occurs when a new `event` is `added` and `mapEventToState`
  /// executed.
  /// [onTransition] is called before a [bloc]'s state has been updated.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  /// Called whenever an [error] is thrown in any [Bloc] or [Cubit].
  /// The [stackTrace] argument may be [StackTrace.empty] if an error
  /// was received without a stack trace.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    printErrorLog(error);
    super.onError(bloc, error, stackTrace);
  }
}
