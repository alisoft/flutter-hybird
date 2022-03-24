import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/string_util.dart';

class Search extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final bool hideRight;
  final bool hideSpeak;
  final bool hideSearchIcon;
  final bool autoFocus;
  final bool tapped;
  final String? hint;
  final String? defaultText;
  final Function? leftButtonClick;
  final Function? rightButtonClick;
  final Function? speakClick;
  final Function? inputBoxClick;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const Search({
    Key? key,
    this.enabled = true,
    this.hideLeft = false,
    this.hideRight = false,
    this.hideSpeak = true,
    this.hideSearchIcon = false,
    this.autoFocus = true,
    this.tapped = false,
    this.hint,
    this.defaultText,
    this.leftButtonClick,
    this.rightButtonClick,
    this.speakClick,
    this.inputBoxClick,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  bool showClear = false;

  @override
  void initState() {
    _setTextField();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Search oldWidget) {
    if(widget.tapped) {
      _setTextField();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _genNormalSearch();
  }

  void _setTextField() {
    var keyword = widget.defaultText ?? StringUtil.empty;
    setState(() {
      _controller.text = keyword;
      showClear = keyword.isNotEmpty;
    });
  }

  Widget _genNormalSearch() {
    return Row(
      children: <Widget>[
        _warpTap(
          Container(
            padding: widget.hideLeft
                ? const EdgeInsets.all(5)
                : const EdgeInsets.fromLTRB(6, 5, 10, 5),
            child: widget.hideLeft
                ? null
                : const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 26,
                  ),
          ),
          widget.leftButtonClick as void Function()?,
        ),
        Expanded(flex: 1, child: _inputBox()),
        _warpTap(
          Container(
            padding: widget.hideRight
                ? const EdgeInsets.all(5)
                : const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: widget.hideRight
                ? null
                : Text(
                    ModuleFlutterLocalizations.of(context)!.searchHit,
                    style: const TextStyle(color: Colors.blue, fontSize: 17),
                  ),
          ),
          widget.rightButtonClick as void Function()?,
        ),
      ],
    );
  }

  Widget _warpTap(Widget child, void Function()? callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }

  Widget _inputBox() {
    return Container(
      height: 30,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Color(int.parse('0xffEDEDED')),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: _content,
      ),
    );
  }

  List<Widget> get _content {
    var _theme = Theme.of(context);
    var widgets = <Widget>[];
    if (!widget.hideSearchIcon) {
      widgets.add(Icon(
        Icons.search,
        size: 20,
        color: Color(int.parse('0xffA9A9A9')),
      ));
    }

    widgets.add(Expanded(
      flex: 1,
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
        autocorrect: false,
        autofocus: widget.autoFocus,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(5, -20, 5, 0),
          border: InputBorder.none,
          hintText: widget.hint ?? StringUtil.empty,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: _theme.primaryColor,
          ),
        ),
      ),
    ));

    widgets.add(_inputClear);

    return widgets;
  }

  Widget get _inputClear {
    var _theme = Theme.of(context);
    return !showClear
        ? widget.hideSpeak
            ? Container()
            : _warpTap(
                Icon(
                  Icons.mic,
                  size: 22,
                  color: _theme.primaryColor,
                ),
                widget.speakClick as void Function()?,
              )
        : _warpTap(
      const Icon(
              Icons.clear,
              size: 22,
              color: Colors.grey,
            ),
            () {
              _controller.clear();
              _onChanged(StringUtil.empty);
              // _onSubmitted(StringUtil.STRING_EMPTY);
            },
          );
  }

  void _onChanged(String text) {
    if (text.isNotEmpty) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }

    if (widget.onChanged != null) {
      widget.onChanged!(text);
    }
  }

  void _onSubmitted(String value) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
