import 'package:module_flutter/common/enums/trending_option_tabs.dart';

/// home
class HomeConstants {
  static const List<TrendingOptionTabs> dialogTabs = TrendingOptionTabs.values;

  static const String module = 'Home';

  static const List<String> dialogTabNames = ['今日', '本周', '本月'];

  static const trendingRepositorySince = 'TRENDING_REPOSITORY_SINCE';
  static const trendingRepositoryLanguage = 'TRENDING_REPOSITORY_LANGUAGE';
  static const trendingDeveloperSince = 'TRENDING_DEVELOPER_SINCE';
  static const trendingDeveloperLanguage = 'TRENDING_DEVELOPER_LANGUAGE';

}
