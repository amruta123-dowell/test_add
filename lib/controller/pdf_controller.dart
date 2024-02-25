import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PdfController extends GetxController {
  String downloadUrl =
      "https://paytym.net/storage/pdfs/EMP18_PS_22-09-2023.pdf";
  bool enableDownload = true;

  String filePath = '';

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> onClickDownload() async {
    try {
      String fileName = downloadUrl.split("/").last;

      enableDownload = false;

      //get application directory
      String directory = await getPathToDownload();
      print("the fileNAme ---> $fileName & the file path ---> $directory");

      //to download file
      final response = await Future.delayed(const Duration(milliseconds: 50))
          .then((value) => http.get(Uri.parse(downloadUrl)));

      if (response.statusCode < 200 || response.statusCode > 400) {
        showMessage("Something went wrong..", Colors.red);
      } else {
        enableDownload = true;
        File file = File("$directory/$fileName");
        await file.writeAsBytes(response.bodyBytes);
        filePath = file.path;

        showMessage("The file is downloaded successfully..", Colors.green);
      }
    } catch (error) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text(
          "Unable to download.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }

  ///download path function
  Future<String> getPathToDownload() async {
    String path = '';
    if (Platform.isAndroid) {
      // check permission needed
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          showMessage("Please allow to download the file.", Colors.red);
        }
      }

      path = (await getApplicationDocumentsDirectory()).path;
    } else {
      path = (await getApplicationCacheDirectory()).path;
    }
    return path;
  }

  ///To share file
  void shareFile() async {
    try {
      await Share.shareXFiles([XFile(filePath)]);
      update();
    } catch (e) {
      showMessage("The file is not downloaded yet. Please download the file.",
          Colors.red);
    }
  }

  void showMessage(String message, Color color) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ));
  }
}
