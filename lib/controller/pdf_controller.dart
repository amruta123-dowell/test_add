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
      final response = await Future.delayed(const Duration(milliseconds: 100))
          .then((value) => http.get(Uri.parse(downloadUrl)));

      if (response.statusCode == 200) {
        enableDownload = true;
        File file = File("$directory/$fileName");
        await file.writeAsBytes(response.bodyBytes);
        filePath = file.path;

        ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
          content: Text(
            "The file is downloaded successfully....",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));
        update();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<String> getPathToDownload() async {
    String path = '';
    if (Platform.isAndroid) {
      // check permission needed
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          // Permission denied by user
          throw Exception("Permission denied for storage");
        }
      }

      path = (await getApplicationDocumentsDirectory()).path;
    } else {
      path = (await getApplicationCacheDirectory()).path;
    }
    return path;
  }

  void shareFile() async {
    try {
      await Share.shareXFiles([XFile(filePath)]);
      update();
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text(
          "The file is not downloaded. Please click on download button to download file",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
      update();
    }
  }
}
