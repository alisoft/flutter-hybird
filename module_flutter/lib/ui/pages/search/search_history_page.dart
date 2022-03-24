import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:module_flutter/common/constant/search_constants.dart';
import 'package:module_flutter/common/utils/cache_util.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';

class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({Key? key}) : super(key: key);

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  List<String>? _keywords;

  @override
  void initState() {
    _initKeyWords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _buildKeywords,
    );
  }

  Widget get _buildKeywords {
    return BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (context, darkModeState) => Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView.separated(
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _onKeywordTap(_keywords![index]),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    label: 'Delete',
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    onPressed: (context) {},
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(_keywords![index]),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: DarkModeUtil.isDarkMode(
                                context, darkModeState.themeMode)
                            ? Colors.white24
                            : Colors.black26,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: _keywords?.length ?? 0,
        ),
      ),
    );
  }

  Future<void> _saveKeywords(String searchText) async {
    var keywords = await _fetchKeyWords();
    keywords.remove(searchText);
    await CacheUtil.setCache(SearchConstants.searchKeywords, keywords);
  }

  Future<List<String>> _fetchKeyWords() async {
    final keywords = await CacheUtil.getCache(SearchConstants.searchKeywords,
        checkValidTimes: false, converter: _converterDataList);
    return keywords ?? [];
  }

  Future<void> _initKeyWords() async {
    final keywords = await _fetchKeyWords();
    setState(() {
      _keywords = keywords;
    });
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  List<String>? _converterDataList(dataList) {
    return (dataList as List).map((json) => '$json').toList();
  }

  void _onKeywordTap(keyword) {
    // TODO: do something.
  }
}
