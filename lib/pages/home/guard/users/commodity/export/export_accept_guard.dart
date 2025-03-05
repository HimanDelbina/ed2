import 'dart:convert';
import 'package:ed/pages/home/guard/users/commodity/export/export_firstpage.dart';
import 'package:ed/pages/home/guard/users/commodity/export/export_report.dart';
import 'package:http/http.dart' as http;
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class ExportAcceptGuard extends StatefulWidget {
  var data;
  ExportAcceptGuard({super.key, this.data});

  @override
  State<ExportAcceptGuard> createState() => _ExportAcceptGuardState();
}

class _ExportAcceptGuardState extends State<ExportAcceptGuard> {
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Container(
          width: my_width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "نوع خروجی : ${widget.data.select == "A" ? "امانی" : widget.data.select == "B" ? "برگشت امانی" : widget.data.select == "T" ? "تعمیر کاری" : widget.data.select == "T" ? "فروش" : widget.data.select == "Z" ? "ضایعات" : ""}",
                  ),
                  Text("شرکت : ${widget.data.company.name}"),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.data.name} - تعداد : ${widget.data.count.toString().toPersianDigit()} عدد",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "تاریخ : ${FormateDateCreate.formatDate(widget.data.createAt.toString())}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  )
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Text(
                      " ${widget.data.select == "A" ? "دریافت کننده" : widget.data.select == "B" ? "دریافت کننده" : widget.data.select == "T" ? "تعمیرکار" : widget.data.select == "F" ? "خریدار" : widget.data.select == "Z" ? "خریدار" : ""} : "),
                  Text(widget.data.select == "A"
                      ? widget.data.recipient
                      : widget.data.select == "B"
                          ? widget.data.recipient
                          : widget.data.select == "T"
                              ? widget.data.repairMan
                              : widget.data.select == "F"
                                  ? widget.data.buyer
                                  : widget.data.select == "Z"
                                      ? widget.data.buyer
                                      : ""),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(
                          widget.data.isAnbar ? Icons.check : Icons.clear,
                          size: 15.0,
                          color:
                              widget.data.isAnbar ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                          "تاییدیه انبار : ${widget.data.isAnbar ? "دارد" : "ندارد"}"),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      widget.data.isAdmin ? Icons.check : Icons.clear,
                      size: 15.0,
                      color: widget.data.isAdmin ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(widget.data.isAdmin
                      ? "تاییدیه مدیر : تایید شده"
                      : "تاییدیه مدیر : لطفا منتظر تایید باشید"),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        child: TextFormField(
                          controller: controllerFirst,
                          focusNode: _focusNode4,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          cursorColor: Colors.blue,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "چهارم",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        child: TextFormField(
                          controller: controllerSecond,
                          focusNode: _focusNode3,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          cursorColor: Colors.blue,
                          onChanged: (value) {
                            if (value.length == 3 && _focusNode4 != null) {
                              _focusNode3.unfocus();
                              FocusScope.of(context).requestFocus(_focusNode4);
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "سوم",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        child: TextFormField(
                          controller: controllerThree,
                          focusNode: _focusNode2,
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          cursorColor: Colors.blue,
                          onChanged: (value) {
                            if (value.length == 1 && _focusNode3 != null) {
                              _focusNode2.unfocus();
                              FocusScope.of(context).requestFocus(_focusNode3);
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "دوم",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        child: TextFormField(
                          controller: controllerFour,
                          focusNode: _focusNode1,
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          cursorColor: Colors.blue,
                          onChanged: (value) {
                            if (value.length == 2 && _focusNode2 != null) {
                              _focusNode1.unfocus();
                              FocusScope.of(context).requestFocus(_focusNode2);
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "اول",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )),
                ],
              ),
              const Divider(),
              const Spacer(),
              const Divider(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    exportID = widget.data.id;
                    car_plate_select = controllerFour.text +
                        controllerThree.text +
                        controllerSecond.text +
                        controllerFirst.text;
                  });
                  acceptExport();
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "تایید",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  String? car_plate_select;
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  String? plate_first = "";
  TextEditingController controllerFirst = TextEditingController();
  String? plate_second = "";
  TextEditingController controllerSecond = TextEditingController();
  String? plate_three = "";
  TextEditingController controllerThree = TextEditingController();
  String? plate_four = "";
  TextEditingController controllerFour = TextEditingController();
  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  int? exportID;
  Future acceptExport() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "car_plate": car_plate_select,
      "guard_date": dateTimeString,
      "is_guard": true
    });
    String infourl =
        Helper.url.toString() + 'guard/edit_export_commodity/${exportID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExportCommodityFirstPage(),
          ));
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
