import 'dart:core';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:module_flutter/common/constant/module_flutter_constants.dart';
import 'package:module_flutter/common/iconfonts/iconfonts.dart';
import 'package:module_flutter/common/utils/cache_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:module_flutter/ui/pages/login_page.dart';
import 'package:module_flutter/ui/pages/me/user_scanning_page.dart';
import 'package:module_flutter/ui/pages/me/user_settings_page.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/common/constant/me_constants.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/ui/blocs/bottom_tabs/bottom_tabs_bloc.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/widgets/error_page.dart';
import 'package:permission_handler/permission_handler.dart';

class MinePage extends StatefulWidget {
  const MinePage({
    Key? key,
  }) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  static const EdgeInsetsGeometry _padding =
      EdgeInsets.only(left: 14, right: 8);
  static const EdgeInsetsGeometry _margin = EdgeInsets.only(top: 8);

  Exception? _error;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (ctx, darkModeState) => Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () async {

          }, icon: const Icon(Icons.apps)),
          title: Text(
            ModuleFlutterLocalizations.of(context)!.tabMeTitle,
          ),
          actions: [
            IconButton(onPressed: () async {
              final currentState = await Permission.camera.status;
              if(!currentState.isGranted || currentState.isDenied) {
                final grantState = await Permission.camera.request();
                if(grantState.isGranted) {
                  NavigatorUtil.push(context, const UserScanningPage());
                  return;
                } else if(grantState.isDenied) {
                  _showInSnackBar("Permission denied");
                }
              } else if(currentState.isGranted) {
                NavigatorUtil.push(context, const UserScanningPage());
              } else {
                _showInSnackBar("Permission restricted");
              }
            }, icon: const Icon(IconFonts.scanning))
          ],
        ),
        body: BlocBuilder<BottomTabsBloc, BottomTabsState>(
            builder: (context, bottomTabsState) {
          if (bottomTabsState.refresh &&
              bottomTabsState.module == MeConstants.module) {
            BlocProvider.of<BottomTabsBloc>(context)
                .add(const BottomTabsInitEvent(false, MeConstants.module));
            Future.delayed(const Duration(milliseconds: 500), () {
              _handleRefresh();
            });
          }
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: _error == null
                ? RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView(
                      children: [
                        Container(
                          margin: _margin,
                          padding: _padding,
                          child: const UserSettingsPage(),
                        ),
                        TextButton(onPressed: () async {
                          // todo: logout
                          await CacheUtil.setCache(
                              ModuleFlutterConstants.authorizationEmail, StringUtil.empty);
                          await CacheUtil.setCache(
                              ModuleFlutterConstants.authorizationPassword, StringUtil.empty);
                          NavigatorUtil.pushReplacement(context, const LoginPage());
                        }, child: const Text('Logout'))
                      ],
                    ),
                  )
                : ErrorPage(
                    reload: _handleRefresh,
                  ),
          );
        }),
      ),
    );
  }

  Future<void> _handleRefresh() async {}

  void _showInSnackBar(String value) {
    BotToast.showCustomNotification(
      toastBuilder: (cancelFunc) => Container(
        margin: const EdgeInsets.only(left: 16, right: 8),
        decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: ProfileItem(
          content: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
          leading: Container(
            padding: const EdgeInsets.only(left: 4, right: 6),
            child: const Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
