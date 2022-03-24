import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/ui/blocs/bottom_tabs/bottom_tabs_bloc.dart';
import 'package:module_flutter/ui/blocs/me/l10n/l10n_bloc.dart';
import 'package:module_flutter/ui/blocs/me/settings/click_sound/click_sound_bloc.dart';
import 'package:module_flutter/ui/blocs/me/tabs/tabs_bloc.dart';
import 'package:module_flutter/ui/blocs/me/theme/theme_bloc.dart';
import 'package:module_flutter/ui/blocs/search/search_bloc.dart';
import 'package:provider/single_child_widget.dart';

import 'package:module_flutter/ui/blocs/option/options_bloc.dart';
import 'package:module_flutter/ui/blocs/trending/trending_bloc.dart';
import 'package:module_flutter/ui/blocs/common/sticky_header/sticky_header_bloc.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';

class BlocProviders {
  static List<SingleChildWidget> blocProviders = [
    /// bottom tabs
    BlocProvider<BottomTabsBloc>(
      create: (BuildContext context) => BottomTabsBloc(),
    ),

    /// common
    BlocProvider<OptionsBloc>(
      create: (BuildContext context) => OptionsBloc(),
    ),
    BlocProvider<StickyHeaderBloc>(
      create: (BuildContext context) => StickyHeaderBloc(),
    ),

    /// trending
    BlocProvider<TrendingBloc>(
      create: (BuildContext context) => TrendingBloc(),
    ),

    /// search
    BlocProvider<SearchBloc>(
      create: (BuildContext context) => SearchBloc(),
    ),

    /// me
    /// click sound
    BlocProvider<ClickSoundBloc>(
      create: (BuildContext context) => ClickSoundBloc(),
    ),

    /// theme
    BlocProvider<ThemeBloc>(
      create: (BuildContext context) => ThemeBloc(),
    ),

    /// dark mode
    BlocProvider<DarkModeBloc>(
      lazy: false,
      create: (BuildContext context) => DarkModeBloc(),
    ),

    BlocProvider<TabsBloc>(
      create: (BuildContext context) => TabsBloc(),
    ),

    BlocProvider<L10nBloc>(
      create: (BuildContext context) => L10nBloc(),
    ),
  ];
}
