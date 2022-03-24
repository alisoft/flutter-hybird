import 'package:flutter/material.dart';
import 'package:module_flutter/common/enums/home_types.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/pages/home/live_page.dart';
import 'package:module_flutter/ui/pages/home/news_page.dart';
import 'package:module_flutter/ui/pages/home/notifiactions_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/ui/blocs/trending/trending_bloc.dart';

const List<String> tabs = [
  HomeType.news,
  HomeType.notifications,
  HomeType.live
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _controller;

  @override
  void initState() {
    final trendingBloc = BlocProvider.of<TrendingBloc>(context);
    final currentTab = trendingBloc.state.currentTab;
    _controller = TabController(
        initialIndex: tabs.indexOf(currentTab!), length: tabs.length, vsync: this)
      ..addListener(() {
        final currentTab = tabs[_controller!.index];
        BlocProvider.of<TrendingBloc>(context)
            .add(TrendingAddEvent(currentTab));
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: BlocBuilder<DarkModeBloc, DarkModeState>(builder: (context, state) => TabBar(
            tabs: tabs.map((e) => Text(e)).toList(),
            indicatorColor: _theme.primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: const EdgeInsets.only(top: 8),
            labelColor: _theme.primaryColor,
            unselectedLabelColor: DarkModeUtil.darkModeColor(context, state.themeMode),
            isScrollable: true,
            controller: _controller,
          ),),
        ),
        actions: [
          GestureDetector(
            onTap: () => {},
            child: Container(
              padding: const EdgeInsets.only(right: 14),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 24,
              ),
            ),
          )
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          NewsPage(),
          NotificationsPage(),
          LivePage(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
