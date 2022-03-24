import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/module_flutter_manager.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/widgets/gitter_inappwebview.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMoreBottomPage extends StatelessWidget {
  const AboutMoreBottomPage({Key? key}) : super(key: key);

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
              NavigatorUtil.push(
                context,
                GitterInAppWebview(
                  url: 'https://github.com/gitterapp/gitterapp-feedback/wiki',
                  title: ModuleFlutterLocalizations.of(context)!.help,
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: Text(
                  ModuleFlutterLocalizations.of(context)!.help,
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
              NavigatorUtil.push(
                context,
                const GitterInAppWebview(
                  url: 'https://gitterapp.com/privacy.html',
                  title: 'Privacy',
                ),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: Text(
                ModuleFlutterLocalizations.of(context)!.privacy,
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
              showAboutDialog(context: context);
            },
            behavior: HitTestBehavior.opaque,
            child: ProfileItem(
              content: Text(
                ModuleFlutterLocalizations.of(context)!.license,
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
      ],
    );
  }
}

void showAboutDialog({
  required BuildContext context,
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return _AboutDialog();
    },
  );
}

class _AboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bodyTextStyle =
        textTheme.bodyText1!.apply(color: colorScheme.onPrimary);

    const name = 'Flutter Boilerplate'; // Don't need to localize.
    const legalese = '© 2019 Ying Wang'; // Don't need to localize.
    const repoText = 'GitHub 代码仓库 $name';
    const seeSource = '要查看此应用的源代码，请访问 $repoText。';
    final repoLinkIndex = seeSource.indexOf(repoText);
    final repoLinkIndexEnd = repoLinkIndex + repoText.length;
    final seeSourceFirst = seeSource.substring(0, repoLinkIndex);
    final seeSourceSecond = seeSource.substring(repoLinkIndexEnd);

    return AlertDialog(
      backgroundColor: colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$name ${ModuleFlutterManager().version}',
              style: textTheme.headline4!.apply(color: colorScheme.onPrimary),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: bodyTextStyle,
                    text: seeSourceFirst,
                  ),
                  TextSpan(
                    style: bodyTextStyle.copyWith(
                      color: colorScheme.primary,
                    ),
                    text: repoText,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'https://github.com/gitterapp/gitter/';
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                          );
                        }
                      },
                  ),
                  TextSpan(
                    style: bodyTextStyle,
                    text: seeSourceSecond,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              legalese,
              style: bodyTextStyle,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Typography.material2018(
                    platform: Theme.of(context).platform,
                  ).black,
                  scaffoldBackgroundColor: Colors.white,
                ),
                child: LicensePage(
                  applicationName: name,
                  applicationVersion: ModuleFlutterManager().version,
                  applicationIcon: Image.network(
                    'https://cdn.gitterapp.com/logo/gitter.png',
                    width: 60,
                    height: 60,
                  ),
                  applicationLegalese: legalese,
                ),
              ),
            ));
          },
          child: Text(
            MaterialLocalizations.of(context).viewLicensesButtonLabel,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
      ],
    );
  }
}
