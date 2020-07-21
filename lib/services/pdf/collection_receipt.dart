import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/collection.dart';
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

class CollectionReceipt {
  Future<void> generateInvoice(User _u, Payment _p, Collection _c) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(52, 213, 120)));

    final PdfGrid grid = await getGrid(_c);
    final PdfLayoutResult result =
        await drawHeader(page, pageSize, grid, _p, _c);
    drawGrid(page, grid, result);
    await PDFUtils.drawFooter(page, pageSize, _u.getFinanceDocReference());

    final List<int> bytes = document.save();
    document.dispose();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/collection_receipt.pdf');
    file.writeAsBytes(bytes);

    OpenFile.open('$path/collection_receipt.pdf');
  }

  Future<PdfLayoutResult> drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
      Payment _p, Collection _c) async {
    Customer _c = await Customer().getByCustomerID(_p.customerID);

    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(68, 138, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    page.graphics.drawString(
        'Repayment Receipt', PdfStandardFont(PdfFontFamily.timesRoman, 22),
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
    page.graphics.drawString('Total Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));

    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String payID = 'Payment ID: ${_p.paymentID}\r\n\r\nDate: ' +
        format.format(DateTime.now());
    final Size contentSize = contentFont.measureString(payID);
    String address =
        'Bill To: \r\n\r\n${_c.name}, \r\n\r\n${_c.mobileNumber}\r\n\r\n${_c.address.street}\r\n\r\n${_c.address.city}';

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

    page.graphics.drawString('Total Paid:',
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
  Future<PdfGrid> getGrid(Collection _c) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 7);
    final PdfGridRow headerRow = grid.headers.add(1)[0];

    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Payment ID';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Collection Date';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Collection No';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[3].value = 'Collection Amount';
    headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[4].value = 'Date Paid';
    headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[5].value = 'Paid';
    headerRow.cells[5].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[6].value = 'Pending';
    headerRow.cells[6].stringFormat.alignment = PdfTextAlignment.center;

    int received = 0;
    //Add rows
    for (int index = 0; index < _c.collections.length; index++) {
      CollectionDetails collDetails = _c.collections[index];
      received += collDetails.amount;

      addRow(
          _c.paymentID,
          DateTime.fromMillisecondsSinceEpoch(_c.collectionDate),
          _c.collectionNumber,
          _c.collectionAmount,
          DateTime.fromMillisecondsSinceEpoch(collDetails.collectedOn),
          collDetails.amount,
          (_c.collectionAmount - received).toString(),
          grid);
    }
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    // grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j < 3) {
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
  void addRow(String pID, DateTime cDate, int ins, int amount,
      DateTime paidDate, int paid, String pending, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = pID;
    row.cells[1].value = DateUtils.formatDate(cDate);
    row.cells[2].value = ins.toString();
    row.cells[3].value = amount.toString();
    row.cells[4].value = DateUtils.formatDate(paidDate);
    row.cells[5].value = paid.toString();
    row.cells[6].value = pending;
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 2].value;
      total += double.parse(value);
    }
    return total;
  }
}
