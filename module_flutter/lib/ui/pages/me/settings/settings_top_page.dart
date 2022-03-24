import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/ui/blocs/me/settings/click_sound/click_sound_bloc.dart';
import 'package:vibration/vibration.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/widgets/gitter_webview.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Function> _actionIcons = [
  (BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 2),
          child: const Text(
            '0.00 MB',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black26,
        )
      ],
    );
  },
  (BuildContext context, int index) {
    var _theme = Theme.of(context);
    return SizedBox(
      height: 16,
      child: CupertinoSwitch(
        value: true,
        activeColor: _theme.primaryColor,
        onChanged: (flag) {
          printInfoLog(flag);
        },
      ),
    );
  },
  (BuildContext context, int index) {
    var _theme = Theme.of(context);
    return SizedBox(
      height: 16,
      child: CupertinoSwitch(
        value: true,
        activeColor: _theme.primaryColor,
        onChanged: (flag) async {
          if (flag && await (Vibration.hasVibrator() as Future<bool>)) {
            await Vibration.vibrate();
          }
        },
      ),
    );
  },
  (BuildContext context, int index) {
    var _theme = Theme.of(context);
    return BlocBuilder<ClickSoundBloc, ClickSoundState>(
      builder: (context, state) => SizedBox(
        height: 16,
        child: CupertinoSwitch(
          value: state.switchOn,
          activeColor: _theme.primaryColor,
          onChanged: (flag) {
            BlocProvider.of<ClickSoundBloc>(context)
                .add(ClickSoundInitEvent(flag));
          },
        ),
      ),
    );
  },
  (BuildContext context, int index) {
    var _theme = Theme.of(context);
    return SizedBox(
      height: 16,
      child: CupertinoSwitch(
        value: true,
        activeColor: _theme.primaryColor,
        onChanged: (flag) {
          printInfoLog(flag);
        },
      ),
    );
  }
];

List<Function?> _actions = [
  (BuildContext context, String content) async {
    var prefs = await SharedPreferences.getInstance();
    try {
      final result = await prefs.clear();
      BotToast.showSimpleNotification(
          title:
              result ? ModuleFlutterLocalizations.of(context)!.success : ModuleFlutterLocalizations.of(context)!.failure);
    } catch (e) {
      printErrorLog(e);
    }
  },
  null,
  null,
  null,
  (BuildContext context, String content) {
    NavigatorUtil.push(
      context,
      GitterWebView(content),
    );
  }
];

class SettingsTopPage extends StatelessWidget {
  const SettingsTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _list(context),
    );
  }

  List<Widget> _list(context) {
    var widgets = <Widget>[];
    var _titles = <String>[
      ModuleFlutterLocalizations.of(context)!.clearCache,
      'Handoff',
      ModuleFlutterLocalizations.of(context)!.tactileFeedback,
      ModuleFlutterLocalizations.of(context)!.clickSound,
      ModuleFlutterLocalizations.of(context)!.fullScreenGestureReturn,
    ];
    _titles.asMap().forEach((index, title) {
      widgets.add(GestureDetector(
        onTap: () {
          if (_actions[index] != null) {
            _actions[index]!(context, _titles[index]);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: (_titles.length - 1) == index
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black12, width: 0.2),
            ),
          ),
          child: ProfileItem(
            content: Text(
              _titles[index],
            ),
            action: _actionIcons[index](context, index),
          ),
        ),
      ));
    });

    return widgets;
  }
}
