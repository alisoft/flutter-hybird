import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum AppBarBehavior { normal, pinned, floating, snapping }

class AboutMoreAuthorPage extends StatefulWidget {
  final String? headerTitle;

  const AboutMoreAuthorPage({Key? key, this.headerTitle}) : super(key: key);

  @override
  AboutMoreAuthorPageState createState() => AboutMoreAuthorPageState();
}

class AboutMoreAuthorPageState extends State<AboutMoreAuthorPage> {
  final double _appBarHeight = 256.0;

  final AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    var horizontal = MediaQuery.of(context).viewPadding.top;
    final _theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight + horizontal,
            pinned: _appBarBehavior == AppBarBehavior.pinned,
            floating: _appBarBehavior == AppBarBehavior.floating ||
                _appBarBehavior == AppBarBehavior.snapping,
            snap: _appBarBehavior == AppBarBehavior.snapping,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Ying Wang',
                style: TextStyle(
                  color: _theme.primaryColor,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    'https://cdn.upcwangying.com/logo/avatar.JPG',
                    fit: BoxFit.cover,
                    height: _appBarHeight,
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: _ContactCategory(
                  icon: FontAwesomeIcons.sitemap,
                  children: <Widget>[
                    _ContactItem(
                      icon: FontAwesomeIcons.home,
                      tooltip: 'HomePage',
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('https://upcwangying.com.'),
                        ));
                      },
                      lines: const <String>[
                        'https://upcwangying.com',
                        'HomePage',
                      ],
                    ),
                    _ContactItem(
                      icon: FontAwesomeIcons.github,
                      tooltip: 'GitHub',
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('https://github.com/realkimmy.'),
                        ));
                      },
                      lines: const <String>[
                        'https://github.com/realkimmy',
                        'GitHub',
                      ],
                    ),
                    _ContactItem(
                      icon: FontAwesomeIcons.git,
                      tooltip: 'Gitee',
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('https://gitee.com/upcwangying.'),
                        ));
                      },
                      lines: const <String>[
                        'https://gitee.com/upcwangying',
                        'Gitee',
                      ],
                    ),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class _ContactCategory extends StatelessWidget {
  const _ContactCategory({Key? key, this.icon, this.children}) : super(key: key);

  final IconData? icon;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: const TextStyle(),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                width: 72.0,
                child: Icon(icon, color: themeData.primaryColor),
              ),
              Expanded(child: Column(children: children!)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem(
      {Key? key, this.icon, required this.lines, this.tooltip, this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData? icon;
  final List<String> lines;
  final String? tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...lines.sublist(0, lines.length - 1).map<Widget>(
                        (String line) => Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          text: line,
                          style: _theme.textTheme.caption,
                          linkStyle: TextStyle(color: _theme.primaryColor),
                        ),
                      ),
                  Text(lines.last, style: _theme.textTheme.caption),
                ],
              ),
            ),
            if (icon != null)
              SizedBox(
                width: 72.0,
                child: IconButton(
                  icon: Icon(icon),
                  color: _theme.primaryColor,
                  onPressed: onPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
