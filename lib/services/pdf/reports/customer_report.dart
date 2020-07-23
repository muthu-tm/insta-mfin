import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/pdf/pdf_utils.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class CustomerReport {
  Future<void> generateReport(User _u, List<Customer> _cust, bool isRange,
      DateTime fromDate, DateTime toDate) async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(52, 213, 120)));

    final PdfGrid grid = await getGrid(_cust);
    final PdfLayoutResult result = await drawHeader(
        page, pageSize, grid, _cust.length, isRange, fromDate, toDate);
    drawGrid(page, grid, result);
    await PDFUtils.drawFooter(page, pageSize, _u.getFinanceDocReference());

    final List<int> bytes = document.save();
    document.dispose();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/collection_report.pdf');
    file.writeAsBytes(bytes);

    OpenFile.open('$path/collection_report.pdf');
  }

  Future<PdfLayoutResult> drawHeader(PdfPage page, Size pageSize, PdfGrid grid,
      int count, bool isRange, DateTime fromDate, DateTime toDate) async {
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(68, 138, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    page.graphics.drawString(
        'Customer Report', PdfStandardFont(PdfFontFamily.timesRoman, 22),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(25, 60, 126)));

    page.graphics.drawString(
        count.toString(), PdfStandardFont(PdfFontFamily.timesRoman, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.timesRoman, 9);
    page.graphics.drawString('Total', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));

    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String date = 'Generated On: ' + format.format(DateTime.now());
    final String headerText = isRange
        ? '$date\r\n\r\nDate From: ' +
            format.format(fromDate) +
            '\r\n\r\nDate To: ' +
            format.format(toDate)
        : '$date\r\n\r\nDate: ' + format.format(fromDate);
    final Size contentSize = contentFont.measureString(headerText);

    return PdfTextElement(text: headerText, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));
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

    page.graphics.drawString('Total Paid Out:',
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
  Future<PdfGrid> getGrid(List<Customer> _cust) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 8);
    final PdfGridRow headerRow = grid.headers.add(1)[0];

    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Name';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'ID';
    headerRow.cells[1].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[2].value = 'Number';
    headerRow.cells[2].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[3].value = 'Joined On';
    headerRow.cells[3].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[4].value = 'Total Payments';
    headerRow.cells[4].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[5].value = 'Payment IDs';
    headerRow.cells[5].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[6].value = 'Total Amount';
    headerRow.cells[6].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[7].value = 'Principal Amount';
    headerRow.cells[7].stringFormat.alignment = PdfTextAlignment.center;

    //Add rows
    for (int index = 0; index < _cust.length; index++) {
      Customer _c = _cust[index];
      List<Payment> pays = await _c.getPayments(_c.mobileNumber);
      List<String> pIds = [];
      int pTotalAmount = 0;
      int pPrincipalAmount = 0;

      if (pays != null) {
        pays.forEach((p) {
          pIds.add(p.paymentID);
          pTotalAmount += p.totalAmount;
          pPrincipalAmount += p.principalAmount;
        });
      }
      addRow(
          '${_c.firstName} ${_c.lastName}',
          _c.customerID,
          _c.mobileNumber.toString(),
          DateTime.fromMillisecondsSinceEpoch(_c.joinedAt),
          pays == null ? 0 : pays.length,
          pIds.length > 0 ? pIds.join(',') : "-",
          pTotalAmount,
          pPrincipalAmount,
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
  void addRow(String name, String id, String number, DateTime joined, int tPays,
      String pIds, int ptAmount, int principalAmount, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = name;
    row.cells[1].value = id;
    row.cells[2].value = number;
    row.cells[3].value = DateUtils.formatDate(joined);
    row.cells[4].value = tPays.toString();
    row.cells[5].value = pIds;
    row.cells[6].value = ptAmount.toString();
    row.cells[7].value = principalAmount.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 1].value;
      total += double.parse(value);
    }
    return total;
  }
}
