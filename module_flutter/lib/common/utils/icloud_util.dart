import 'dart:async';

import 'package:flutter/services.dart';
import 'package:module_flutter/common/config/module_flutter_config.dart';
import 'package:module_flutter/common/utils/logger_util.dart';
import 'package:icloud_storage/icloud_storage.dart';

class ICloudUtil {

  static Future<void> downloadFileFormICloud(String fileName, String destinationFilePath) async {
    try {
      final iCloudStorage =
          await ICloudStorage.getInstance(ModuleFlutterConfig.iCloudContainerId);
      StreamSubscription<double>? downloadProgressSubscription;
      var isDownloadComplete = false;

      await iCloudStorage.startDownload(
        fileName: fileName,
        destinationFilePath: destinationFilePath,
        onProgress: (stream) {
          downloadProgressSubscription = stream.listen(
            (progress) => printInfoLog('--- Download File --- progress: $progress'),
            onDone: () async {
              isDownloadComplete = true;
              printInfoLog('--- Download File --- done');
            },
            onError: (err) async {
              printErrorLog('--- Download File --- error: $err');
            },
            cancelOnError: true,
          );
        },
      );

      Future.delayed(const Duration(seconds: 20), () async {
        if (!isDownloadComplete) {
          await downloadProgressSubscription?.cancel();
          printErrorLog('--- Download File --- timed out');
        }
      });
    } catch (err) {
      await _handleError(err);
    }
  }

  static Future<void> uploadFileToICloud(String destinationFilePath, String fileName) async {
    try {
      final iCloudStorage =
          await ICloudStorage.getInstance(ModuleFlutterConfig.iCloudContainerId);
      StreamSubscription<double>? uploadProgressSubscription;
      var isUploadComplete = false;

      await iCloudStorage.startUpload(
        filePath: destinationFilePath,
        destinationFileName: fileName,
        onProgress: (stream) {
          uploadProgressSubscription = stream.listen(
            (progress) => printInfoLog('--- Upload File --- progress: $progress'),
            onDone: () {
              isUploadComplete = true;
              printInfoLog('--- Upload File --- done');
            },
            onError: (err) => printErrorLog('--- Upload File --- error: $err'),
            cancelOnError: true,
          );
        },
      );

      Future.delayed(const Duration(seconds: 10), () {
        if (!isUploadComplete) {
          uploadProgressSubscription?.cancel();
          printErrorLog('--- Upload File --- timed out');
        }
      });
    } catch (err) {
      await _handleError(err);
    }
  }

  static Future<void> _handleError(dynamic err) async {
    if (err is PlatformException) {
      if (err.code == PlatformExceptionCode.iCloudConnectionOrPermission) {
        printErrorLog(
            'Platform Exception: iCloud container ID is not valid, or user is not signed in for iCloud, or user denied iCloud permission for this app');
      } else {
        printErrorLog('Platform Exception: ${err.message}; Details: ${err.details}');
      }
    } else {
      printErrorLog(err.toString());
    }
  }
}
