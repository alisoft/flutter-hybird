import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/constant/search_constants.dart';
import 'package:module_flutter/common/utils/cache_util.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/search/search_bloc.dart';
import 'package:module_flutter/ui/pages/search/search_history_page.dart';
import 'package:module_flutter/ui/pages/search/search_speak_page.dart';
import 'package:module_flutter/ui/widgets/profile_item.dart';
import 'package:module_flutter/ui/widgets/search.dart';

List<Function> _categories = [
  (BuildContext context, String value) =>
      ModuleFlutterLocalizations.of(context)!.searchWithRepo(value),
  (BuildContext context, String value) =>
      ModuleFlutterLocalizations.of(context)!.searchWithIssues(value),
  (BuildContext context, String value) =>
      ModuleFlutterLocalizations.of(context)!.searchWithPulls(value),
  (BuildContext context, String value) =>
      ModuleFlutterLocalizations.of(context)!.searchWithPeople(value),
  (BuildContext context, String value) =>
      ModuleFlutterLocalizations.of(context)!.searchWithOrg(value),
  (BuildContext context, String value) =>
      ModuleFlutterLocalizations.of(context)!.searchJumpTo(value),
];

List<Function> _actions = [
  (BuildContext context, String searchText) {
    // TODO: do something.
  },
  (BuildContext context, String searchText) {
    // TODO: do something.
  },
  (BuildContext context, String searchText) {
    // TODO: do something.
  },
  (BuildContext context, String searchText) {
    // TODO: do something.
  },
  (BuildContext context, String searchText) {
    // TODO: do something.
  },
  (BuildContext context, String searchText) {
    // TODO: do something.
  },
];

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    BlocProvider.of<SearchBloc>(context)
        .add(const SearchInitEvent(text: StringUtil.empty));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Search(
                    autoFocus: false,
                    hideLeft: true,
                    hideRight: true,
                    hideSpeak: false,
                    tapped: state.tapped,
                    hint: ModuleFlutterLocalizations.of(context)!.searchHit,
                    defaultText: state.text,
                    speakClick: () {
                      NavigatorUtil.push(context, const SearchSpeakPage());
                    },
                    onChanged: (value) {
                      BlocProvider.of<SearchBloc>(context)
                          .add(SearchInitEvent(text: value));
                    },
                    onSubmitted: (value) async {
                      if (StringUtil.isNotBlank(value)) {
                        await _saveKeywords(value);
                        // TODO: do something.
                      }
                    },
                  ),
                ),
                Expanded(
                  child: _content(state.text),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _content(String searchText) {
    return StringUtil.isBlank(searchText)
        ? const Padding(
            padding: EdgeInsets.only(top: 20),
            child: SearchHistoryPage(),
          )
        : _searchPanel(searchText);
  }

  Widget _searchPanel(String searchText) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () async {
          await _saveKeywords(searchText);
          _actions[index](context, searchText);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: BlocBuilder<DarkModeBloc, DarkModeState>(
            builder: (context, state) => ProfileItem(
              // leading: Padding(
              //   padding: const EdgeInsets.only(right: 16),
              //   child: Icon(
              //     _leadingIcons[index],
              //     size: 16,
              //   ),
              // ),
              content: Text(
                '${_categories[index](context, searchText)}',
              ),
              action: Icon(
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
      itemCount: _categories.length,
      separatorBuilder: (BuildContext context, int index) => const Padding(
        padding: EdgeInsets.only(left: 48),
        child: Divider(),
      ),
    );
  }

  Future<void> _saveKeywords(String searchText) async {
    var keywords = await _fetchKeyWords();
    keywords.remove(searchText);
    keywords.insert(0, searchText);
    await CacheUtil.setCache(SearchConstants.searchKeywords, keywords);
  }

  Future<List<String>> _fetchKeyWords() async {
    final keywords = await CacheUtil.getCache(SearchConstants.searchKeywords,
        checkValidTimes: false, converter: _converterDataList);
    return keywords ?? [];
  }

  List<String>? _converterDataList(dataList) {
    return (dataList as List).map((json) => '$json').toList();
  }

  @override
  bool get wantKeepAlive => true;
}
