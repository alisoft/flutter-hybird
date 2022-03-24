import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:module_flutter/common/iconfonts/iconfonts.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:module_flutter/common/utils/navigator_util.dart';
import 'package:module_flutter/common/utils/object_util.dart';
import 'package:module_flutter/ui/pages/me/user_scanning_result_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UserScanningPage extends StatefulWidget {
  const UserScanningPage({Key? key}) : super(key: key);

  @override
  _UserScanningPageState createState() => _UserScanningPageState();
}

class _UserScanningPageState extends State<UserScanningPage> {
  bool _scanOnce = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQrView(context),
      /// https://github.com/juliuscanute/qr_code_scanner/issues/448
      // body: Stack(
      //   children: <Widget>[
      //     Expanded(flex: 1, child: _buildQrView(context)),
      //     Positioned(
      //       left: MediaQuery.of(context).size.width / 2 - 15,
      //       bottom: 100,
      //       child: InkWell(
      //         onTap: () async {
      //           await controller?.toggleFlash();
      //           setState(() {});
      //         },
      //         child: FutureBuilder<bool?>(
      //           future: controller?.getFlashStatus(),
      //           builder: (context, snapshot) {
      //             if (ObjectUtil.isNull(snapshot.data) || !snapshot.data!) {
      //               return const Icon(
      //                 IconFonts.lights,
      //                 size: 30,
      //               );
      //             }
      //             return const Icon(
      //               IconFonts.dayTimeMode,
      //               size: 30,
      //             );
      //           },
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if(ObjectUtil.isNotNull(scanData) && !_scanOnce) {
        setState(() {
          _scanOnce = true;
        });
        NavigatorUtil.push(context, UserScanningResultPage(result: scanData.code!));
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    printWarningLog('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
