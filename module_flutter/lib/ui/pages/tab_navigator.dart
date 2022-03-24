import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:module_flutter/common/constant/cart_constants.dart';
import 'package:module_flutter/common/constant/home_constants.dart';
import 'package:module_flutter/common/constant/store_constants.dart';
import 'package:module_flutter/ui/pages/cart/cart_page.dart';
import 'package:module_flutter/ui/pages/home/home_page.dart';
import 'package:module_flutter/ui/pages/store/store_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/common/constant/me_constants.dart';
import 'package:module_flutter/common/constant/search_constants.dart';
import 'package:module_flutter/common/iconfonts/iconfonts.dart';
import 'package:module_flutter/common/model/tab.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:module_flutter/ui/blocs/bottom_tabs/bottom_tabs_bloc.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/settings/click_sound/click_sound_bloc.dart';
import 'package:module_flutter/ui/blocs/me/tabs/tabs_bloc.dart';
import 'package:module_flutter/ui/pages/me/mine_page.dart';
import 'package:module_flutter/ui/pages/search/search_page.dart';
import 'package:module_flutter/ui/widgets/fire_button.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:uni_links/uni_links.dart';

Map<String, Widget> pageMap = {
  HomeConstants.module: const HomePage(),
  StoreConstants.module: const StorePage(),
  SearchConstants.module: const SearchPage(),
  CartConstants.module: const CartPage(),
  MeConstants.module: const MinePage(),
};

const schemes = ['https', 'flutter_boilerplate'];
const defaultHost = 'boilerplate.gitter.app';

class TabNavigator extends StatefulWidget {
  const TabNavigator({Key? key}) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache();
  final PageController _controller = PageController(initialPage: 0);
  final QuickActions _quickActions = const QuickActions();
  AnimationController? _animationController;
  int _currentIndex = 0;
  StreamSubscription? _sub;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _quickActions.initialize((String shortcutType) {
      if (shortcutType == 'search') {
        _controller.jumpToPage(2);
        setState(() {
          _currentIndex = 2;
        });
      }
    });
    _quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'search',
        localizedTitle: 'Search',
      ),
    ]).catchError((error) async {
      printErrorLog(error);
    });
    _handleIncomingLinks();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    _animationController!.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return BlocBuilder<TabsBloc, TabsState>(
      builder: (context, state) => BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, darkModeState) =>
            BlocBuilder<ClickSoundBloc, ClickSoundState>(
          builder: (context, clickSoundState) => Scaffold(
            body: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: state.tabs
                  .map((tab) => tab.text)
                  .toList()
                  .map((text) => pageMap[text!] as Widget)
                  .toList(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 12,
              currentIndex: _currentIndex,
              onTap: (index) {
                _controller.jumpToPage(index);
                _animationController!.reset();
                _animationController!.forward();
                if(clickSoundState.switchOn) {
                  _play();
                }
                BlocProvider.of<BottomTabsBloc>(context)
                    .add(BottomTabsInitEvent(
                  _currentIndex == index,
                  state.tabs[index].text,
                ));
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: _theme.primaryColor,
              items: _item(state.tabs, darkModeState),
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _item(
      List<Tab> tabs, DarkModeState darkModeState) {
    var _theme = Theme.of(context);
    var _labelMap = <String, String>{
      HomeConstants.module:
          ModuleFlutterLocalizations.of(context)!.tabHomeTitle,
      StoreConstants.module: ModuleFlutterLocalizations.of(context)!.tabStoreTitle,
      SearchConstants.module: ModuleFlutterLocalizations.of(context)!.tabSearchTitle,
      CartConstants.module: ModuleFlutterLocalizations.of(context)!.tabCartTitle,
      MeConstants.module: ModuleFlutterLocalizations.of(context)!.tabMeTitle,
    };
    var items = <BottomNavigationBarItem>[];
    tabs.asMap().forEach((index, tab) {
      items.add(BottomNavigationBarItem(
        label: _labelMap[tab.text],
        icon: Icon(
          IconFont(
            tab.iconData!,
            matchTextDirection: true,
          ),
          color: DarkModeUtil.darkModeColor(context, darkModeState.themeMode),
        ),
        activeIcon: FireButton(
          controller: _animationController,
          child: Icon(
            IconFont(
              tab.iconData!,
              matchTextDirection: true,
            ),
            color: _theme.colorScheme.primary,
          ),
        ),
      ));
    });
    return items;
  }

  Future<int> _play() async {
    var audioPath = await _audioCache.load('audio/tapped.mp3');
    return await _audioPlayer.play(audioPath.path, isLocal: true, volume: 0.1);
  }

  /// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        final scheme = uri?.scheme;
        final host = uri?.host;
        final queryParameters = uri?.queryParameters;

        /// flutter_boilerplate://user?login=
        if (schemes.contains(scheme) &&
            [defaultHost, 'user'].contains(host) &&
            queryParameters != null &&
            queryParameters.containsKey('login')) {
          final login = queryParameters.entries
              .firstWhere((element) => element.key == 'login')
              .value;
          if (StringUtil.isNotBlank(login)) {
            // TODO: do something.
            return;
          }
        }

        /// flutter_boilerplate://repo?owner=&repo=
        if (schemes.contains(scheme) &&
            [defaultHost, 'repo'].contains(host) &&
            queryParameters != null &&
            queryParameters.containsKey('owner') &&
            queryParameters.containsKey('repo')) {
          final owner = queryParameters.entries
              .firstWhere((element) => element.key == 'owner')
              .value;
          final repo = queryParameters.entries
              .firstWhere((element) => element.key == 'repo')
              .value;
          if (StringUtil.isNotBlank(owner) && StringUtil.isNotBlank(repo)) {
            // TODO do something.
            return;
          }
        }
      }, onError: (Object err) {
        if (!mounted) return;
        printErrorLog('got err: $err');
      });
    }
  }
}
