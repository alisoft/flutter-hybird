import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/ui/blocs/me/theme/theme_bloc.dart';

const int defaultThemeColor = 0xfffe9401;

class DialogUtil {
  static showChangeThemeDialog(BuildContext context) {
    var _theme = Theme.of(context);
    var _color = defaultThemeColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ModuleFlutterLocalizations.of(context)!.theme),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _theme.primaryColor,
            onColorChanged: (Color color) {
              _color = color.value;
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context)
                  .add(const ThemeChangedEvent(color: defaultThemeColor));
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<ThemeBloc>(context)
                  .add(ThemeChangedEvent(color: _color));
              Navigator.of(context).pop();
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
