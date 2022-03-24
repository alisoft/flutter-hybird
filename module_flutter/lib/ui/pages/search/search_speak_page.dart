import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/utils/dark_mode_util.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:module_flutter/ui/blocs/search/search_bloc.dart';
import 'package:module_flutter/ui/plugins/asr_manager.dart';

///语音识别
class SearchSpeakPage extends StatefulWidget {
  const SearchSpeakPage({Key? key}) : super(key: key);

  @override
  _SearchSpeakPageState createState() => _SearchSpeakPageState();
}

class _SearchSpeakPageState extends State<SearchSpeakPage>
    with SingleTickerProviderStateMixin {
  String? speakTips;
  Animation<double>? _animation;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.forward();
        }
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    speakTips = ModuleFlutterLocalizations.of(context)!.searchLongPress;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[_topItem(), _bottomItem()],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _speakStart() async {
    await _controller!.forward();
    setState(() {
      speakTips = ModuleFlutterLocalizations.of(context)!.searchSpeaking;
    });
    try {
      var result = await AsrManager.start();
      if (result.isNotEmpty) {
        BlocProvider.of<SearchBloc>(context)
            .add(SearchInitEvent(text: result, tapped: true));
        NavigatorUtil.pop(context);
      }
    } catch (e) {
      printErrorLog(e);
    }
  }

  void _speakStop() {
    setState(() {
      speakTips = ModuleFlutterLocalizations.of(context)!.searchLongPress;
    });
    _controller!.reset();
    _controller!.stop();
    AsrManager.stop();
  }

  Widget _topItem() {
    return BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) => Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: Text(
                    ModuleFlutterLocalizations.of(context)!.searchSpeakingTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          DarkModeUtil.darkModeColor(context, state.themeMode),
                    ),
                  ),
                ),
                const Text(
                  'realkimmy\n\ngitterapp\n\ngithub',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                )
              ],
            ));
  }

  Widget _bottomItem() {
    var _theme = Theme.of(context);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      speakTips!,
                      style:
                          TextStyle(color: _theme.primaryColor, fontSize: 12),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      const SizedBox(
                        //占坑，避免动画执行过程中导致父布局大小变得
                        height: micSize,
                        width: micSize,
                      ),
                      Center(
                        child: AnimatedMic(
                          animation: _animation!,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                size: 30,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}

const double micSize = 80;

class AnimatedMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: micSize, end: micSize - 20);

  const AnimatedMic({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
          color: _theme.primaryColor,
          borderRadius: BorderRadius.circular(micSize / 2),
        ),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
