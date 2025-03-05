import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/models/shift/shift_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';

class ReportShiftUnitPage extends StatefulWidget {
  final int? unitId;

  ReportShiftUnitPage({super.key, this.unitId});

  @override
  _ReportShiftUnitPageState createState() => _ReportShiftUnitPageState();
}

class _ReportShiftUnitPageState extends State<ReportShiftUnitPage> {
  List<ShiftAllUnitModel> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    getShiftAllUnit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: PagePadding.page_padding,
        child: isLoading
            ? Center(
                child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
            : data.isEmpty
                ? const Center(child: Text("داده ای وجود ندارد"))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var user = data[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ExpansionTile(
                          // leading: const Icon(Icons.table_chart_rounded,
                          //     color: Colors.blue),
                          title: _buildUserTitle(user),
                          subtitle: Text(
                              'شماره موبایل: ${user.phoneNumber.toString().toPersianDigit()}'),
                          children: [
                            _buildUserDetails(user),
                            const Divider(
                                color: Colors.blue,
                                indent: 10.0,
                                endIndent: 15.0),
                            _buildShiftSummary(user),
                            _buildShiftTable(user),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildUserTitle(ShiftAllUnitModel user) {
    var shift = user.todayShift?.daysSelect;
    String shiftText = shift == "SO"
        ? "صبح"
        : shift == "AS"
            ? "عصر"
            : shift == "SH"
                ? "شب"
                : "بدون شیفت";
    Color shiftColor = shift == "SO"
        ? Colors.deepOrange
        : shift == "AS"
            ? Colors.blue
            : shift == "SH"
                ? Colors.brown
                : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("شیفت امروز : $shiftText", style: TextStyle(color: shiftColor)),
      ],
    );
  }

  Widget _buildUserDetails(ShiftAllUnitModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('کد پرسنلی: ${user.companyCode.toString().toPersianDigit()}'),
          Text('کد ملی: ${user.melliCode.toString().toPersianDigit()}'),
          Text('کد بیمه: ${user.insuranceCode.toString().toPersianDigit()}'),
        ],
      ),
    );
  }

  Widget _buildShiftSummary(ShiftAllUnitModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              'تعداد شیفت های کارمند : ${user.shiftCount.toString().toPersianDigit()}',
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildShiftTable(ShiftAllUnitModel user) {
    return Table(
      border: TableBorder.all(),
      children: [
        // حذف const از TableRow برای جلوگیری از فراخوانی متد درون ساختار ثابت
        TableRow(children: [
          _buildTableCell('ماه'),
          _buildTableCell('کل شیفت‌ها'),
          _buildTableCell('شیفت‌های تأیید شده'),
          _buildTableCell('شیفت صبح'),
          _buildTableCell('شیفت عصر'),
          _buildTableCell('شیفت شب'),
        ]),
        if (user.shiftReport != null)
          ...user.shiftReport!.keys.map<TableRow>((month) {
            var report = user.shiftReport![month];
            var shiftTypes = report?.shiftTypes;

            return TableRow(
              children: [
                _buildTableCell(month.toPersianDigit() ?? 'نامشخص'),
                _buildTableCell(
                    report?.totalShifts?.toString().toPersianDigit() ?? '0'),
                _buildTableCell(
                    report?.confirmedShifts?.toString().toPersianDigit() ??
                        '0'),
                _buildTableCell(
                    shiftTypes?.so?.toString().toPersianDigit() ?? '0'),
                _buildTableCell(
                    shiftTypes?.shiftTypesAs?.toString().toPersianDigit() ??
                        '0'),
                _buildTableCell(
                    shiftTypes?.sh?.toString().toPersianDigit() ?? '0'),
              ],
            );
          }).toList(),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
    );
  }

  Future<void> getShiftAllUnit() async {
    setState(() {
      isLoading = true;
    });
    String url = '${Helper.url}/shift/get_all_shift_unit/${id_unit}';
    try {
      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          data = (jsonData as List)
              .map((e) => ShiftAllUnitModel.fromJson(e))
              .toList();
        });
      } else {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
