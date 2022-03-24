import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/l10n/l10n_bloc.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';

List<Function> _actionIcons = [
  (BuildContext context, ThemeMode? themeMode) => Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 2),
            child: const Text(
              '跟随系统',
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
      ),
];

const List<String> _titleKeys = [
  'tabMeSettingsLanguage',
];

List<Function> _actions = [
  (BuildContext context) {
    _showDialog(context);
  }
];

class SettingsBottomPage extends StatelessWidget {
  const SettingsBottomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _list(context),
    );
  }

  List<Widget> _list(context) {
    var widgets = <Widget>[];

    _titleKeys.asMap().forEach((index, titleKey) {
      widgets.add(GestureDetector(
        onTap: () {
          _actions[index](context);
        },
        child: BlocBuilder<DarkModeBloc, DarkModeState>(
          builder: (context, state) => Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: (_titleKeys.length - 1) == index
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black12, width: 0.2),
              ),
            ),
            child: ProfileItem(
              content: Text(
                ModuleFlutterLocalizations.of(context)!.languages,
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

void _showDialog(BuildContext context) {
  showCupertinoModalPopup<int>(
      context: context,
      builder: (context) {
        var dialog = CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              NavigatorUtil.pop(context);
            },
            child: const Text('Cancel'),
          ),
          actions: _languageWidgets(context),
        );
        return dialog;
      });
}

List<Widget> _languageWidgets(BuildContext context) {
  var localeNames = ModuleFlutterLocalizations.supportedLocales
      .map((locale) => locale.toString())
      .toList();
  localeNames.insert(0, '');
  var widgets = <Widget>[];
  localeNames.asMap().forEach((index, languageKey) {
    widgets.add(CupertinoActionSheetAction(
      onPressed: () {
        BlocProvider.of<L10nBloc>(context)
            .add(L10nInitEvent(localeName: languageKey));
        Navigator.pop(context, 3);
      },
      child: Text(StringUtil.isBlank(languageKey) ? '跟随系统' : languageKey),
    ));
  });
  return widgets;
}
