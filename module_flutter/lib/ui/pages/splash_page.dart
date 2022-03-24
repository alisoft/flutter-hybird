import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter/common/config/module_flutter_config.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';
import 'package:module_flutter/ui/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/ui/pages/notifications/message.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/theme/theme_bloc.dart';
import 'package:module_flutter/ui/widgets/loader.dart';
import 'package:module_flutter/ui/widgets/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

BannerAd bannerAd = BannerAd(
  adUnitId: kDebugMode
      ? BannerAd.testAdUnitId
      : ModuleFlutterConfig.bannerAppUnitId,
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);

class SplashPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotifications;
  final AndroidNotificationChannel channel;

  const SplashPage({
    Key? key,
    required this.flutterLocalNotifications,
    required this.channel,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _initAppsFlyer();
    WidgetsBinding.instance!.addObserver(this);
    _initPlatformState();
    _initFirebaseMessaging();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (context, state) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => _default(themeState),
      ),
    );
  }

  Widget _default(ThemeState themeState) {
    var _theme = Theme.of(context);
    return FutureBuilder(
      future: bannerAd.load(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return SplashScreen.navigate(
            shouldNavigate: true,
            title: Text(
              ModuleFlutterLocalizations.of(context)!.welcome,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            navigateAfterSeconds: _widget,
            image: Image.network(
                'https://cdn.gitterapp.com/logo/flutter_boilerplate.png'),
            styleTextUnderTheLoader: const TextStyle(),
            backgroundColor: _theme.colorScheme.background,
            photoSize: 100.0,
            onClick: () => printInfoLog(ModuleFlutterConstants.appName),
            useLoader: true,
            customLoader: const Loader(
              size: 40,
            ),
            loadingText:
                Text(ModuleFlutterLocalizations.of(context)!.loading),
            loadingTextPadding: const EdgeInsets.only(bottom: 80),
            loaderColor: Color(themeState.color!),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SplashScreen.timer(
                seconds: 5,
                title: Text(
                  ModuleFlutterLocalizations.of(context)!.welcome,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                navigateAfterSeconds: _widget,
                image: Image.network(
                    'https://cdn.gitterapp.com/logo/flutter_boilerplate.png'),
                styleTextUnderTheLoader: const TextStyle(),
                backgroundColor: _theme.colorScheme.background,
                photoSize: 100.0,
                onClick: () =>
                    printInfoLog(ModuleFlutterConstants.appName),
                useLoader: true,
                customLoader: const Loader(
                  size: 40,
                ),
                loadingText:
                    Text(ModuleFlutterLocalizations.of(context)!.loading),
                loadingTextPadding: const EdgeInsets.only(bottom: 80),
                loaderColor: Color(themeState.color!),
              ),
              Positioned(
                bottom: (Platform.isIOS &&
                        MediaQuery.of(context).padding.bottom > 0)
                    ? 34
                    : 10,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              )
            ],
          );
        } else {
          return SplashScreen.navigate(
            shouldNavigate: false,
            title: Text(
              ModuleFlutterLocalizations.of(context)!.welcome,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            image: Image.network('https://cdn.gitterapp.com/logo/gitter.png'),
            styleTextUnderTheLoader: const TextStyle(),
            backgroundColor: _theme.colorScheme.background,
            photoSize: 100.0,
            onClick: () => printInfoLog(ModuleFlutterConstants.appName),
            useLoader: true,
            customLoader: const Loader(
              size: 40,
            ),
            loadingText:
                Text(ModuleFlutterLocalizations.of(context)!.loading),
            loadingTextPadding: const EdgeInsets.only(bottom: 80),
            loaderColor: Color(themeState.color!),
          );
        }
      },
    );
  }

  Widget get _widget {
    // todo
    return const LoginPage();
    // return FlutterBoilerplateManager().user == null
    //     ? const LoginPage()
    //     : const TabNavigator();
  }

  void _initFirebaseMessaging() {
    FirebaseMessaging.instance.getInitialMessage().then((message) => {
          if (message != null)
            {
              /// todo
            }
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var notification = message.notification;
      var android = message.notification?.android;
      if (notification != null && android != null) {
        widget.flutterLocalNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              widget.channel.id,
              widget.channel.name,
              channelDescription: widget.channel.description,
              icon: 'ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      printInfoLog('A new onMessageOpenedApp event was published!');
      try {
        await FlutterDynamicIcon.setApplicationIconBadgeNumber(0);
      } catch (_) {}
      NavigatorUtil.push(context, const MessageView(),
          settings: RouteSettings(arguments: MessageArguments(message, true)));
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initPlatformState() async {
    AdjustConfig config = AdjustConfig('',
        kDebugMode ? AdjustEnvironment.sandbox : AdjustEnvironment.production);
    config.logLevel = AdjustLogLevel.info;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      printDebugLog('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        printDebugLog(
            '[Adjust]: Tracker token: ' + attributionChangedData.trackerToken!);
      }
      if (attributionChangedData.trackerName != null) {
        printDebugLog(
            '[Adjust]: Tracker name: ' + attributionChangedData.trackerName!);
      }
      if (attributionChangedData.campaign != null) {
        printDebugLog(
            '[Adjust]: Campaign: ' + attributionChangedData.campaign!);
      }
      if (attributionChangedData.network != null) {
        printDebugLog('[Adjust]: Network: ' + attributionChangedData.network!);
      }
      if (attributionChangedData.creative != null) {
        printDebugLog(
            '[Adjust]: Creative: ' + attributionChangedData.creative!);
      }
      if (attributionChangedData.adgroup != null) {
        printDebugLog('[Adjust]: Adgroup: ' + attributionChangedData.adgroup!);
      }
      if (attributionChangedData.clickLabel != null) {
        printDebugLog(
            '[Adjust]: Click label: ' + attributionChangedData.clickLabel!);
      }
      if (attributionChangedData.adid != null) {
        printDebugLog('[Adjust]: Adid: ' + attributionChangedData.adid!);
      }
      if (attributionChangedData.costType != null) {
        printDebugLog(
            '[Adjust]: Cost type: ' + attributionChangedData.costType!);
      }
      if (attributionChangedData.costAmount != null) {
        printDebugLog('[Adjust]: Cost amount: ' +
            attributionChangedData.costAmount!.toString());
      }
      if (attributionChangedData.costCurrency != null) {
        printDebugLog(
            '[Adjust]: Cost currency: ' + attributionChangedData.costCurrency!);
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      printDebugLog('[Adjust]: Session tracking success!');

      if (sessionSuccessData.message != null) {
        printDebugLog('[Adjust]: Message: ' + sessionSuccessData.message!);
      }
      if (sessionSuccessData.timestamp != null) {
        printDebugLog('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp!);
      }
      if (sessionSuccessData.adid != null) {
        printDebugLog('[Adjust]: Adid: ' + sessionSuccessData.adid!);
      }
      if (sessionSuccessData.jsonResponse != null) {
        printDebugLog(
            '[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse!);
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      printDebugLog('[Adjust]: Session tracking failure!');

      if (sessionFailureData.message != null) {
        printDebugLog('[Adjust]: Message: ' + sessionFailureData.message!);
      }
      if (sessionFailureData.timestamp != null) {
        printDebugLog('[Adjust]: Timestamp: ' + sessionFailureData.timestamp!);
      }
      if (sessionFailureData.adid != null) {
        printDebugLog('[Adjust]: Adid: ' + sessionFailureData.adid!);
      }
      if (sessionFailureData.willRetry != null) {
        printDebugLog(
            '[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
      }
      if (sessionFailureData.jsonResponse != null) {
        printDebugLog(
            '[Adjust]: JSON response: ' + sessionFailureData.jsonResponse!);
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      printDebugLog('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        printDebugLog('[Adjust]: Event token: ' + eventSuccessData.eventToken!);
      }
      if (eventSuccessData.message != null) {
        printDebugLog('[Adjust]: Message: ' + eventSuccessData.message!);
      }
      if (eventSuccessData.timestamp != null) {
        printDebugLog('[Adjust]: Timestamp: ' + eventSuccessData.timestamp!);
      }
      if (eventSuccessData.adid != null) {
        printDebugLog('[Adjust]: Adid: ' + eventSuccessData.adid!);
      }
      if (eventSuccessData.callbackId != null) {
        printDebugLog('[Adjust]: Callback ID: ' + eventSuccessData.callbackId!);
      }
      if (eventSuccessData.jsonResponse != null) {
        printDebugLog(
            '[Adjust]: JSON response: ' + eventSuccessData.jsonResponse!);
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      printDebugLog('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        printDebugLog('[Adjust]: Event token: ' + eventFailureData.eventToken!);
      }
      if (eventFailureData.message != null) {
        printDebugLog('[Adjust]: Message: ' + eventFailureData.message!);
      }
      if (eventFailureData.timestamp != null) {
        printDebugLog('[Adjust]: Timestamp: ' + eventFailureData.timestamp!);
      }
      if (eventFailureData.adid != null) {
        printDebugLog('[Adjust]: Adid: ' + eventFailureData.adid!);
      }
      if (eventFailureData.callbackId != null) {
        printDebugLog('[Adjust]: Callback ID: ' + eventFailureData.callbackId!);
      }
      if (eventFailureData.willRetry != null) {
        printDebugLog(
            '[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
      }
      if (eventFailureData.jsonResponse != null) {
        printDebugLog(
            '[Adjust]: JSON response: ' + eventFailureData.jsonResponse!);
      }
    };

    config.deferredDeeplinkCallback = (String? uri) {
      printDebugLog('[Adjust]: Received deferred deeplink: ' + uri!);
    };

    config.conversionValueUpdatedCallback = (num? conversionValue) {
      printDebugLog('[Adjust]: Received conversion value update: ' +
          conversionValue!.toString());
    };

    // Add session callback parameters.
    Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
    Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

    // Add session Partner parameters.
    Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
    Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

    // Remove session callback parameters.
    Adjust.removeSessionCallbackParameter('scp_foo_1');
    Adjust.removeSessionPartnerParameter('spp_foo_1');

    // Clear all session callback parameters.
    Adjust.resetSessionCallbackParameters();

    // Clear all session partner parameters.
    Adjust.resetSessionPartnerParameters();

    // Ask for tracking consent.
    Adjust.requestTrackingAuthorizationWithCompletionHandler().then((status) {
      printDebugLog('[Adjust]: Authorization status update!');
      switch (status) {
        case 0:
          printDebugLog(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusNotDetermined');
          break;
        case 1:
          printDebugLog(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusRestricted');
          break;
        case 2:
          printDebugLog(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusDenied');
          break;
        case 3:
          printDebugLog(
              '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusAuthorized');
          break;
      }
    });

    // Start SDK.
    Adjust.start(config);
  }

  void _initAppsFlyer() async {
    final AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: ModuleFlutterConfig.afDevKey,
      appId: ModuleFlutterConfig.afAppId,
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 30,
    );
    AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    appsflyerSdk.onAppOpenAttribution((res) {
      printDebugLog("onAppOpenAttribution res: " + res.toString());
    });
    appsflyerSdk.onInstallConversionData((res) {
      printDebugLog("onInstallConversionData res: " + res.toString());
    });
    appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          printDebugLog(dp.deepLink?.toString());
          printDebugLog("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          printDebugLog("deep link not found");
          break;
        case Status.ERROR:
          printDebugLog("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          printDebugLog("deep link status parsing error");
          break;
      }
    });
    await appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: false,
        registerOnDeepLinkingCallback: true);
  }
}
