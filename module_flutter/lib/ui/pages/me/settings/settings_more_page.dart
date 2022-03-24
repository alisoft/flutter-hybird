import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/pages/me/settings/settings_bottom_page.dart';
import 'package:module_flutter/ui/pages/me/settings/settings_center_page.dart';
import 'package:module_flutter/ui/pages/me/settings/settings_top_page.dart';

class SettingsMorePage extends StatelessWidget {
  const SettingsMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry _padding = EdgeInsets.only(left: 14, right: 8);
    const EdgeInsetsGeometry _margin = EdgeInsets.only(top: 8);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          ModuleFlutterLocalizations.of(context)!.settings,
        ),
      ),
      body: BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) => ListView(
          children: <Widget>[
            Container(
              margin: _margin,
              padding: _padding,
              child: const SettingsTopPage(),
            ),
            Container(
              margin: _margin,
              padding: _padding,
              child: const SettingsCenterPage(),
            ),
            Container(
              margin: _margin,
              padding: _padding,
              child: const SettingsBottomPage(),
            ),
          ],
        ),
      ),
    );
  }
}
