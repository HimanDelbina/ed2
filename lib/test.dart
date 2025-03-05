import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'models/shift/shift_model.dart';

class ShiftSchedule extends StatelessWidget {
  final Map<String, List<ShiftModel>>
      data_show; // تغییر نوع داده‌ها به Map<String, List<ShiftModel>>

  ShiftSchedule({required this.data_show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: data_show.keys.map((monthNumber) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            margin: const EdgeInsetsDirectional.symmetric(vertical: 5.0),
            child: ExpansionTile(
              title: Text(
                monthNumber,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                Table(
                  border: TableBorder.all(),
                  children: [
                    const TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'تاریخ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        TableCell(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'شیفت',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        TableCell(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'تایید',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                    // اضافه کردن داده‌های شیفت‌ها
                    ...data_show[monthNumber]!.map((shift) {
                      String date = shift.shiftDate.toString().split(' ')[0];
                      String shiftName = shift.daysSelect == "SO"
                          ? "صبح"
                          : shift.daysSelect == "AS"
                              ? "عصر"
                              : shift.daysSelect == "SH"
                                  ? "شب"
                                  : "";
                      String shiftCheck =
                          shift.isCheck! ? "ثبت شده" : "ثبت نشده";

                      return TableRow(
                        decoration: BoxDecoration(
                          color: shift.daysSelect == "SO"
                              ? Colors.red.withOpacity(0.1)
                              : shift.daysSelect == "AS"
                                  ? Colors.amber.withOpacity(0.1)
                                  : shift.daysSelect == "SH"
                                      ? Colors.black.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                        ),
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(date.toPersianDigit()))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(shiftName))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    shiftCheck,
                                    style: TextStyle(
                                        color: shift.isCheck!
                                            ? Colors.green
                                            : Colors.red),
                                  ))),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

final Map<String, String> monthNames = {
  "1": "فروردین",
  "2": "اردیبهشت",
  "3": "خرداد",
  "4": "تیر",
  "5": "مرداد",
  "6": "شهریور",
  "7": "مهر",
  "8": "آبان",
  "9": "آذر",
  "10": "دی",
  "11": "بهمن",
  "12": "اسفند",
};
