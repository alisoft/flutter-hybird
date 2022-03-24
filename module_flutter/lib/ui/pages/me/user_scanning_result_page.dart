import 'package:flutter/material.dart';

class UserScanningResultPage extends StatefulWidget {
  final String result;
  const UserScanningResultPage({Key? key, required this.result}) : super(key: key);

  @override
  _UserScanningResultPageState createState() => _UserScanningResultPageState();
}

class _UserScanningResultPageState extends State<UserScanningResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanning Result'),
      ),
      body: Center(
        child: Text(widget.result),
      ),
    );
  }
}
