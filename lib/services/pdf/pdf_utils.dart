import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFUtils {
  static Future<void> drawFooter(
      PdfPage page, Size pageSize, DocumentReference financeID) async {
    DocumentSnapshot snap = await financeID.get();

    if (snap.exists) {
      Map<String, dynamic> fData = snap.data;

      // String fContent =
      //     'iFin - Micro Finance Solution\r\n\r\nAny Questions? hello@ifin.com';
      String fContent ='';
      if (fData.containsKey('sub_branch_name')) {
        DocumentSnapshot bSnap = await snap.reference.parent().parent().get();
        DocumentSnapshot fSnap = await bSnap.reference.parent().parent().get();

        if (fSnap.exists) {
          String fName = fSnap.data['finance_name'];
          fContent += '$fName\r\n\r\n';
        }
        if (bSnap.exists) {
          String bName = fSnap.data['branch_name'];
          if (bName.contains('Branch'))
            fContent += '$bName\r\n\r\n';
          else
            fContent += 'Branch - $bName\r\n\r\n';
        }

        String sbName = fData['sub_branch_name'];
        fContent += '$sbName\r\n\r\n';
      } else if (fData.containsKey('branch_name')) {
        DocumentSnapshot fSnap = await snap.reference.parent().parent().get();

        if (fSnap.exists) {
          String fName = fSnap.data['finance_name'];
          fContent += '$fName\r\n\r\n';
        }

        String bName = fData['branch_name'];
        if (bName.contains('Branch'))
          fContent += '$bName\r\n\r\n';
        else
          fContent += 'Branch - $bName\r\n\r\n';
      } else {
        String fName = fData['finance_name'];
        fContent += '$fName\r\n\r\n';
      }

      Address _ad = Address.fromJson(fData['address']);
      fContent += '${_ad.street}\r\n\r\n';
      fContent += '${_ad.city}\r\n\r\n';
      if (fData['contact_number'] != "")
        fContent += 'Contact @ ${fData['contact_number']}\r\n\r\n';

      final PdfPen linePen =
          PdfPen(PdfColor(105, 240, 174), dashStyle: PdfDashStyle.custom);
      linePen.dashPattern = <double>[3, 3];
      page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
          Offset(pageSize.width, pageSize.height - 100));

      page.graphics.drawString(
          fContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
          format: PdfStringFormat(alignment: PdfTextAlignment.right),
          bounds:
              Rect.fromLTWH(pageSize.width - 30, pageSize.height - 90, 0, 0));
    }
  }
}
