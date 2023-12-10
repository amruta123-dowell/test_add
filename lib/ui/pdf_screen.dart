import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:get/get.dart';
import 'package:paytm_app/controller/pdf_controller.dart';

// ignore: must_be_immutable
class PdfScreen extends GetView<PdfController> {
  PdfScreen({super.key});
  @override
  PdfController controller = Get.put(PdfController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 232, 236),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(
          "PDF View",
          style: Theme.of(context)
              .primaryTextTheme
              .bodyLarge
              ?.copyWith(fontSize: 20, color: Colors.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: GetBuilder<PdfController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
                child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(blurRadius: 0.7)],
              ),
              child: const PDF().fromUrl(
                controller.downloadUrl,
                placeholder: (progress) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/pdf_icon.png",
                        fit: BoxFit.contain,
                      ),
                      const Text(
                        "PDF file here",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 58, 26, 162),
                      onPressed: () {
                        controller.shareFile();
                      },
                      child: const Icon(Icons.share),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color.fromARGB(255, 58, 26, 162),
                        onPressed: () {
                          controller.onClickDownload();
                        },
                        child: const Icon(Icons.download),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        );
      }),
    );
  }
}
