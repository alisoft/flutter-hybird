import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';

const List<String> titles = [
  'Open User',
  'Open Repository',
  'Open Commit',
  'Open Issues',
  'Open Pull Request',
];

const List<String> descriptions = [
  'flutter_boilerplate://user?login=',
  'flutter_boilerplate://repo?owner=&repo=',
  'flutter_boilerplate://commit?owner=&repo=&sha=',
  'flutter_boilerplate://issues?owner=&repo=&number=',
  'flutter_boilerplate://pull?owner=&repo=&number=',
];

class AboutMoreSchemesPage extends StatelessWidget {
  const AboutMoreSchemesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const EdgeInsetsGeometry _padding = EdgeInsets.only(left: 14, right: 8);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: const Text(
          'URL Schemes',
        ),
      ),
      body: BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) => Container(
          padding: _padding,
          child: Column(
            children: _list(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _list(BuildContext context) {
    var widgets = <Widget>[];
    titles.asMap().forEach((index, title) {
      widgets.add(Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: titles.length - 1 == index
                ? BorderSide.none
                : const BorderSide(color: Colors.black12, width: 0.2),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: descriptions[index]))
                .then((v) {
              BotToast.showCustomNotification(
                  toastBuilder: (cancelFunc) => Container(
                        margin: const EdgeInsets.only(left: 16, right: 8),
                        decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ProfileItem(
                          content: Text(
                              ModuleFlutterLocalizations.of(context)!.copyText,
                            style: const TextStyle(color: Colors.white),
                          ),
                          leading: Container(
                            padding: const EdgeInsets.only(left: 4, right: 6),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ));
            }).catchError((error) async {
              printErrorLog(error);
            });
          },
          behavior: HitTestBehavior.opaque,
          child: ProfileItem(
            content: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    descriptions[index],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            action: BlocBuilder<DarkModeBloc, DarkModeState>(
              builder: (context, state) => Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: DarkModeUtil.isDarkMode(context, state.themeMode)
                    ? Colors.white24
                    : Colors.black26,
              ),
            ),
          ),
        ),
      ));
    });

    return widgets;
  }
}
