import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/payroll_provider.dart';
import '../../providers/employee_provider.dart';
import '../../database/daos/employee_dao.dart';
import '../../database/daos/payroll_dao.dart';
import '../../widgets/common/confirm_dialog.dart';
import '../../widgets/common/table_helpers.dart';
import 'payroll_import_screen.dart';

class PayrollListScreen extends StatefulWidget {
  const PayrollListScreen({super.key});

  @override
  State<PayrollListScreen> createState() => _PayrollListScreenState();
}

class _PayrollListScreenState extends State<PayrollListScreen> {
  static const _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  static final _numFmt = NumberFormat('#,##0', 'en_US');

  final Set<int> _selectedIds = {};
  bool _selectMode = false;

  void _toggleSelectMode() => setState(() {
        _selectMode = !_selectMode;
        _selectedIds.clear();
      });

  void _toggleSelect(int id) => setState(() {
        if (_selectedIds.contains(id)) {
          _selectedIds.remove(id);
        } else {
          _selectedIds.add(id);
        }
      });

  // ── Font loader ────────────────────────────────────────────────────────────

  Future<pw.Font> _loadFont(String asset) async {
    final data = await rootBundle.load(asset);
    return pw.Font.ttf(data);
  }

  // ── PDF builders (return bytes) ────────────────────────────────────────────

  Future<Uint8List> _buildSlipBytes(PayrollWithEmployee rec) async {
    final font = await _loadFont('assets/fonts/Phetsarath OT.ttf');
    final boldFont = font;
    final wmData = await rootBundle.load('assets/images/logo_watermark.png');
    final wmImage = pw.MemoryImage(wmData.buffer.asUint8List());

    final pay = rec.payroll;
    final emp = rec.employee;
    final monthName = AppStrings.months[pay.month - 1];
    final yearShort = pay.year;

    pw.TextStyle ts({bool bold = false, double size = 10}) => pw.TextStyle(
        font: bold ? boldFont : font,
        fontSize: size,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal);

    pw.Widget slipRow(String label, double amount, {bool bold = false}) {
      final amtStr = amount > 0
          ? '${_numFmt.format(amount)} ກີບ'
          : '.........................';
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: ts(bold: bold)),
            pw.Text(amtStr, style: ts(bold: bold)),
          ],
        ),
      );
    }

    pw.Widget totalRow(String label, double amount) => pw.Container(
          // color: PdfColors.white,
          padding:
              const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label, style: ts(bold: true, size: 12)),
              pw.Text('${_numFmt.format(amount)} ກີບ',
                  style: ts(bold: true, size: 12)),
            ],
          ),
        );

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(40, 36, 40, 36),
      build: (_) => pw.Stack(
        children: [
          pw.Positioned.fill(
            child: pw.Center(
              child: pw.Opacity(
                opacity: 0.07,
                child: pw.Image(wmImage, width: 280),
              ),
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                  child: pw.Text('ໃບເບີກຈ່າຍເງິນເດືອນ',
                      style: ts(bold: true, size: 16))),
              pw.SizedBox(height: 4),
              pw.Center(
                  child: pw.Text(
                      'ເດືອນ ${pay.month.toString().padLeft(2, '0')} ($monthName) ປີ $yearShort',
                      style: ts(bold: true, size: 12))),
              pw.SizedBox(height: 8),
              pw.Text(
                  'ຊື່-ນາມສະກຸນ: ${emp.firstName} ${emp.lastName}    ລະຫັດ: ${emp.employeeCode}',
                  style: ts(size: 10)),
              pw.Divider(thickness: 1.5),
              pw.SizedBox(height: 6),
              pw.Text('* ພາກສ່ວນຮັບ', style: ts(bold: true, size: 12)),
              pw.SizedBox(height: 6),
              slipRow(AppStrings.rankSalary, pay.rankSalary),
              slipRow(AppStrings.dutyAllowance, pay.dutyAllowance),
              slipRow(AppStrings.seniorityAllowance, pay.seniorityAllowance),
              slipRow(AppStrings.militaryBonusPay, pay.militaryBonus),
              slipRow(AppStrings.specialistAllowance, pay.specialistAllowance),
              // slipRow(AppStrings.professionalAllowance, pay.professionalAllowance),
              slipRow(AppStrings.certificateAllowance, pay.certificateAllowance),
              slipRow(AppStrings.nutritionAllowance, pay.nutritionAllowance),
              slipRow(AppStrings.childrenAllowance, pay.childrenAllowance),
              slipRow(AppStrings.wifeAllowance, pay.wifeAllowance),
              slipRow(AppStrings.costOfLivingAllowance, pay.costOfLivingAllowance),
              slipRow(AppStrings.extraMealAllowance, pay.extraMealAllowance),
              pw.SizedBox(height: 4),
              totalRow(AppStrings.totalIncome, pay.totalIncome),
              pw.SizedBox(height: 14),
              pw.Text('* ພາກສ່ວນຫັກ', style: ts(bold: true, size: 12)),
              pw.SizedBox(height: 6),
              slipRow(AppStrings.socialSecurity, pay.socialSecurity),
              slipRow(AppStrings.incomeTax, pay.incomeTax),
              // slipRow(AppStrings.clothingDeduction, pay.clothingDeduction),
              // slipRow(AppStrings.utilityDeduction, pay.utilityDeduction),
              slipRow(AppStrings.riceDeduction, pay.riceDeduction),
              // slipRow(AppStrings.foodRateDeduction, pay.foodRateDeduction),
              slipRow(AppStrings.tenPercentDeduction, pay.tenPercentDeduction),
              pw.SizedBox(height: 4),
              totalRow(AppStrings.totalDeductions, pay.totalDeductions),
              pw.SizedBox(height: 14),
              pw.Divider(thickness: 1.5),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(AppStrings.netPay, style: ts(bold: true, size: 12)),
                    pw.Text('${_numFmt.format(pay.netPay)} ກີບ',
                        style: ts(bold: true, size: 13)),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Text(
                  'ວັນ...............ເດືອນ.............................ປີ..................',
                  style: ts(size: 10)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('ຜູ້ຮັບເຊັນ: ...................................', style: ts(size: 10)),
                  pw.Text('ຜູ້ຈ່າຍເຊັນ: ...................................', style: ts(size: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
    return pdf.save();
  }

  Future<Uint8List> _buildFullReportBytes(
      List<PayrollWithEmployee> records,
      List<EmployeeWithDetails> empDetails,
      int month,
      int year) async {
    final font = await _loadFont('assets/fonts/Phetsarath OT.ttf');

    pw.MemoryImage? emblem;
    try {
      final data = await rootBundle.load('assets/images/Emblem_of_Laos.webp');
      emblem = pw.MemoryImage(data.buffer.asUint8List());
    } catch (_) {}

    final empMap = {for (final e in empDetails) e.employee.id: e};
    final monthName = AppStrings.months[month - 1];

    pw.TextStyle ts({bool bold = false, double size = 7}) => pw.TextStyle(
        font: font,
        fontSize: size,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal);
//ຄວາມກວ້າງ column
    final cw = [
      14.0, 22.0, 70.0, 28.0, 14.0,
      34.0, 30.0, 30.0, 30.0, 28.0, 28.0, 28.0, 40.0,
      14.0, 28.0, 14.0,
      32.0, 30.0, 30.0, 28.0, 40.0,
      14.0, 28.0, 40.0,
      52.0, 38.0,
    ];

    String amt(double v) => v > 0 ? _numFmt.format(v) : '';

    // const colWife   = PdfColor(1.0, 0.973, 0.882);
    // const colDeduct = PdfColor(1.0, 0.922, 0.933);

    pw.Widget hcell(String text, double width,
        {bool bold = true, PdfColor fill = PdfColors.white, double height = 13,
         bool leftBorder = false, bool topBorder = false}) =>
        pw.Container(
          width: width,
          height: height,
          decoration: pw.BoxDecoration(
            color: fill,
            border: pw.Border(
              top: topBorder ? const pw.BorderSide(color: PdfColors.black, width: 0.3) : pw.BorderSide.none,
              left: leftBorder ? const pw.BorderSide(color: PdfColors.black, width: 0.3) : pw.BorderSide.none,
              right: const pw.BorderSide(color: PdfColors.black, width: 0.3),
              bottom: const pw.BorderSide(color: PdfColors.black, width: 0.3),
            ),
          ),
          padding: const pw.EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          child: pw.Center(
            child: pw.Text(text,
            //ຂະໜາດຂໍ້ຄວາມ header cell 
                style: ts(bold: bold, size: 5.5),
                textAlign: pw.TextAlign.center),
          ),
        );

    pw.Widget dcell(String text, double width,
        {pw.Alignment align = pw.Alignment.centerRight,
        bool bold = false,
        PdfColor fill = PdfColors.white,
        bool leftBorder = false}) =>
        pw.Container(
          width: width,
          height: 13,
          decoration: pw.BoxDecoration(
            color: fill,
            border: pw.Border(
              top: pw.BorderSide.none,
              left: leftBorder ? const pw.BorderSide(color: PdfColors.black, width: 0.3) : pw.BorderSide.none,
              right: const pw.BorderSide(color: PdfColors.black, width: 0.3),
              bottom: const pw.BorderSide(color: PdfColors.black, width: 0.3),
            ),
          ),
          padding: const pw.EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          alignment: align,
          //ຂະໜາດຂໍ້ຄວາມ data cell
          child: pw.Text(text, style: ts(bold: bold, size: 5.5)),
        );

    final h3labels = [
      'ລ/ດ', 'ຊັ້ນ', 'ຊື່ ແລະ ນາມສະກຸນ', 'ເດືອນປີ\nເຂົ້າທ/ຫ',
      'ຈຳ\nນວນ\nປີ', 'ເງິນເດືອນ\nພື້ນຖານ\nຕາມຊັ້ນ', 'ເງິນຫນ້າທີ່', 'ເງິນປີການ', 'ເງິນສົງເສີມ\nກອງທັບ\n30%',
      'ເງິນວິຊາສະເພາະ', 'ເງິນໃບປະກາດ', 'ເງິນກິນເພີ່ມ',
      'ເງິນຄິດ\nໄລ່8%',
    ];

    pw.Widget buildHeaderTop() => pw.Row(children: [
      // columns 1–13: single header cell merged across all 3 top rows
      for (int i = 0; i < 13; i++)
        hcell(h3labels[i], cw[i],
            fill: PdfColors.white, height: 48, topBorder: true, leftBorder: i == 0),
      // columns 14–16: ລ/ດ ເມຍ - ຜູ້ຊ່ຽວຊານ group (group label / sub-label / individual label)
      pw.Column(children: [
        hcell('ເງິນລູກ ແລະ ເມຍ', cw[13] + cw[14] + cw[15] + cw[14],topBorder: true),
        pw.Row(children: [
          hcell('ເງິນເມຍ', cw[13] + cw[14], ),
          hcell('ເງິນລູກ', cw[15] + cw[14],),
        ]),
        pw.Row(children: [
          hcell('ຈ/ນ', cw[13], fill: PdfColors.white, height: 22),
          hcell('ຈຳນວນເງິນ', cw[14], fill: PdfColors.white, height: 22),
          hcell('ຈ/ນ', cw[15], fill: PdfColors.white, height: 22),
          hcell('ຈຳນວນເງິນ', cw[14], fill: PdfColors.white, height: 22),
        ]),
      ]),
            hcell('ລວມເງິນ\nທັງໝົດ', cw[23], fill: PdfColors.white, height: 48, topBorder: true),

      // columns 17–21: ພາກສ່ວນຫັກ group (group label / sub-label / individual label)
      pw.Column(children: [
        hcell('ພາກສ່ວນຫັກ', cw[16] + cw[17] + cw[18],  topBorder: true, height: 16),
        pw.Row(children: [
          hcell('ຫັກ8%', cw[16],  height: 32),
          hcell('ຫັກ5%', cw[17],  height: 32),
          hcell('ຫັກ10%', cw[18],  height: 32),
        ]),
      ]),
      hcell('ຫັກຄ່າເຂົ້າ', cw[19], fill: PdfColors.white, height: 48, topBorder: true),
      hcell('ລວມ\nຫັກ', cw[20], fill: PdfColors.white, height: 48, topBorder: true),
      hcell('ຈຳນວນເງິນ\nທີ່ໄດ້ຮັບຕົວຈິງ\nເດືອນ${month.toString().padLeft(2, '0')}/$year', cw[24],  fill: PdfColors.white, height: 48, topBorder: true),
          hcell('ລາຍເຊັນຮັບ\nເງິນເດືອນ', cw[25], fill: PdfColors.white, height: 48, topBorder: true),

    ]);

    pw.Widget buildH4() => pw.Row(children: [
      for (int i = 0; i < 13; i++)
        hcell('${i + 1}', cw[i], bold: false, fill: PdfColors.white, height: 10, leftBorder: i == 0),
      hcell('14', cw[13], bold: false, fill: PdfColors.white, height: 10),
      hcell('15', cw[14], bold: false, fill: PdfColors.white, height: 10),
      hcell('16', cw[15], bold: false, fill: PdfColors.white, height: 10),
      hcell('17', cw[14], bold: false, fill: PdfColors.white, height: 10),
      hcell('23', cw[23], bold: false, fill: PdfColors.white, height: 10),
      hcell('18', cw[16], bold: false, fill: PdfColors.white, height: 10),
      hcell('19', cw[17], bold: false, fill: PdfColors.white, height: 10),
      hcell('20', cw[18], bold: false, fill: PdfColors.white, height: 10),
      hcell('21', cw[19], bold: false, fill: PdfColors.white, height: 10),
      hcell('22', cw[20], bold: false, fill: PdfColors.white, height: 10),
      hcell('24', cw[24], bold: false, fill: PdfColors.white, height: 10),
      hcell('25', cw[25], bold: false, fill: PdfColors.white, height: 10),
    ]);

    final dataRows = <pw.Widget>[];
    for (int i = 0; i < records.length; i++) {
      final r = records[i];
      final p = r.payroll;
      final e = r.employee;
      final d = empMap[e.id];
      final misc = p.clothingDeduction + p.utilityDeduction +
          p.riceDeduction + p.foodRateDeduction;
      final yearsOfService = DateTime.now().difference(e.hireDate).inDays ~/ 365;
      // col13 = sum of col6+7+8+9 only
      final basicIncome = p.rankSalary + p.dutyAllowance + p.seniorityAllowance + p.militaryBonus;
      // col22 = col13 + col10+11+12 − totalDeductions
      final extraIncome = p.specialistAllowance + p.certificateAllowance +
          p.extraMealAllowance + p.childrenAllowance;
      final displayNet = basicIncome + extraIncome - p.totalDeductions;
      dataRows.add(pw.Row(children: [
        dcell('${i + 1}', cw[0], align: pw.Alignment.center, leftBorder: true),
        dcell(d?.militaryRankCode ?? '', cw[1], align: pw.Alignment.center),
        dcell('${e.firstName} ${e.lastName}', cw[2], align: pw.Alignment.centerLeft),
        dcell(DateFormat('MM/yyyy').format(e.hireDate), cw[3], align: pw.Alignment.center),
        dcell(yearsOfService > 0 ? '$yearsOfService' : '', cw[4], align: pw.Alignment.center),
        dcell(amt(p.rankSalary), cw[5]),
        dcell(amt(p.dutyAllowance), cw[6]),
        dcell(amt(p.seniorityAllowance), cw[7]),
        dcell(amt(p.militaryBonus), cw[8]),
        dcell(amt(p.specialistAllowance), cw[9]),
        dcell(amt(p.certificateAllowance), cw[10]),
        dcell(amt(p.extraMealAllowance + p.childrenAllowance), cw[11]),
        dcell(amt(basicIncome), cw[12], bold: true),
        dcell(p.wifeAllowance > 0 ? '1' : '', cw[13], align: pw.Alignment.center),

        dcell(amt(p.wifeAllowance), cw[14]),
        dcell(p.specialistAllowance > 0 ? '1' : '', cw[15], align: pw.Alignment.center),
        dcell('', cw[14]),
                     dcell(amt(basicIncome - p.totalDeductions), cw[23], bold: true),
        dcell(amt(p.socialSecurity), cw[16]),
        dcell(amt(p.incomeTax), cw[17]),
        dcell(amt(p.tenPercentDeduction), cw[18]),
        dcell(amt(misc), cw[19]),
        dcell(amt(p.totalDeductions), cw[20], bold: true),
   
        dcell(amt(displayNet), cw[24], bold: true),
        dcell('', cw[25]),
      ]));
    }

    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(15),
      header: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          if (emblem != null) ...[
            pw.Center(child: pw.Image(emblem, width: 48, height: 48)),
            pw.SizedBox(height: 3),
          ],
          pw.Center(
              child: pw.Text('ສາທາລະນະລັດ ປະຊາທິປະໄຕ ປະຊາຊົນລາວ',
                  style: ts(bold: true, size: 9))),
          pw.Center(
              child: pw.Text(
                  'ສັນຕິພາບ ເອກະລາດ ປະຊາທິປະໄຕ ເອກະພາບ ວັດທະນາຖາວອນ',
                  style: ts(size: 8))),
          pw.SizedBox(height: 3),
          pw.Row(
            children: [
              pw.SizedBox(
                width: 100,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('ກົມໃຫ່ຍການເມືອງກອງທັບ', style: ts(size: 7)),
                    pw.SizedBox(height: 2),
                    pw.Text('ກອງວິທະຍຸກະຈາຍສຽງກອງທັບ', style: ts(size: 7)),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('ບັນຊີເປີກຈ່າຍເງິນເດືອນນາຍ ແລະ ພົນທະຫານ ກອງວິທະຍຸກະຈາຍສຽງກອງທັບ',
                        style: ts(bold: true, size: 11),
                        textAlign: pw.TextAlign.center),
                    pw.Text(
                        'ປະຈຳເດືອນ ${month.toString().padLeft(2, '0')} ($monthName) ປີ $year',
                        style: ts(bold: true, size: 9),
                        textAlign: pw.TextAlign.center),
                  ],
                ),
              ),
              pw.SizedBox(width: 100),
            ],
          ),
          pw.SizedBox(height: 4),
          buildHeaderTop(),
          buildH4(),
          pw.SizedBox(height: 1),
        ],
      ),
      build: (_) => dataRows,
    ));
    return pdf.save();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _printSlip(
      BuildContext context, PayrollWithEmployee rec) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await _buildSlipBytes(rec);
      await Printing.layoutPdf(onLayout: (_) async => bytes);
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('ພິມບໍ່ສຳເລັດ: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _saveSlip(
      BuildContext context, PayrollWithEmployee rec) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final emp = rec.employee;
      final pay = rec.payroll;
      final name =
          'payslip_${emp.employeeCode}_${pay.year}_${pay.month.toString().padLeft(2, '0')}.pdf';
      final bytes = await _buildSlipBytes(rec);
      await _savePdfFile(messenger, bytes, name);
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('ບັນທຶກບໍ່ສຳເລັດ: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _saveFullReport(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final payrollProv = context.read<PayrollProvider>();
      final empProv = context.read<EmployeeProvider>();
      final m = payrollProv.selectedMonth;
      final y = payrollProv.selectedYear;
      final bytes = await _buildFullReportBytes(
        payrollProv.records,
        empProv.employees,
        m,
        y,
      );
      await _savePdfFile(
          messenger, bytes, 'banchee_ngoendeuan_${y}_${m.toString().padLeft(2, '0')}.pdf');
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text('ບັນທຶກບໍ່ສຳເລັດ: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _savePdfFile(
      ScaffoldMessengerState messenger,
      Uint8List bytes,
      String defaultName) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'ບັນທຶກ PDF',
      fileName: defaultName,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (path == null) return;
    final savePath = path.endsWith('.pdf') ? path : '$path.pdf';
    await File(savePath).writeAsBytes(bytes);
    messenger.showSnackBar(
      SnackBar(
        content: Text('ບັນທຶກສຳເລັດ: $savePath'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'ເປີດໂຟລເດີ',
          textColor: Colors.white,
          onPressed: () => Process.run(
              'explorer', ['/select,', savePath.replaceAll('/', '\\')]),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navPayroll),
        actions: [
          Consumer<PayrollProvider>(
            builder: (_, provider, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectMode) ...[
                  if (_selectedIds.isNotEmpty) ...[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete_rounded, size: 16),
                      label: Text('ລຶບທີ່ເລືອກ (${_selectedIds.length})'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700]),
                      onPressed: () => ConfirmDialog.show(context,
                          onConfirm: () async {
                            await context
                                .read<PayrollProvider>()
                                .removeMultiple(_selectedIds.toList());
                            setState(() {
                              _selectedIds.clear();
                              _selectMode = false;
                            });
                          }),
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton.icon(
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('ຍົກເລີກ'),
                    onPressed: _toggleSelectMode,
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text(AppStrings.generatePayroll),
                    onPressed: () async {
                      final employees = await context
                          .read<EmployeeProvider>()
                          .getActiveList();
                      if (context.mounted) {
                        await context
                            .read<PayrollProvider>()
                            .generateForEmployees(employees);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.checklist_rounded, size: 16),
                    label: const Text('ເລືອກ'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[600]),
                    onPressed:
                        provider.records.isEmpty ? null : _toggleSelectMode,
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete_sweep_rounded, size: 16),
                    label: const Text('ລຶບທັງໝົດ'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700]),
                    onPressed: provider.records.isEmpty
                        ? null
                        : () => ConfirmDialog.show(context,
                            onConfirm: () => context
                                .read<PayrollProvider>()
                                .removeAll()),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('ດາວໂຫຼດ PDF'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF283593)),
                    onPressed: provider.records.isEmpty
                        ? null
                        : () => _saveFullReport(context),
                  ),
                ],
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<PayrollProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // ── Toolbar ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    _MonthYearDropdown<int>(
                      label: AppStrings.month,
                      value: provider.selectedMonth,
                      items: _months
                          .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(AppStrings.months[m - 1])))
                          .toList(),
                      onChanged: (m) => provider.changeMonthYear(
                          m!, provider.selectedYear),
                    ),
                    const SizedBox(width: 12),
                    _MonthYearDropdown<int>(
                      label: AppStrings.year,
                      value: provider.selectedYear,
                      items: List.generate(
                              5, (i) => DateTime.now().year - 2 + i)
                          .map((y) => DropdownMenuItem(
                              value: y, child: Text('$y')))
                          .toList(),
                      onChanged: (y) => provider.changeMonthYear(
                          provider.selectedMonth, y!),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TableSearchField(
                        onChanged: provider.setSearch,
                        hint: 'ຄົ້ນຫາ ຊື່ພະນັກງານ...',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${provider.filtered.length} ລາຍການ',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.upload_file_rounded),
                      tooltip: 'ນຳເຂົ້າ CSV',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PayrollImportScreen(
                            initialMonth: provider.selectedMonth,
                            initialYear: provider.selectedYear,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Table ──────────────────────────────────────────────
              if (provider.isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else if (provider.filtered.isEmpty)
                const Expanded(
                  child: TableEmptyState(
                    icon: Icons.payments_rounded,
                    label: 'ຍັງບໍ່ໄດ້ສ້າງເງິນເດືອນ',
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: double.infinity,
                                child: DataTable(
                                  headingRowColor:
                                      TableStyle.headingRowColor,
                                  headingTextStyle:
                                      TableStyle.headingTextStyle,
                                  dataRowMinHeight: TableStyle.rowHeight,
                                  dataRowMaxHeight: TableStyle.rowHeight,
                                  horizontalMargin:
                                      TableStyle.horizontalMargin,
                                  columnSpacing: TableStyle.columnSpacing,
                                  dividerThickness:
                                      TableStyle.dividerThickness,
                                  showCheckboxColumn: _selectMode,
                                  onSelectAll: _selectMode
                                      ? (val) => setState(() {
                                            if (val == true) {
                                              _selectedIds.addAll(provider
                                                  .filtered
                                                  .map((r) => r.payroll.id));
                                            } else {
                                              _selectedIds.clear();
                                            }
                                          })
                                      : null,
                                  columns: const [
                                    DataColumn(
                                        label: Text('ຊື່-ນາມສະກຸນ')),
                                    DataColumn(
                                        label: Text('ປີການ')),
                                    DataColumn(
                                        label: Text(
                                            AppStrings.totalIncome),
                                        numeric: true),
                                    DataColumn(
                                        label: Text(
                                            AppStrings.totalDeductions),
                                        numeric: true),
                                    DataColumn(
                                        label: Text(AppStrings.netPay),
                                        numeric: true),
                                    DataColumn(label: Text('ຈັດການ')),
                                  ],
                                  rows: provider.filtered.map((r) {
                                    final emp = r.employee;
                                    final pay = r.payroll;
                                    return DataRow(
                                      selected: _selectMode &&
                                          _selectedIds.contains(pay.id),
                                      onSelectChanged: _selectMode
                                          ? (_) => _toggleSelect(pay.id)
                                          : null,
                                      cells: [
                                      DataCell(Text(
                                        '${emp.firstName} ${emp.lastName}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )),
                                      DataCell(Text(
                                        AppDateUtils.yearsOfService(emp.hireDate),
                                        style: const TextStyle(fontSize: 12),
                                      )),
                                      DataCell(Text(
                                          CurrencyUtils.formatCompact(
                                              pay.totalIncome))),
                                      DataCell(Text(
                                        CurrencyUtils.formatCompact(
                                            pay.totalDeductions),
                                        style: const TextStyle(
                                            color: Colors.red),
                                      )),
                                      DataCell(Text(
                                        CurrencyUtils.formatCompact(
                                            pay.netPay),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B5E20)),
                                      )),
                                      DataCell(Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _ActionBtn(
                                            icon: Icons
                                                .receipt_long_rounded,
                                            tooltip:
                                                AppStrings.printSlip,
                                            color: Colors.teal,
                                            onTap: () =>
                                                _printSlip(context, r),
                                          ),
                                          _ActionBtn(
                                            icon: Icons
                                                .download_rounded,
                                            tooltip: 'ບັນທຶກ PDF',
                                            color: const Color(
                                                0xFF1565C0),
                                            onTap: () =>
                                                _saveSlip(context, r),
                                          ),
                                          _ActionBtn(
                                            icon: Icons.edit_rounded,
                                            tooltip: AppStrings.edit,
                                            onTap: () => context.go(
                                                '/payroll/${pay.id}/edit'),
                                          ),
                                          _ActionBtn(
                                            icon: Icons.delete_rounded,
                                            tooltip:
                                                AppStrings.deleteAction,
                                            color: Colors.red,
                                            onTap: () =>
                                                ConfirmDialog.show(
                                              context,
                                              onConfirm: () => context
                                                  .read<PayrollProvider>()
                                                  .remove(pay.id),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          // Footer
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.grey[200]!)),
                            ),
                            child: Text(
                              'ລວມທັງໝົດ: ${CurrencyUtils.format(provider.filtered.fold(0.0, (s, r) => s + r.payroll.netPay))}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _MonthYearDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _MonthYearDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        const SizedBox(height: 2),
        DropdownButtonHideUnderline(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isDense: true,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontFamily: 'PhetsarathOT'),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.tooltip,
    this.color = const Color(0xFF546E7A),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      );
}
