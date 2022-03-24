import 'package:flutter/material.dart' hide Tab;
import 'package:module_flutter/common/iconfonts/iconfonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/me/tabs/tabs_bloc.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';

class SettingsBottomBarPage extends StatefulWidget {
  const SettingsBottomBarPage({Key? key}) : super(key: key);

  @override
  _SettingsBottomBarPageState createState() => _SettingsBottomBarPageState();
}

class _SettingsBottomBarPageState extends State<SettingsBottomBarPage> {
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
        title: const Text(
          '自定义底部栏',
        ),
        actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => NavigatorUtil.pop(context),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 6, 4),
              child: Icon(
                Icons.check,
                size: 24,
                color: Colors.lightBlue,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) => BlocBuilder<TabsBloc, TabsState>(
          builder: (context, tabState) => ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                var _tabs = tabState.tabs.sublist(0);
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = _tabs.removeAt(oldIndex);
                _tabs.insert(newIndex, item);
                BlocProvider.of<TabsBloc>(context).add(TabChangedEvent(_tabs));
              });
            },
            children: tabState.tabs
                .map(
                  (tab) => Container(
                    key: Key(tab.text!),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 0.2),
                      ),
                    ),
                    child: ProfileItem(
                      content: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          tab.text!,
                          style: TextStyle(
                            color: DarkModeUtil.isDarkMode(
                                    context, state.themeMode)
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: Icon(
                          IconFont(tab.iconData!,
                              matchTextDirection: true),
                          size: 20,
                          color:
                              DarkModeUtil.isDarkMode(context, state.themeMode)
                                  ? Colors.grey
                                  : Colors.black87,
                        ),
                      ),
                      action: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.list,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
