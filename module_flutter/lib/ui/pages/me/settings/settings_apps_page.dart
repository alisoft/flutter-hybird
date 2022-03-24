import 'dart:io';

import 'package:flutter/material.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:mop/mop.dart';

class SettingsAppsPage extends StatefulWidget {
  const SettingsAppsPage({Key? key}) : super(key: key);

  @override
  _SettingsAppsPageState createState() => _SettingsAppsPageState();
}

class _SettingsAppsPageState extends State<SettingsAppsPage> {

  @override
  void initState() {
    super.initState();
    initMop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Apps'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Mop.instance.openApplet('61e2e32a8bc99400018e1ded');
          },
          child: const Text(
            '打开示例小程序',
          ),
        ),
      ),
    );
  }

  Future<void> initMop() async {
    if (Platform.isIOS) {
      //com.finogeeks.mopExample
      final res = await Mop.instance.initialize(
          'O1uNEOQhAp44mB1QSXjv28lAQMuuHw0azx8SPG7Ln5hFaONunbOvr6rhripZYaKLoAOMfiVoe4YTUuWjudgRbA==', '30323921d8aaf082',
          apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
      printInfoLog(res);
    } else if (Platform.isAndroid) {
      //com.finogeeks.mopexample
      final res = await Mop.instance.initialize(
          'O1uNEOQhAp44mB1QSXjv28lAQMuuHw0azx8SPG7Ln5hFaONunbOvr6rhripZYaKLoAOMfiVoe4YTUuWjudgRbA==', '30323921d8aaf082',
          apiServer: 'https://api.finclip.com', apiPrefix: '/api/v1/mop');
      printInfoLog(res);
    }
    if (!mounted) return;
  }

}
