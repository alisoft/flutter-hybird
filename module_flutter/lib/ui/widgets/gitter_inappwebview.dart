import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';

class GitterInAppWebview extends StatefulWidget {
  final String url;
  final String? title;

  const GitterInAppWebview({Key? key, required this.url, this.title})
      : super(key: key);

  @override
  _GitterInAppWebviewState createState() => _GitterInAppWebviewState();
}

class _GitterInAppWebviewState extends State<GitterInAppWebview> {
  late InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            if (await webView.canGoBack()) {
              await webView.goBack();
            } else {
              NavigatorUtil.pop(context);
            }
          },
          child: Icon(
            Icons.arrow_back,
            color: _theme.primaryColor,
          ),
        ),
        title: Text(widget.title!),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(),
          ios: IOSInAppWebViewOptions(),
          android: AndroidInAppWebViewOptions(useHybridComposition: true),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webView = controller;
        },
        onProgressChanged: (controller, progress) {},
      ),
    );
  }
}
