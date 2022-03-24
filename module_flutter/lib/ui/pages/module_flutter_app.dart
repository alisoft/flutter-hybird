import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:module_flutter/common/module_flutter_manager.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/l10n/l10n_bloc.dart';
import 'package:module_flutter/ui/blocs/me/theme/theme_bloc.dart';
import 'package:module_flutter/ui/pages/splash_page.dart';
import 'package:module_flutter/ui/widgets/gitter_theme_data.dart';
import 'package:home_widget/home_widget.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';

/// Called when Doing Background Work initiated from Widget
void backgroundCallback(Uri? data) async {
  printInfoLog(data);

  if (data != null && data.host == 'titleclicked') {
    final greetings = [
      'Hello',
      'Hallo',
      'Bonjour',
      'Hola',
      'Ciao',
      '哈洛',
      '안녕하세요',
      'xin chào'
    ];
    final selectedGreeting = greetings[Random().nextInt(greetings.length)];

    await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
    await HomeWidget.updateWidget(
      name: 'ModuleFlutterHomeWidgetProvider',
      androidName: 'ModuleFlutterHomeWidgetProvider',
      iOSName: 'ModuleFlutterHomeWidget',
    );
  }
}

class ModuleFlutterApp extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotifications;
  final AndroidNotificationChannel channel;
  final Workmanager workManager;

  const ModuleFlutterApp({
    Key? key,
    required this.flutterLocalNotifications,
    required this.channel,
    required this.workManager,
  }) : super(key: key);

  @override
  _ModuleFlutterAppState createState() => _ModuleFlutterAppState();
}

class _ModuleFlutterAppState extends State<ModuleFlutterApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    super.initState();
    analytics.logAppOpen();
    HomeWidget.setAppGroupId('group.com.upcwangying.apps.flutter.boilerplate');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }

  @override
  Widget build(BuildContext context) {
    ModuleFlutterManager()
      ..context = context
      ..analytics = analytics
      ..observer = observer;
    if (kDebugMode) {
      Upgrader().clearSavedSettings();
    }
    final appcastPrefix = kDebugMode ? '/test' : '';
    final appcastURL =
        'https://boilerplate.gitter.app/upgrader$appcastPrefix/appcast.xml';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    return BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (context, state) => BlocBuilder<L10nBloc, L10nState>(
        builder: (context, l10State) => BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) => BackGestureWidthTheme(
            backGestureWidth: BackGestureWidth.fraction(1 / 2),
            child: MaterialApp(
              theme: GitterThemeData.lightThemeData.copyWith(
                primaryColor: Color(themeState.color!),
                colorScheme: GitterThemeData.lightColorScheme.copyWith(
                  primary: Color(themeState.color!),
                ),
                appBarTheme: AppBarTheme(
                  color: GitterThemeData.lightColorScheme.background,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Color(themeState.color!)),
                ),
              ),
              darkTheme: GitterThemeData.darkThemeData.copyWith(
                primaryColor: Color(themeState.color!),
                colorScheme: GitterThemeData.darkColorScheme.copyWith(
                  primary: Color(themeState.color!),
                ),
                appBarTheme: AppBarTheme(
                  color: GitterThemeData.darkColorScheme.background,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Color(themeState.color!)),
                ),
              ),
              title: ModuleFlutterConstants.appName,
              themeMode: state.themeMode,
              builder: BotToastInit(),
              navigatorObservers: [observer, BotToastNavigatorObserver()],
              home: UpgradeAlert(
                appcastConfig: cfg,
                debugLogging: kDebugMode,
                child: SplashPage(
                  flutterLocalNotifications: widget.flutterLocalNotifications,
                  channel: widget.channel,
                ),
              ),
              locale: l10State.locale,
              localizationsDelegates:
                  ModuleFlutterLocalizations.localizationsDelegates,
              supportedLocales: ModuleFlutterLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadWidgetData() async {
    try {
      await Future.wait([
        HomeWidget.getWidgetData<String>('title', defaultValue: 'Default Title')
            .then((value) {
          printInfoLog('title: $value');
        }),
        HomeWidget.getWidgetData<String>('message',
                defaultValue: 'Default Message')
            .then((value) {
          printInfoLog('message: $value');
        }),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Getting Data. $exception');
    }
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      showDialog(
          context: context,
          builder: (buildContext) => AlertDialog(
                title: const Text('App started from GitterHomeWidget'),
                content: Text('Here is the URI: $uri'),
              ));
    }
  }

  /// only for android
  void _startBackgroundUpdate() {
    widget.workManager.registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: const Duration(minutes: 15));
  }

  /// only for android
  void _stopBackgroundUpdate() {
    widget.workManager.cancelByUniqueName('1');
  }
}
