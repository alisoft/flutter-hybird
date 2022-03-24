import 'dart:io';
import 'package:flutter_gen/gen_l10n/module_flutter_localizations.dart';
import 'package:module_flutter/common/module_flutter_manager.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:module_flutter/common/utils/device_info.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';

class SettingsFeedbackPage extends StatefulWidget {
  const SettingsFeedbackPage({Key? key}) : super(key: key);

  @override
  _SettingsFeedbackPageState createState() => _SettingsFeedbackPageState();
}

class _SettingsFeedbackPageState extends State<SettingsFeedbackPage> {
  String _deviceInfo = StringUtil.empty;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _initDeviceInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          ModuleFlutterLocalizations.of(context)!.feedback,
        ),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            minLines: 8,
            maxLines: 8,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 2, 5, 0),
              hintText: '问题内容',
              hintStyle: TextStyle(fontSize: 14),
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              '运行环境: $_deviceInfo',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 16),
            width: MediaQuery.of(context).size.width - 60,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(_theme.primaryColor),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                // TODO: do something.
              },
              child: Text(ModuleFlutterLocalizations.of(context)!.submit),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(top: 10, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(ModuleFlutterLocalizations.of(context)!.tips),
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'gitterapp/gitterapp-feedback',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (await canLaunch(
                                'https://github.com/gitterapp/gitterapp-feedback')) {
                              await launch(
                                  'https://github.com/gitterapp/gitterapp-feedback');
                            }
                          },
                        style: TextStyle(
                          color: _theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _initDeviceInfo() {
    var deviceInfo = StringUtil.empty;
    DeviceInfo.initPlatformState().then((deviceData) {
      if (deviceData != null && deviceData['Error'] == null) {
        if (Platform.isAndroid) {
          deviceInfo =
              '${deviceData['model']} - Android ${deviceData['version.release']} - ${ModuleFlutterManager().version}+${ModuleFlutterManager().buildNumber}';
        } else if (Platform.isIOS) {
          deviceInfo =
              '${deviceData['name']} - ${deviceData['systemName']} ${deviceData['systemVersion']} - ${ModuleFlutterManager().version}+${ModuleFlutterManager().buildNumber}';
        }
      }

      setState(() {
        _deviceInfo = deviceInfo;
      });
    }).catchError((error) async {
      printErrorLog(error);
    });
  }
}
