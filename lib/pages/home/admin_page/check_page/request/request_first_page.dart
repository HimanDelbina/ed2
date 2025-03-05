import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../../models/manager/manager_request_model.dart';
import '../../../../../services/car_plate_display.dart';
import '../../../../../static/helper_page.dart';
import 'Shop/admin_editshop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconly/iconly.dart';

import 'admin_anbar_edit_page.dart';

class ManagerRequestFirstPage extends StatefulWidget {
  const ManagerRequestFirstPage({super.key});

  @override
  State<ManagerRequestFirstPage> createState() =>
      _ManagerRequestFirstPageState();
}

class _ManagerRequestFirstPageState extends State<ManagerRequestFirstPage> {
  int? user_id;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefsUser.getInt("id") ?? 0;
    });
    infourl =
        '${Helper.url.toString()}all_data/get_all_request_admin_new/${user_id.toString()}/';
    print(infourl);
    get_all_request();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  String? infourl;
  // لیست جفت‌های فارسی-انگلیسی
  List<Map<String, String>> dataSelect = [
    {"fa": "کاربر", "en": "user"},
    {"fa": "مرخصی", "en": "leave"},
    {"fa": "اضافه کاری", "en": "overtime"},
    {"fa": "انبار", "en": "anbar"},
    {"fa": "نگهبانی", "en": "guard"},
    {"fa": "خرید", "en": "shop"},
    {"fa": "غذا", "en": "food"},
    {"fa": "وام", "en": "loan"},
    {"fa": "ترک کار", "en": "work"},
    {"fa": "خروج کالا", "en": "export"},
  ];

  // مجموعه‌ای برای نگهداری پارامترهای انتخاب‌شده
  Set<String> selectedParams = {};

// تابع برای تولید URL نهایی
  String generateUrl() {
    if (selectedParams.isEmpty || infourl == null) {
      return infourl ?? ''; // اگر infourl null باشد، رشته خالی برگردانید
    }
    return "${infourl}?fields=${selectedParams.join(",")}";
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          children: [
            Container(
              height: myHeight * 0.05,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedParams.clear(); // حذف همه پارامترها
                      });
                      get_all_request();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      child: const Text("همه"),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: dataSelect.length,
                      itemBuilder: (context, index) {
                        String faName = dataSelect[index]["fa"]!;
                        String enName = dataSelect[index]["en"]!;
                        bool isSelected = selectedParams.contains(enName);
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedParams.remove(enName); // حذف پارامتر
                                } else {
                                  selectedParams
                                      .add(enName); // اضافه کردن پارامتر
                                }
                              });
                              generateUrl();
                              get_all_request(); // به‌روزرسانی داده‌ها
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.1)),
                              child: Text(
                                faName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: is_get_data
                  ? combinedData.isNotEmpty
                      ? ListView.builder(
                          itemCount: combinedData.length,
                          itemBuilder: (context, index) {
                            final item = combinedData[index];

                            if (item is UserElement) {
                              return _buildUserItem(item);
                            } else if (item is Loan) {
                              return _buildLoanItem(item);
                            } else if (item is Shop) {
                              return _buildShopItem(item);
                            } else if (item is Food) {
                              return _buildFoodItem(item);
                            } else if (item is Overtime) {
                              return _buildOvertimeItem(item);
                            } else if (item is Leave) {
                              return _buildLeaveItem(item);
                            } else if (item is Guard) {
                              return _buildGuardItem(item);
                            } else if (item is Anbar) {
                              return _buildAnbarItem(item);
                            } else if (item is Work) {
                              return _buildWorkItem(item);
                            } else if (item is Export) {
                              return _buildExportItem(item);
                            } else {
                              return const ListTile(
                                  title: Text('Unknown Item'));
                            }
                          },
                        )
                      : const Center(child: Text("درخواستی وجود ندارد"))
                  : Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0)),
            ),
          ],
        ),
      )),
    );
  }

  Widget button(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: color,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildExportItem(Export export) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "درخواست خروج کالا",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                  "تاریخ ارسال : ${FormateDateCreateChange.formatDate(export.createAt!.toString())}"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "درخواست کننده : ${export.user!.firstName} ${export.user!.lastName}"),
              Text(
                "شرکت : ${export.company!.name}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              )
            ],
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("کالا : ${export.name}"),
                  Text("تعداد : ${export.count.toString().toPersianDigit()}"),
                ],
              )),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  is_select_export = true;
                  exportID = export.id;
                });
                acceptExport();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  is_select_export = false;
                  exportID = export.id;
                });
                acceptExport();
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUserItem(UserElement user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              user.isCheck == true
                  ? "درخواست فعال سازی کاربری ${user.user!.firstName} ${user.user!.lastName}"
                  : "درخواست غیر فعال سازی کاربری ${user.user!.firstName} ${user.user!.lastName}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: user.isCheck == true ? Colors.green : Colors.red)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "ارسال کننده : ${user.sernder!.firstName} ${user.sernder!.lastName}"),
              Text(
                  "تاریخ ارسال : ${FormateDateCreateChange.formatDate(user.senderDate!.toString())}"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  userID = user.id;
                });
                acceptUser();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  userID = user.id;
                });
                rejectUser();
              }),
            ],
          )
        ],
      ),
    );
  }

  String loanSelect(String daysSelect) {
    if (daysSelect == "ZA") {
      return "ضروری";
    } else if (daysSelect == "MA") {
      return "معمولی";
    } else {
      return " نامشخص ";
    }
  }

  Widget _buildLoanItem(Loan loan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "درخواست وام ${loanSelect(loan.loanSelect!)} ${loan.user!.firstName} ${loan.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "مبلغ وام : ${loan.moneyRequest.toString().toPersianDigit().seRagham()} ریال"),
              Text(
                  "تاریخ ارسال : ${FormateDateCreateChange.formatDate(loan.createAt!.toString())}"),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(
                    loan.kargoziniDate != null ? Icons.check : Icons.clear,
                    color:
                        loan.kargoziniDate != null ? Colors.green : Colors.red,
                    size: 15.0),
              ),
              Text(loan.kargoziniDate != null
                  ? "تاییدیه کارگزینی در تاریخ : ${FormateDateCreateChange.formatDate(loan.kargoziniDate!.toString())}"
                  : "تاییدیه کارگزینی ندارد"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  loan_id = loan.id;
                });
                accept_loan();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  loan_id = loan.id;
                });
                reject_loan();
              }),
            ],
          )
        ],
      ),
    );
  }

  String shopSelect(String daysSelect) {
    if (daysSelect == "F") {
      return "فوری";
    } else if (daysSelect == "Z") {
      return "بسیار ضروری";
    } else {
      return " نامشخص ";
    }
  }

  Widget _buildShopItem(Shop shop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "درخواست خرید کالا ${shopSelect(shop.type!)} ${shop.user!.firstName} ${shop.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text(
              "تاریخ درخواست : ${FormateDateCreateChange.formatDate(shop.createAt!.toString())}"),
          shop.shopData != null && shop.shopData!.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: shop.shopData!.length,
                    itemBuilder: (context, commodityIndex) {
                      var commodity = shop.shopData![commodityIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${(commodityIndex + 1).toString().toPersianDigit()} : ${commodity.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "تعداد : ${commodity.count.toString().toPersianDigit()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Row(children: [
                  Text('هیچ کالایی برای نمایش وجود ندارد'),
                ]),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            anbar_id = shop.id;
                          });
                          accept_shop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: const Center(
                            child: Text(
                              "تایید",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          anbar_id = shop.id;
                        });
                        reject_shop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: const Center(
                          child: Text(
                            "لغو",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminEditShopPage(
                                  data: shop.shopData,
                                  anbar_id: shop.id,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "ویرایش",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String lunchSelect(String lunchSelect) {
    if (lunchSelect == "SO") {
      return "صبحانه";
    } else if (lunchSelect == "NA") {
      return "نهار";
    } else if (lunchSelect == "SH") {
      return "شام";
    } else {
      return " نامشخص ";
    }
  }

  Widget _buildFoodItem(Food food) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "درخواست ${lunchSelect(food.lunchSelect!)} ${food.user!.firstName} ${food.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text(
              "تاریخ ارسال : ${FormateDateCreateChange.formatDate(food.foodDate!.toString())}"),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  foodID = food.id;
                });
                acceptFood();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  foodID = food.id;
                });
                rejectFood();
              }),
            ],
          )
        ],
      ),
    );
  }

  String overtimeSelect(String select) {
    if (select == "EZ") {
      return "اضافه کاری";
    } else if (select == "TA") {
      return "تعطیل کاری";
    } else if (select == "GO") {
      return "جمعه کاری";
    } else if (select == "MA") {
      return "ماموریت";
    } else {
      return " نامشخص ";
    }
  }

  Widget _buildOvertimeItem(Overtime overtime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "درخواست ${overtimeSelect(overtime.select!)} ${overtime.user!.firstName} ${overtime.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text(
              "تاریخ ارسال : ${FormateDateCreateChange.formatDate(overtime.overtimeDate!.toString())}"),
          Text(
              "از ساعت ${overtime.startTime.toString().toPersianDigit()} تا ساعت ${overtime.endTime.toString().toPersianDigit()}"),
          overtime.description != ""
              ? Text(overtime.description!)
              : const SizedBox(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  overTimeID = overtime.id;
                });
                acceptOvertime();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  overTimeID = overtime.id;
                });
                rejectOvertime();
              }),
            ],
          )
        ],
      ),
    );
  }

  String leaveSelect(String select) {
    if (select == "ES") {
      return "استحقاقی";
    } else if (select == "ET") {
      return "استعلاجی";
    } else {
      return " نامشخص ";
    }
  }

  Widget _buildLeaveItem(Leave leave) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leave.isDays == true
              ? Text(
                  "درخواست مرخصی روزانه ${leaveSelect(leave.daysSelect!)} ${leave.user!.firstName} ${leave.user!.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.bold))
              : Text(
                  "درخواست مرخصی ساعتی ${leave.user!.firstName} ${leave.user!.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          leave.isDays == true
              ? Text(
                  "از تاریخ ${FormateDateCreateChange.formatDate(leave.daysStartDate.toString())} تا تاریخ ${FormateDateCreateChange.formatDate(leave.daysEndDate.toString())}")
              : Text(
                  "از ساعت ${leave.clockStartTime.toString().toPersianDigit()} تا ساعت ${leave.clockEndTime.toString().toPersianDigit()}"),
          leave.description != "" ? Text(leave.description!) : const SizedBox(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  leaveID = leave.id;
                });
                acceptLeave();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  leaveID = leave.id;
                });
                rejectLeave();
              }),
            ],
          )
        ],
      ),
    );
  }

  String typeWork(String select) {
    if (select == "P") {
      return "پیمان کار";
    } else if (select == "N") {
      return "نصاب";
    } else if (select == "K") {
      return "خدماتی";
    } else if (select == "G") {
      return "غیره";
    } else {
      return " نامشخص ";
    }
  }

  List<String> splitCarPlate(String carPlate) {
    RegExp regExp = RegExp(r'(\d{2})(\D)(\d{3})(\d{2})');
    Match? match = regExp.firstMatch(carPlate);

    if (match != null) {
      return [
        match.group(1)!, // 58
        match.group(2)!, // ل
        match.group(3)!, // 586
        match.group(4)!, // 53
      ];
    } else {
      return [];
    }
  }

  Widget _buildGuardItem(Guard guard) {
    // String carPlate = CarPlateDisplay(carPlate: guard.carPlate!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "درخواست ورود  ${guard.name!} بابت کار ${typeWork(guard.typeWork!)}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "تاریخ مراجعه : ${FormateDateCreateChange.formatDate(guard.createAt.toString())}"),
              guard.carPlate != ",,,"
                  ? CarPlateDisplay(carPlate: guard.carPlate!)
                  : const SizedBox(),
            ],
          ),
          Text("شماره تماس : ${guard.phoneNumber.toString().toPersianDigit()}"),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  guardID = guard.id;
                });
                acceptguard();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  guardID = guard.id;
                });
                rejectguard();
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAnbarItem(Anbar anbar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("درخواست کالا ${anbar.user!.firstName} ${anbar.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Text(
              "تاریخ درخواست : ${FormateDateCreateChange.formatDate(anbar.createAt!.toString())}"),
          anbar.commodities != null && anbar.commodities!.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: anbar.commodities!.length,
                    itemBuilder: (context, commodityIndex) {
                      var commodity = anbar.commodities![commodityIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${(commodityIndex + 1).toString().toPersianDigit()} : ${commodity.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "تعداد : ${commodity.count.toString().toPersianDigit()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Row(children: [
                  Text('هیچ کالایی برای نمایش وجود ندارد'),
                ]),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            anbarID = anbar.id;
                          });
                          acceptAnbar();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: const Center(
                            child: Text(
                              "تایید",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          anbarID = anbar.id;
                        });
                        rejectAnbar();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: const Center(
                          child: Text(
                            "لغو",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminAnbarEditPage(
                                  data: anbar.commodities,
                                  anbar_id: anbar.id,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "ویرایش",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWorkItem(Work work) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "درخواست ترک کار  ${work.user!.firstName} ${work.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "ارسال کننده : ${work.managerUser!.firstName} ${work.managerUser!.lastName}"),
              Text(
                  "تاریخ ارسال : ${FormateDateCreateChange.formatDate(work.createAt.toString())}"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              button("تایید", Colors.green, () {
                setState(() {
                  workID = work.id;
                });
                acceptWork();
              }),
              button("لغو", Colors.red, () {
                setState(() {
                  workID = work.id;
                });
                rejectWork();
              }),
            ],
          )
        ],
      ),
    );
  }

  String? req;

  Widget user_show(var data) {
    data!.isCheck ? req = "غیر فعال سازی" : "فعال سازی";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Text(
                  req!,
                  style: TextStyle(
                      color: data.isCheck ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "درخواست کننده : ${data.sernder.firstName} ${data.sernder.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                FormateDateCreate.formatDate(data.createAt.toString()),
                style: const TextStyle(color: Colors.blue),
              )
            ],
          ),
          const Divider(),
          Text(
            " کارمند : ${data.user.firstName} ${data.user.lastName}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "${data.sernder.firstName} ${data.sernder.lastName} درخواست ${req} کاربری ${data.user.firstName} ${data.user.lastName} را دارد"),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      deactive_user_select = data.user.id ?? 0;
                      id = data.id ?? 0;
                      is_accept = true;
                      is_deactive = req == "فعال سازی" ? true : false;
                    });
                    edit_user_request();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "تایید",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      id = data.id;
                      is_accept = false;
                    });
                    edit_user_request();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "لغو",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget loan_show(var data) {
    String dateTimeString = data.createAt!.toString();
    String onlyDate = dateTimeString.split(' ')[0];
    return data.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "درخواست وام",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'درخواست کننده : ${data.user.firstName} ${data.user.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          "${FormateDateCreate.formatDate(data.createAt!.toString())}",
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.blue)),
                    ],
                  ),
                  const Divider(),
                  Text(
                      " مبلغ درخواستی وام : ${data.moneyRequest.toString().toPersianDigit().seRagham()} ریال"),
                  Text(
                      " به ریال : ${data.moneyRequest.toString().toWord()} ریال"),
                  Text(
                      " به تومان : ${data.moneyRequest.toString().beToman().toWord()} تومان"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              loan_id = data!.id;
                            });
                            accept_loan();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: const Center(
                              child: Text(
                                "تایید",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              loan_id = data.id;
                            });
                            reject_loan();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            child: const Center(
                              child: Text(
                                "لغو",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget shop_show(var data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              "درخواست خرید کالا",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "درخواست کننده : ${data.user.firstName} ${data.user.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${FormateDateCreate.formatDate(data.createAt!.toString())}",
                style: const TextStyle(color: Colors.blue),
              )
            ],
          ),
          const Divider(),
          data.shopData != null && data.shopData.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.shopData.length,
                    itemBuilder: (context, commodityIndex) {
                      var commodity = data.shopData[commodityIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${(commodityIndex + 1).toString().toPersianDigit()} : ${commodity.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "تعداد : ${commodity.count.toString().toPersianDigit()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Row(children: [
                  Text('هیچ کالایی برای نمایش وجود ندارد'),
                ]),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            anbar_id = data.id;
                          });
                          accept_shop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: const Center(
                            child: Text(
                              "تایید",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          anbar_id = data.id;
                        });
                        reject_shop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: const Center(
                          child: Text(
                            "لغو",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminEditShopPage(
                                  data: data.shopData,
                                  anbar_id: data.id,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "ویرایش",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<dynamic> combinedData = [];
  bool is_get_data = false;
  List<dynamic> export_data = [];
  List<dynamic> user_data = [];
  List<dynamic> loan_data = [];
  List<dynamic> shop_data = [];
  List<dynamic> food_data = [];
  List<dynamic> overtime_data = [];
  List<dynamic> leave_data = [];
  List<dynamic> guard_data = [];
  List<dynamic> anbar_data = [];
  List<dynamic> work_data = [];

  Future<void> get_all_request() async {
    String finalUrl = generateUrl();
    print(finalUrl);

    try {
      var response = await http.get(Uri.parse(finalUrl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var x = response.body;
        debugPrint("Response Body: $x"); // چاپ پاسخ API

        ManagerRequestModel recive_data =
            ManagerRequestModel.fromJson(json.decode(x));

        setState(() {
          user_data = recive_data.user ?? [];
          export_data = recive_data.export ?? [];
          loan_data = recive_data.loan ?? [];
          shop_data = recive_data.shop ?? [];
          food_data = recive_data.food ?? [];
          overtime_data = recive_data.overtime ?? [];
          leave_data = recive_data.leave ?? [];
          guard_data = recive_data.guard ?? [];
          anbar_data = recive_data.anbar ?? [];
          work_data = recive_data.work ?? [];
          is_get_data = true;

          combinedData = [
            ...user_data,
            ...export_data,
            ...loan_data,
            ...shop_data,
            ...food_data,
            ...overtime_data,
            ...leave_data,
            ...guard_data,
            ...anbar_data,
            ...work_data,
          ];

          debugPrint("Combined Data: $combinedData");
        });

        debugPrint("User Data: $user_data");
        debugPrint("export_data: $export_data");
        debugPrint("Loan Data: $loan_data");
        debugPrint("Shop Data: $shop_data");
        debugPrint("food_data: $food_data");
        debugPrint("overtime_data: $overtime_data");
        debugPrint("leave_data: $leave_data");
        debugPrint("guard_data: $guard_data");
        debugPrint("anbar_data: $anbar_data");
        debugPrint("work_data: $work_data");
      } else {
        print("Error: ${response.statusCode}");
        MyMessage.mySnackbarMessage(
            context, "خطایی در دریافت داده‌ها رخ داده", 1);
      }
    } catch (e) {
      print("Exception occurred: $e");
      MyMessage.mySnackbarMessage(context, "خطای شبکه", 1);
    }
  }

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  int? loan_id;
  Future accept_loan() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body = jsonEncode({"is_manager": true, "manager_date": dateTimeString});
    String infourl = Helper.url.toString() + 'loan/edit_loan_admin/${loan_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_loan() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body =
        jsonEncode({"is_manager": false, "manager_date": dateTimeString});
    String infourl = Helper.url.toString() + 'loan/edit_loan_admin/${loan_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? deactive_user_select;
  bool is_deactive = false;
  Future accept_request() async {
    var body = jsonEncode(
        {"id": deactive_user_select ?? 0, "is_active": is_deactive ?? false});
    String infourl = Helper.url.toString() + 'user/deactive_user';
    try {
      var response = await http.post(
        Uri.parse(infourl), // آدرس API خود را جایگزین کن
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        get_all_request();
        MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
      } else {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali? pickedDate = Jalali.now();
  int? id;
  bool is_check = false;
  bool is_accept = false;
  Future edit_user_request() async {
    var jalaliDate = pickedDate!.formatter.yyyy +
        '-' +
        pickedDate!.formatter.mm +
        '-' +
        pickedDate!.formatter.dd +
        ' ' +
        "00:00";
    var body = jsonEncode({
      "id": id,
      "is_accept": is_accept,
      "is_read": true,
      "accept_date": jalaliDate
    });
    print(body);
    String infourl = Helper.url.toString() + 'user/edit_request_user';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      if (is_accept) {
        accept_request();
      } else {
        get_all_request();
        MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
      }
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? anbar_id;
  Future accept_shop() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body =
        jsonEncode({"manager_accept": true, "manager_date": dateTimeString});
    String infourl =
        Helper.url.toString() + 'anbar/edit_shop_admin/${anbar_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_shop() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body =
        jsonEncode({"manager_accept": false, "manager_date": dateTimeString});
    String infourl =
        Helper.url.toString() + 'anbar/edit_shop_admin/${anbar_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? foodID;
  Future acceptFood() async {
    var body = jsonEncode({"is_accept": true});
    String infourl =
        Helper.url.toString() + 'food/edit_food_with_manager/${foodID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectFood() async {
    var body = jsonEncode({"is_reject": true});
    String infourl =
        Helper.url.toString() + 'food/edit_food_with_manager/${foodID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? overTimeID;
  Future acceptOvertime() async {
    var body = jsonEncode({"is_accept": true});
    String infourl = Helper.url.toString() +
        'overtime/edit_overtime_with_manager/${overTimeID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectOvertime() async {
    var body = jsonEncode({"is_reject": true});
    String infourl = Helper.url.toString() +
        'overtime/edit_overtime_with_manager/${overTimeID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? leaveID;
  Future acceptLeave() async {
    var body = jsonEncode({"is_accept": true, "final_accept": true});
    String infourl =
        Helper.url.toString() + 'leave/edit_leave_with_manager/${leaveID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectLeave() async {
    var body = jsonEncode({"is_reject": true, "final_accept": false});
    String infourl =
        Helper.url.toString() + 'leave/edit_leave_with_manager/${leaveID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? workID;
  Future acceptWork() async {
    var body = jsonEncode({"is_accept": true});
    String infourl =
        Helper.url.toString() + 'work/edit_work_with_manager/${workID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectWork() async {
    var body = jsonEncode({"is_reject": true});
    String infourl =
        Helper.url.toString() + 'work/edit_work_with_manager/${workID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? guardID;
  Future acceptguard() async {
    var body = jsonEncode({"admin_accept": true});
    String infourl = Helper.url.toString() + 'guard/edit_client/${guardID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectguard() async {
    var body = jsonEncode({"admin_reject": true});
    String infourl = Helper.url.toString() + 'guard/edit_client/${guardID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? userID;
  Future acceptUser() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode(
        {"is_accept": true, "is_read": true, "accept_date": dateTimeString});
    String infourl =
        Helper.url.toString() + 'user/edit_request_user/${userID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectUser() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode(
        {"is_accept": false, "is_read": true, "accept_date": dateTimeString});
    String infourl =
        Helper.url.toString() + 'user/edit_request_user/${userID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? anbarID;
  Future acceptAnbar() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "manager_accept": true,
      "is_accept": true,
      "accept_date": dateTimeString,
    });
    String infourl =
        Helper.url.toString() + 'anbar/edit_anbar_admin/${anbarID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future rejectAnbar() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "manager_accept": false,
      "is_accept": false,
      "accept_date": dateTimeString,
    });
    String infourl =
        Helper.url.toString() + 'anbar/edit_anbar_admin/${anbarID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  bool is_select_export = false;
  int? exportID;
  Future acceptExport() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "is_admin": is_select_export ? true : false,
      "admin_date": dateTimeString,
    });
    String infourl =
        Helper.url.toString() + 'guard/edit_export_commodity/${exportID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_request();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
