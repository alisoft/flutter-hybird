import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class _LinkTextSpan extends TextSpan {

  _LinkTextSpan({ TextStyle? style, String? url, String? text }) : super(
    style: style,
    text: text ?? url,
    recognizer: TapGestureRecognizer()..onTap = () {
      launch(url!, forceSafariVC: false);
    }
  );
}

void showGalleryAboutDialog(BuildContext context) {

  showAboutDialog(
    context: context,
    applicationVersion: 'January 2019',
    applicationIcon: const FlutterLogo(),
    applicationLegalese: '© 2019 The Gitter Authors',
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Flutter is an open-source project to help developers '
                      'build high-performance, high-fidelity, mobile apps for '
                      '${defaultTargetPlatform == TargetPlatform.iOS ? 'multiple platforms' : 'iOS and Android'} '
                      'from a single codebase. This design lab is a playground '
                      "and showcase of Flutter's many widgets, behaviors, "
                      'animations, layouts, and more. Learn more about Flutter at ',
              ),
              _LinkTextSpan(
                url: 'https://gitterapp.com',
              ),
              const TextSpan(
                text: '.\n\nTo see the source code for this app, please visit the ',
              ),
              _LinkTextSpan(
                url: 'https://goo.gl/iv1p4G',
                text: 'flutter github repo',
              ),
              const TextSpan(
                text: '.',
              ),
            ],
          ),
        ),
      ),
    ],
    applicationName: 'Gitter'
  );
}
