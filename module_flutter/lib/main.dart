import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:module_flutter/common/config/module_flutter_config.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';
import 'package:module_flutter/common/utils/cache_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:module_flutter/ui/pages/module_flutter_app.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:module_flutter/common/utils/file_util.dart';
import 'package:module_flutter/common/utils/icloud_util.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/ui/blocs/flutter_app_boilerplate_bloc_observer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:module_flutter/ui/blocs/bloc_providers.dart';
import 'package:module_flutter/common/module_flutter_manager.dart';
import 'package:workmanager/workmanager.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  printInfoLog('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final workManager = Workmanager();

/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  workManager.executeTask((taskName, inputData) {
    final now = DateTime.now();
    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      ),
      HomeWidget.updateWidget(
        name: 'ModuleFlutterHomeWidgetProvider',
        androidName: 'ModuleFlutterHomeWidgetProvider',
        iOSName: 'ModuleFlutterHomeWidget',
      ),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Permission.appTrackingTransparency.request();
    await MobileAds.instance.initialize();
    await workManager.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
    await initHiveForFlutter();
    await Firebase.initializeApp();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    var settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      printWarningLog('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      printWarningLog('User granted provisional permission');
    } else {
      printWarningLog('User declined or has not accepted permission');
    }

    // 从iCloud中下载个人认证信息
    if (Platform.isIOS) {
      await _downFileFromICloud();
    }

    await _loadUserData();

    final packageInfo = await PackageInfo.fromPlatform();
    ModuleFlutterManager()
      ..version = packageInfo.version
      ..buildNumber = packageInfo.buildNumber;

    Bloc.observer = ModuleFlutterBlocObserver();
  } catch (e) {
    printErrorLog(e);
  }

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = ModuleFlutterConfig.sentryDSN
        ..reportSilentFlutterErrors = true;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: BlocProviders.blocProviders,
        child: ModuleFlutterApp(
          flutterLocalNotifications: flutterLocalNotificationsPlugin,
          channel: channel,
          workManager: workManager,
        ),
      ),
    ),
  );
}

Future<void> _loadUserData() async {
  var authorizationEmail = await CacheUtil.getCache(
      ModuleFlutterConstants.authorizationEmail,
      checkValidTimes: false);
  var authorizationPassword = await CacheUtil.getCache(
      ModuleFlutterConstants.authorizationPassword,
      checkValidTimes: false);
  if (StringUtil.isNotBlank(authorizationEmail) &&
      StringUtil.isNotBlank(authorizationPassword)) {
    // todo: load user data
  }
}

Future<void> _downFileFromICloud() async {
  var file = await FileUtil.localFile;
  await ICloudUtil.downloadFileFormICloud(FileUtil.fileName, file.path);
}
