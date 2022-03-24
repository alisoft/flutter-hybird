import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/pages/me/about/about_more_schemes_page.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:share_plus/share_plus.dart';

class AboutMoreTopPage extends StatelessWidget {
  const AboutMoreTopPage({Key? key}) : super(key: key);

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
            onTap: () {
              // TODO: do something.
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: Text(
                ModuleFlutterLocalizations.of(context)!.author,
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
        Container(
          decoration: _decoration,
          child: GestureDetector(
            onTap: () {
              NavigatorUtil.push(context, const AboutMoreSchemesPage());
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: const Text(
                'URL Schemes',
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
        Container(
          decoration: _decoration,
          child: GestureDetector(
            onTap: () async {
              final inAppReview = InAppReview.instance;

              if (await inAppReview.isAvailable()) {
                await inAppReview.requestReview();
              } else {
                StoreRedirect.redirect(
                    androidAppId: 'com.upcwangying.apps.flutter.boilerplate&hl=ko',
                    iOSAppId: '1591788003');
              }
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: Text(
                ModuleFlutterLocalizations.of(context)!.scoring,
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
          onTap: () {
            Share.share('https://boilerplate.gitter.app');
          },
          behavior: HitTestBehavior.opaque,
          child: ProfileItem(
            content: Text(
              ModuleFlutterLocalizations.of(context)!.share,
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
