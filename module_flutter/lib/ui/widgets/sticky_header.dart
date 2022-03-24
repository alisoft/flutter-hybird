import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:module_flutter/ui/blocs/common/sticky_header/sticky_header_bloc.dart';

class StickyHeader extends StatefulWidget {
  final String currentSinceName;
  final String currentLanguage;
  final bool showSortBtn;
  final Function? sortBtnCallBack;

  const StickyHeader({
    Key? key,
    required this.currentSinceName,
    required this.currentLanguage,
    this.showSortBtn = true,
    this.sortBtnCallBack,
  }) : super(key: key);

  @override
  _StickyHeaderState createState() => _StickyHeaderState();
}

class _StickyHeaderState extends State<StickyHeader> {
  int _quarterTurns = 0;

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
      color: _theme.backgroundColor,
      padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
      height: 24,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _headerContentChildren(),
      ),
    );
  }

  List<Widget> _headerContentChildren() {
    var widgets = <Widget>[];
    widgets.add(BlocBuilder<StickyHeaderBloc, StickyHeaderState>(
      builder: (context, state) => Text(
        '$_currentLanguageName | ${widget.showSortBtn ? state.isDesc! ? ' 最多 ' : ' 最少 ' : StringUtil.space}${widget.currentSinceName}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ));

    if (widget.showSortBtn) {
      widgets.add(GestureDetector(
        onTap: _toggleSortStatus,
        child: Container(
          padding: const EdgeInsets.fromLTRB(2, 2, 6, 2),
          height: 24,
          width: 26,
          child: RotatedBox(
            quarterTurns: _quarterTurns,
            child: const Icon(
              Icons.sort,
              size: 18,
            ),
          ),
        ),
      ));
    }
    return widgets;
  }

  String get _currentLanguageName {
    return widget.currentLanguage.isEmpty ? '所有语言' : widget.currentLanguage;
  }

  void _toggleSortStatus() {
    setState(() {
      _quarterTurns = _quarterTurns + 2;
    });
    BlocProvider.of<StickyHeaderBloc>(context)
      .add(StickyHeaderSortToggleEvent());

    if (widget.sortBtnCallBack != null) {
      widget.sortBtnCallBack!();
    }
  }
}
