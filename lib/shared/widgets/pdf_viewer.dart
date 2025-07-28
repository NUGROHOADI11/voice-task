import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:voice_task/shared/styles/color_style.dart';

class PdfViewerScreen extends StatelessWidget {
  // The parameter is now the local file path
  final String filePath;

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    // Create a File object from the path
    final file = File(filePath);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _extractFileName(filePath),
        ),
        backgroundColor: ColorStyle.white,
      ),
      // Use SfPdfViewer.file to load from the local system
      body: SfPdfViewer.file(file),
    );
  }

  /// Extracts the file name from a local file path.
  String _extractFileName(String path) {
    try {
      return path.split('/').last;
    } catch (e) {
      return 'Attachment'; // Fallback name
    }
  }
}