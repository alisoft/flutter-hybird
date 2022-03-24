import 'package:flutter/material.dart';
import 'package:module_flutter/ui/pages/me/settings/settings_vpn_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/theme/theme_bloc.dart';
import 'package:module_flutter/ui/pages/me/settings/settings_bottom_bar_page.dart';
import 'package:module_flutter/ui/pages/me/settings/settings_dark_mode_page.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';

List<Function> _actionIcons = [
  (BuildContext context, ThemeMode? themeMode) {
    var _theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _theme.primaryColor,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: DarkModeUtil.isDarkMode(context, themeMode)
              ? Colors.white24
              : Colors.black26,
        )
      ],
    );
  },
  (BuildContext context, ThemeMode? themeMode) => Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: DarkModeUtil.isDarkMode(context, themeMode)
            ? Colors.white24
            : Colors.black26,
      ),
  (BuildContext context, ThemeMode? themeMode) => Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: DarkModeUtil.isDarkMode(context, themeMode)
            ? Colors.white24
            : Colors.black26,
      ),
  (BuildContext context, ThemeMode? themeMode) => Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: DarkModeUtil.isDarkMode(context, themeMode)
            ? Colors.white24
            : Colors.black26,
      ),
];

List<Function> _actions = [
  (BuildContext context, String content) {
    var _theme = Theme.of(context);
    var _color = 0xfffe9401;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('主题颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _theme.primaryColor,
            onColorChanged: (Color color) {
              _color = color.value;
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context)
                  .add(const ThemeChangedEvent(color: 0xfffe9401));
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context)
                  .add(ThemeChangedEvent(color: _color));
              Navigator.of(context).pop();
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  },
  (BuildContext context, String content) {
    NavigatorUtil.push(
      context,
      SettingsDarkModePage(
        headerTitle: content,
      ),
    );
  },
  (BuildContext context, String content) {
    NavigatorUtil.push(
      context,
      SettingsVpnPage(
        headerTitle: content,
      ),
    );
  },
  (BuildContext context, String content) {
    NavigatorUtil.push(
      context,
      const SettingsBottomBarPage(),
    );
  }
];

class SettingsCenterPage extends StatelessWidget {
  const SettingsCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _list(context),
    );
  }

  List<Widget> _list(context) {
    var widgets = <Widget>[];
    var _titles = <String>[
      ModuleFlutterLocalizations.of(context)!.theme,
      ModuleFlutterLocalizations.of(context)!.darkMode,
      'VPN',
      ModuleFlutterLocalizations.of(context)!.bottomTabBar,
    ];
    _titles.asMap().forEach((index, title) {
      widgets.add(GestureDetector(
        onTap: () {
          _actions[index](context, title);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: (_titles.length - 1) == index
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black12, width: 0.2),
            ),
          ),
          child: BlocBuilder<DarkModeBloc, DarkModeState>(
            builder: (context, state) => ProfileItem(
              content: Text(
                _titles[index],
              ),
              action: _actionIcons[index](context, state.themeMode),
            ),
          ),
        ),
      ));
    });

    return widgets;
  }
}
