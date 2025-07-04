import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:voice_task/shared/styles/color_style.dart';

class PdfViewerScreen extends StatelessWidget {
  final String url;

  const PdfViewerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _extractFileName(url),
        ),
        backgroundColor: ColorStyle.white,
      ),
      body: SfPdfViewer.network(url),
    );
  }

  String _extractFileName(String url) {
    final uri = Uri.parse(url);
    final rawFileName =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'Attachment';
    return Uri.decodeComponent(rawFileName);
  }
}
