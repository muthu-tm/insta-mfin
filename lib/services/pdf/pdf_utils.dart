import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFUtils {
  static Future<void> drawFooter(
      PdfPage page, Size pageSize, DocumentReference accRef) async {
    DocumentSnapshot snap = await accRef.get();

    if (snap.exists) {
      Map<String, dynamic> accData = snap.data;

      // String fContent =
      //     'iFin - Micro Finance Solution\r\n\r\nAny Questions? hello@ifin.com';
      AccountPreferences pref =
          AccountPreferences.fromJson(accData['preferences']);
      Address _ad = Address.fromJson(accData['address']);
      String fContent = '';
      if (pref.reportSignature != null && pref.reportSignature != "")
        fContent += pref.reportSignature.replaceAll('\n', '\r\n\r\n');
      else
        fContent += _ad.toString().replaceAll('\n', '\r\n\r\n');

      final PdfPen linePen =
          PdfPen(PdfColor(105, 240, 174), dashStyle: PdfDashStyle.custom);
      linePen.dashPattern = <double>[3, 3];
      page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
          Offset(pageSize.width, pageSize.height - 100));

      page.graphics.drawString(
          fContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
          format: PdfStringFormat(alignment: PdfTextAlignment.left),
          bounds:
              Rect.fromLTWH(5, pageSize.height - 90, 0, 0));
    }
  }
}
