import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMoreCenterPage extends StatelessWidget {
  const AboutMoreCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Decoration _decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black12, width: 0.2)),
    );

    return Column(
      children: <Widget>[
        Container(
          decoration: _decoration,
          child: GestureDetector(
            onTap: () async {
              const url =
                  'mqq://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=179413818';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                printErrorLog('Could not launch $url');
              }
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: Text(
                ModuleFlutterLocalizations.of(context)!.qqGroup,
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
        ),
        GestureDetector(
          onTap: () async {
            const url = 'tg://msg?text=Mi_mensaje&to=+1555999';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              printErrorLog('Could not launch $url');
            }
          },
          behavior: HitTestBehavior.opaque,
          child: ProfileItem(
            content: const Text(
              'Telegram',
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
      ],
    );
  }
}
