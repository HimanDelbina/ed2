import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class Helper {
  // static String url = "http://192.168.90.167:5000/";
  // static String url = "http://192.168.43.51:5000/";
  // static String url = "http://192.168.43.15:5000/";
  // static String url = "http://192.168.60.184:5000/";
  static String url = "http://109.125.128.28:5001/";
  // static String url = "http://192.168.1.150:5001/";
}

class PagePadding {
  static const page_padding =
      EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0);
}

class MyMessage {
  static void mySnackbarMessage(
      BuildContext context, String title, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        content: Text(title, style: const TextStyle(fontFamily: "Vazir")),
      ),
    );
  }
}

class MyMessageError {
  static void mySnackbarMessage(
      BuildContext context, String title, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        content: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Vazir",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow:
                    TextOverflow.ellipsis, // برای جلوگیری از بلند بودن متن
                maxLines: 1, // نمایش تنها یک خط
              ),
            ),
            Container(
              width: 30.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Lottie.asset("assets/lottie/food_1.json",
                    height: 30.0), // ارتفاع منطقی
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMessageErrorLogin {
  static void mySnackbarMessage(
      BuildContext context, String title, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        content: Text(
          title,
          style: const TextStyle(
            fontFamily: "Vazir",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis, // برای جلوگیری از بلند بودن متن
          maxLines: 1, // نمایش تنها یک خط
        ),
      ),
    );
  }
}

class FormateDate {
  static String formatDate(String date) {
    var parts = date.split("-");
    var jalaliDate = Jalali(
      int.parse(parts[0].toEnglishDigit()),
      int.parse(parts[1].toEnglishDigit()),
      int.parse(parts[2].toEnglishDigit()),
    );
    var gregorianDate = jalaliDate;
    String formattedDate = DateFormat('dd-MM-yyyy').format(
        DateTime(gregorianDate.year, gregorianDate.month, gregorianDate.day));
    return formattedDate.toPersianDigit();
  }
}

class FormateDateCreate {
  static String formatDate(String date) {
    try {
      // جدا کردن تاریخ از زمان
      var datePart = date.split(" ")[0]; // فقط بخش تاریخ (قبل از فاصله)
      var parts = datePart.split("-");

      // تبدیل به تاریخ شمسی
      var jalaliDate = Jalali(
        int.parse(parts[0].toEnglishDigit()),
        int.parse(parts[1].toEnglishDigit()),
        int.parse(parts[2].toEnglishDigit()),
      );

      // فرمت تاریخ شمسی به صورت 'سال-ماه-روز'
      String formattedDate =
          "${jalaliDate.formatter.y}-${jalaliDate.formatter.m}-${jalaliDate.formatter.d}";

      return formattedDate.toPersianDigit();
    } catch (e) {
      // مدیریت خطا
      return "Invalid date format";
    }
  }
}

class FormateDateCreateNew {
  static String formatDate(String date) {
    try {
      // جداسازی تاریخ از زمان با پشتیبانی از فاصله یا T
      var datePart = date.split(RegExp(r"[T\s]"))[0];

      var parts = datePart.split("-");
      if (parts.length != 3) throw FormatException("Invalid date format");

      // تبدیل به تاریخ شمسی
      var jalaliDate = Jalali(
        int.parse(parts[0].toEnglishDigit()),
        int.parse(parts[1].toEnglishDigit()),
        int.parse(parts[2].toEnglishDigit()),
      );

      // فرمت تاریخ شمسی به صورت 'سال-ماه-روز'
      String formattedDate =
          "${jalaliDate.formatter.yyyy}-${jalaliDate.formatter.mm}-${jalaliDate.formatter.dd}";

      return formattedDate.toPersianDigit();
    } catch (e) {
      return "Error: Invalid date input";
    }
  }
}

class FormateDateCreateLeft {
  static String formatDate(String date) {
    try {
      // جدا کردن تاریخ از زمان
      var datePart = date.split(" ")[0]; // فقط بخش تاریخ (قبل از فاصله)
      var parts = datePart.split("-");

      // تبدیل به تاریخ شمسی
      var jalaliDate = Jalali(
        int.parse(parts[0].toEnglishDigit()),
        int.parse(parts[1].toEnglishDigit()),
        int.parse(parts[2].toEnglishDigit()),
      );

      var gregorianDate = jalaliDate;
      String formattedDate = DateFormat('dd-MM-yyyy').format(
          DateTime(gregorianDate.year, gregorianDate.month, gregorianDate.day));

      return formattedDate.toPersianDigit();
    } catch (e) {
      // مدیریت خطا
      return "Invalid date format";
    }
  }
}

class FormateDateCreateChange {
  static String formatDate(String date) {
    try {
      // جدا کردن تاریخ از زمان
      var datePart = date.split(" ")[0]; // فقط بخش تاریخ (قبل از فاصله)
      var parts = datePart.split("-");

      // تبدیل به تاریخ شمسی
      var jalaliDate = Jalali(
        int.parse(parts[0].toEnglishDigit()),
        int.parse(parts[1].toEnglishDigit()),
        int.parse(parts[2].toEnglishDigit()),
      );
      var gregorianDate = jalaliDate;
      String formattedDate = DateFormat('dd-MM-yyyy').format(
          DateTime(gregorianDate.year, gregorianDate.month, gregorianDate.day));

      return formattedDate.toPersianDigit();
    } catch (e) {
      // مدیریت خطا
      return "Invalid date format";
    }
  }
}

class SearcUser {
  static dynamic search(var list, String s, [search_based_on = "user"]) {
    var list2 = [];

    if (search_based_on == "firstName") {
      list = list.where((e) {
        if (e.firstName.contains(s) ||
            e.lastName.contains(s) ||
            e.companyCode.contains(s)) {
          print("1");
          list2.add(e);
          return true;
        } else {
          print("1");
          return false;
        }
      }).toList();
    }
    if (s == '') {
      return list;
    }
    return list2;
  }
}

class SearcPhone {
  static dynamic search(var list, String s, [search_based_on = "name"]) {
    var list2 = [];

    if (search_based_on == "name") {
      list = list.where((e) {
        if (e.name.contains(s) || e.phone.contains(s)) {
          print("1");
          list2.add(e);
          return true;
        } else {
          print("1");
          return false;
        }
      }).toList();
    }
    if (s == '') {
      return list;
    }
    return list2;
  }
}

class SearcUserGuard {
  static dynamic search(var list, String s, [search_based_on = "user"]) {
    var list2 = [];

    if (search_based_on == "firstName") {
      list = list.where((e) {
        if (e.user.firstName.contains(s) ||
            e.user.lastName.contains(s) ||
            e.user.companyCode.contains(s)) {
          print("1");
          list2.add(e);
          return true;
        } else {
          print("1");
          return false;
        }
      }).toList();
    }
    if (s == '') {
      return list;
    }
    return list2;
  }
}

class SearcUserGharardad {
  static dynamic search(var list, String s, [search_based_on = "user"]) {
    var list2 = [];

    if (search_based_on == "userName") {
      list = list.where((e) {
        if (e.user.userName.contains(s)) {
          print("1");
          list2.add(e);
          return true;
        } else {
          print("1");
          return false;
        }
      }).toList();
    }
    if (s == '') {
      return list;
    }
    return list2;
  }
}

class SearcUnit {
  static dynamic search(var list, String s, [search_based_on = "user"]) {
    var list2 = [];

    if (search_based_on == "name") {
      list = list.where((e) {
        if (e.name.contains(s)) {
          print("1");
          list2.add(e);
          return true;
        } else {
          print("1");
          return false;
        }
      }).toList();
    }
    if (s == '') {
      return list;
    }
    return list2;
  }
}

class FormatTimeCreate {
  static String formatTime(String dateTime) {
    try {
      // جدا کردن بخش زمان از تاریخ
      var timePart = dateTime.split(" ")[1]; // فقط بخش زمان (بعد از فاصله)

      // جدا کردن ساعت و دقیقه (در صورت نیاز)
      var parts = timePart.split(":");
      String formattedTime = "${parts[0]}:${parts[1]}"; // فقط ساعت و دقیقه

      return formattedTime; // بازگشت ساعت به همراه دقیقه
    } catch (e) {
      // مدیریت خطا
      return "Invalid time format";
    }
  }
}

class FormateDateJaliliNow {
  static String formatDate(Jalali date) {
    try {
      // قالب‌بندی تاریخ
      String formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      return formattedDate;
    } catch (e) {
      return "Invalid Date Format";
    }
  }
}
