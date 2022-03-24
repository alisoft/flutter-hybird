import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:module_flutter/common/config/module_flutter_config.dart';
import 'package:module_flutter/common/constant/store_constants.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/locale_util.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/object_util.dart';
import 'package:module_flutter/ui/blocs/bottom_tabs/bottom_tabs_bloc.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/l10n/l10n_bloc.dart';
import 'package:module_flutter/ui/blocs/me/theme/theme_bloc.dart';
import 'package:module_flutter/ui/pages/shop_detail/shop_detail_page.dart';
import 'package:module_flutter/ui/widgets/loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const String urlString = 'https://store.gitterapp.com/store';
// const String urlString = 'http://localhost:8080/store.html';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with AutomaticKeepAliveClientMixin {
  static const EdgeInsetsGeometry _padding =
      EdgeInsets.only(left: 14, right: 8);
  static const EdgeInsetsGeometry _margin = EdgeInsets.only(top: 8);
  final CookieManager _cookieManager = CookieManager.instance();

  InAppWebViewController? _appWebViewController;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _storeContent = Container(
      margin: _margin,
      padding: _padding,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.tryParse(urlString),
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              cacheEnabled: false,
              clearCache: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) async {
            setState(() {
              _loading = true;
            });
            _appWebViewController = controller;
            await _initCookieManager();
            _addJavaScriptHandler(controller);
          },
          onLoadError: (InAppWebViewController controller, Uri? url, int code,
              String message) {
            printErrorLog('code: $code, message: $message');
          },
          onLoadHttpError: (InAppWebViewController controller, Uri? url,
              int statusCode, String description) {
            printErrorLog('statusCode: $statusCode, description: $description');
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            setState(() {
              _loading = false;
            });
            var themeMode =
                BlocProvider.of<DarkModeBloc>(context).state.themeMode;
            var defaultLocale = WidgetsBinding.instance!.window.locale;
            var locale = BlocProvider.of<L10nBloc>(context).state.locale ??
                defaultLocale;
            var isDarkMode = DarkModeUtil.isDarkMode(context, themeMode);
            var color = BlocProvider.of<ThemeBloc>(context).state.color ??
                Theme.of(context).primaryColor;
            var data = {
              "darkMode": isDarkMode ? 'dark' : 'light',
              "locale": LocaleUtil.localeToLanguageTag(locale),
              "color": color
            };
            await _transportToWeb(json.encode(data));
          },
          onConsoleMessage: (InAppWebViewController controller,
              ConsoleMessage consoleMessage) {
            printWarningLog('consoleMessage: $consoleMessage');
          },
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ModuleFlutterLocalizations.of(context)!.tabStoreTitle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: MultiBlocListener(
          listeners: [
            BlocListener<DarkModeBloc, DarkModeState>(
              listener: (context, state) async {
                var isDarkMode =
                    DarkModeUtil.isDarkMode(context, state.themeMode);
                var data = {
                  "darkMode": isDarkMode ? 'dark' : 'light',
                };
                await _transportToWeb(json.encode(data));
              },
            ),
            BlocListener<L10nBloc, L10nState>(
              listener: (context, state) async {
                var defaultLocale = WidgetsBinding.instance!.window.locale;
                var locale = state.locale ?? defaultLocale;
                var data = {
                  "locale": LocaleUtil.localeToLanguageTag(locale),
                };
                await _transportToWeb(json.encode(data));
              },
            ),
            BlocListener<ThemeBloc, ThemeState>(
              listener: (context, state) async {
                var color = state.color ?? Theme.of(context).primaryColor;
                var data = {"color": color};
                await _transportToWeb(json.encode(data));
              },
            ),
            BlocListener<BottomTabsBloc, BottomTabsState>(
              listener: (context, state) async {
                if (state.refresh && state.module == StoreConstants.module) {
                  await _transportToWeb(json.encode({"pullDown": true}));
                }
              },
            ),
          ],
          child: Stack(
            children: [
              _storeContent,
              if (_loading) ...[
                const Center(
                  child: Loader(),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _transportToWeb(data) async {
    if (_appWebViewController != null) {
      if (!Platform.isAndroid ||
          await AndroidWebViewFeature.isFeatureSupported(
              AndroidWebViewFeature.CREATE_WEB_MESSAGE_CHANNEL)) {
        // wait until the page is loaded, and then create the Web Message Channel
        var webMessageChannel =
            await _appWebViewController!.createWebMessageChannel();
        var port1 = webMessageChannel!.port1;
        var port2 = webMessageChannel.port2;

        // set the web message callback for the port1
        await port1.setWebMessageCallback((message) async {
          printWarningLog("Message coming from the JavaScript side: $message");
          // when it receives a message from the JavaScript side, respond back with another message.
          await port1.postMessage(WebMessage(data: message! + " and back"));
        });

        // transfer port2 to the webpage to initialize the communication
        await _appWebViewController!.postWebMessage(
            message: WebMessage(data: data, ports: [port2]),
            targetOrigin: Uri.parse("*"));
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _loading = true;
    });
    _transportToWeb(json.encode({"pullDown": true}));
  }

  Future<void> _initCookieManager() async {
    Uri? url = Uri.tryParse(urlString);
    final expiresDate =
        DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;
    await _cookieManager.setCookie(
      url: url!,
      name: "apiKey",
      value: ModuleFlutterConfig.apiKey,
      expiresDate: expiresDate,
      isSecure: false,
    );
    await _cookieManager.setCookie(
      url: url,
      name: "appId",
      value: ModuleFlutterConfig.appId,
      expiresDate: expiresDate,
      isSecure: false,
    );
  }

  void _addJavaScriptHandler(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
        handlerName: 'openShopDetail',
        callback: (args) {
          // print arguments coming from the JavaScript side!
          printInfoLog(args[0]);
          if (ObjectUtil.isNotNull(args) && args.isNotEmpty) {
            NavigatorUtil.push(context, ShopDetailPage(title: args[0]));
          }

          // return data to the JavaScript side!
          return {
            'result': true,
          };
        });
  }

  @override
  bool get wantKeepAlive => true;
}
