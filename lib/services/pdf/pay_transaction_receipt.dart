import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/pdf/pdf_utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PayTransactionReceipt {
  Future<void> generateInvoice(
      User _u, Payment _p, Map<int, List<CollectionDetails>> collList) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(52, 213, 120)));

    final PdfGrid grid = await getGrid(collList);
    final PdfLayoutResult result = await drawHeader(page, pageSize, grid, _p);
    drawGrid(page, grid, result);
    await PDFUtils.drawFooter(page, pageSize, _u.getFinanceDocReference());

    final List<int> bytes = document.save();
    document.dispose();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/pay_receipt.pdf');
    file.writeAsBytes(bytes);

    OpenFile.open('$path/pay_receipt.pdf');
  }

  Future<PdfLayoutResult> drawHeader(
      PdfPage page, Size pageSize, PdfGrid grid, Payment _p) async {
    Customer _c = await Customer().getByCustomerID(_p.customerID);

    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(68, 138, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    page.graphics.drawString(
        'Payment Invoice', PdfStandardFont(PdfFontFamily.timesRoman, 22),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(25, 60, 126)));

    page.graphics.drawString('Rs.' + _p.totalAmount.toString(),
        PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.timesRoman, 9);
    page.graphics.drawString('AMOUNT', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));

    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String payID = 'Payment ID: ${_p.paymentID}\r\n\r\nPayment Date: ' +
        format.format(DateTime.fromMillisecondsSinceEpoch(_p.dateOfPayment));
    final Size contentSize = contentFont.measureString(payID);
    String address =
        'Bill To: \r\n\r\n${_c.firstName} ${_c.lastName}, \r\n\r\n${_c.mobileNumber}\r\n\r\n${_c.address.street}\r\n\r\n${_c.address.city}';

    PdfTextElement(text: payID, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120));
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

    page.graphics.drawString('Total Received:',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds.left,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height));
    page.graphics.drawString(getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width,
            totalPriceCellBounds.height));
  }

  //Create PDF grid and return
  Future<PdfGrid> getGrid(Map<int, List<CollectionDetails>> collList) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    final PdfGridRow headerRow = grid.headers.add(1)[0];

    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Date';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'From';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Paid Late?';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[3].value = 'Amount';
    headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;

    List<int> cKeys = collList.keys.toList();
    for (int i = 0; i < collList.length; i++) {
      int date = cKeys[i];
      List<CollectionDetails> collections = collList[date];
      int tAmount = 0;
      bool isLatPay = false;
      String from = "";
      for (var item in collections) {
        tAmount += item.amount;
        from = item.collectedFrom;
        if (item.isPaidLate) isLatPay = true;
      }

      // Add only "Collection" type
      addRow(DateTime.fromMillisecondsSinceEpoch(date), from,
          isLatPay ? "YES" : "NO", tAmount, grid);
    }
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j != 3) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        } else {
          cell.stringFormat.alignment = PdfTextAlignment.right;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addRow(
      DateTime cDate, String from, String paidLate, int tAmount, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = DateUtils.formatDate(cDate);
    row.cells[1].value = from;
    row.cells[2].value = paidLate;
    row.cells[3].value = tAmount.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[3].value;
      total += double.parse(value);
    }
    return total;
  }
}
