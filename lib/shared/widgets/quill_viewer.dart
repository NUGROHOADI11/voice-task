import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuillViewer extends StatelessWidget {
  const QuillViewer({
    super.key,
    required this.jsonString,
    required this.defaultTextStyle,
  });

  final String jsonString;
  final TextStyle defaultTextStyle;

  @override
  Widget build(BuildContext context) {
    try {
      final List<dynamic> doc = jsonDecode(jsonString);
      final initialDocument = Document.fromJson(doc);

      final newOps = initialDocument.toDelta().map((op) {
        if (op.attributes != null && op.attributes!.containsKey('color')) {
          final newAttributes = Map<String, dynamic>.from(op.attributes!)
            ..remove('color');

          return Operation(op.key, op.length, op.data,
              newAttributes.isEmpty ? null : newAttributes);
        }

        return op;
      }).toList();

      final processedDocument =
          Document.fromDelta(Delta.fromOperations(newOps));

      final controller = QuillController(
        document: processedDocument,
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );

      return QuillEditor.basic(
          controller: controller,
          config: QuillEditorConfig(
            maxHeight: 150.h,
            readOnlyMouseCursor: SystemMouseCursors.none,
            customStyles: DefaultStyles(
              paragraph: DefaultTextBlockStyle(
                  defaultTextStyle,
                  const HorizontalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const BoxDecoration()),
              h1: DefaultTextBlockStyle(
                  defaultTextStyle,
                  const HorizontalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const BoxDecoration()),
              lists: DefaultListBlockStyle(
                  defaultTextStyle,
                  const HorizontalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const BoxDecoration(),
                  null),
              quote: DefaultTextBlockStyle(
                  defaultTextStyle,
                  const HorizontalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const BoxDecoration()),
              code: DefaultTextBlockStyle(
                  defaultTextStyle,
                  const HorizontalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const VerticalSpacing(0, 0),
                  const BoxDecoration()),
              sizeSmall: defaultTextStyle.copyWith(fontSize: 9),
              sizeLarge: defaultTextStyle.copyWith(fontSize: 18),
              sizeHuge: defaultTextStyle.copyWith(fontSize: 24),
              bold: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
              subscript: defaultTextStyle
                  .copyWith(fontFeatures: [const FontFeature.subscripts()]),
              superscript: defaultTextStyle
                  .copyWith(fontFeatures: [const FontFeature.superscripts()]),
              italic: defaultTextStyle.copyWith(fontStyle: FontStyle.italic),
              underline: defaultTextStyle.copyWith(
                  decoration: TextDecoration.underline),
              strikeThrough: defaultTextStyle.copyWith(
                  decoration: TextDecoration.lineThrough),
              link: defaultTextStyle.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ));
    } catch (e) {
      return Text(
        jsonString,
        style: defaultTextStyle,
      );
    }
  }
}
