import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/mock/dark_modes.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';

class SettingsDarkModePage extends StatefulWidget {
  final String headerTitle;

  const SettingsDarkModePage({Key? key, required this.headerTitle})
      : super(key: key);

  @override
  _SettingsDarkModePageState createState() => _SettingsDarkModePageState();
}

class _SettingsDarkModePageState extends State<SettingsDarkModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          widget.headerTitle,
        ),
      ),
      body: BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) => Container(
          margin: const EdgeInsets.only(left: 6, right: 6),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) =>
                RadioListTile<ThemeMode?>(
              groupValue: state.themeMode,
              title: Text(darkModes[index]['title'] as String),
              value: darkModes[index]['mode'] as ThemeMode?,
              onChanged: (value) {
                BlocProvider.of<DarkModeBloc>(context).add(
                    DarkModeInitEvent(themeMode: darkModes[index]['mode'] as ThemeMode?));
              },
            ),
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: darkModes.length,
          ),
        ),
      ),
    );
  }
}
