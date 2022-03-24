import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final Widget? leading;
  final Widget content;
  final Widget? action;

  const ProfileItem({
    Key? key,
    required this.content,
    this.leading,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 14),
      child: Row(
        children: _list,
      ),
    );
  }

  List<Widget> get _list {
    var widgets = <Widget>[];
    if (leading != null) {
      widgets.insert(0, leading!);
    }
    widgets.add(Expanded(
      child: content,
    ));
    if (action != null) {
      widgets.add(action!);
    }
    return widgets;
  }
}
