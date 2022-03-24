import 'dart:async';

import 'package:flutter/material.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/string_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GitterWebView extends StatefulWidget {
  final String url;
  final String? title;

  const GitterWebView(this.url, {Key? key, this.title}) : super(key: key);

  @override
  _GitterWebViewState createState() => _GitterWebViewState();
}

class _GitterWebViewState extends State<GitterWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.close,
            size: 24,
          ),
        ),
        title: Text(
          widget.title == null
              ? (widget.url).replaceFirst('https://', StringUtil.empty).replaceFirst('http://', StringUtil.empty)
              : widget.title!,
        ),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            printWarningLog('Loading');
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
//          navigationDelegate: (NavigationRequest request) {
//            if (request.url.startsWith('https://upcwangying.com/')) {
//              printWarningLog('blocking navigation to $request}');
//              return NavigationDecision.prevent;
//            }
//            printWarningLog('allowing navigation to $request');
//            return NavigationDecision.navigate;
//          },
          onPageFinished: (String url) {
            printWarningLog('Page finished loading: $url');
          },
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture, {Key? key}) : super(key: key);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No back history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No forward history item')),
                        );
                        return;
                      }
                    },
            ),
//            IconButton(
//              icon: const Icon(Icons.replay, size: 20,),
//              onPressed: !webViewReady
//                  ? null
//                  : () {
//                controller.reload();
//              },
//            ),
          ],
        );
      },
    );
  }
}
