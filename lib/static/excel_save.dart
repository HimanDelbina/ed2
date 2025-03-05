import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelExporter {
  // تابعی برای صادر کردن داده‌ها به اکسل
  Future<void> exportToExcel(
      List<Map<String, dynamic>> data, List<String> headers) async {
    // ایجاد فایل اکسل جدید
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // افزودن عناوین ستون‌ها
    sheetObject
        .appendRow(headers.map((header) => TextCellValue(header)).toList());

    // افزودن داده‌های کاربران
    for (var user in data) {
      // لیستی برای ردیف داده‌ها
      List<CellValue?> row = [];
      for (var header in headers) {
        // برای هر header، بررسی می‌شود که در داده‌ها موجود است یا نه
        row.add(TextCellValue(user[header]?.toString() ?? ''));
      }
      // اضافه کردن ردیف به شیت
      sheetObject.appendRow(row);
    }

    // دریافت بایت‌های فایل اکسل
    List<int>? fileBytes = excel.save();

    if (fileBytes != null) {
      // ذخیره فایل اکسل
      await saveFile('leaves_report.xlsx', fileBytes);
    }
  }

  // تابعی برای ذخیره فایل اکسل
  Future<void> saveFile(String fileName, List<int> bytes) async {
    await requestPermissions();
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      String outputPath = "$selectedDirectory/$fileName";
      File file = File(outputPath);
      file.createSync(recursive: true);
      file.writeAsBytesSync(bytes);
      print("فایل با موفقیت در مسیر $outputPath ذخیره شد.");
    } else {
      print("مسیر انتخاب نشد.");
    }
  }

  // تابعی برای درخواست دسترسی به حافظه دستگاه
  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Storage permission denied.");
      }
    }
  }
}
