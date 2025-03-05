import 'dart:convert';
import 'package:ed/pages/home/Shopping/shop_firstpage.dart';
import 'package:ed/pages/home/loan/loan_firstpage.dart';
import 'package:ed/pages/home/phone/phone_firstpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/pages/home/services/admin/service_plan.dart';
import '../../../../static/helper_page.dart';
import '../../Leave_page/leave_page.dart';
import '../../anbar/anbar_firstpage.dart';
import '../../food/food_firstpage.dart';
import '../../overtime/overtime_firstpage.dart';
import '../../shift/shift_firstpage.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  bool? is_check_all = false;
  bool? is_admin = false;
  bool? is_shift = false;
  bool? is_active = true;
  bool? is_user = false;
  bool? is_manager = false;
  bool? is_salon_manager = false;
  int? id_user = 0;
  int? id_unit = 0;
  String? first_name;
  String? last_name;
  String? image;
  String? access;
  String? unit_name;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      is_admin = prefsUser.getBool("is_admin") ?? false;
      is_active = prefsUser.getBool("is_active") ?? false;
      is_shift = prefsUser.getBool("is_shift") ?? false;
      is_user = prefsUser.getBool("is_user") ?? false;
      is_salon_manager = prefsUser.getBool("is_salon_manager") ?? false;
      is_manager = prefsUser.getBool("is_manager") ?? false;
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
      first_name = prefsUser.getString("first_name") ?? "";
      last_name = prefsUser.getString("last_name") ?? "";
      image = prefsUser.getString("image") ?? "";
      access = prefsUser.getString("access") ?? "";
      unit_name = prefsUser.getString("unit_name") ?? "";
      if (access != "") {
        accessString = access;
        accessList = jsonDecode(accessString!);
        is_check_all = true;
      } else {
        is_check_all = true;
        accessList = [];
      }
    });
  }

  String? accessString;
  List<dynamic>? accessList;
  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: PagePadding.page_padding,
            child: unit_name == "خدمات"
                ? is_check_all! == false
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0))
                    : Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ServicePlanPage()));
                            },
                            child: Container(
                              height: my_height * 0.06,
                              width: my_width,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "برنامه خدماتی",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0),
                              itemCount: accessList!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (accessList![index]["tag"] == "leave") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LeavePage(
                                                user_id: id_user,
                                                Unit_id: id_unit),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "ezafe") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const OvertimeFirstPage(),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "food") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FoodFirstPage(),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "lot") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AnbarFirstPage(),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "loan") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoanFirstPage(),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "shop") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ShopFirstPage(),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "shift") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ShiftFirstPage(),
                                          ));
                                    } else if (accessList![index]["tag"] ==
                                        "phone") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PhoneFirstPage(),
                                          ));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                            height: 40.0,
                                            accessList![index]["tag"] == "leave"
                                                ? "assets/image/leave.png"
                                                : accessList![index]["tag"] ==
                                                        "food"
                                                    ? "assets/image/cutlery.png"
                                                    : accessList![index]
                                                                ["tag"] ==
                                                            "lot"
                                                        ? "assets/image/warehouse.png"
                                                        : accessList![index]
                                                                    ["tag"] ==
                                                                "ezafe"
                                                            ? "assets/image/calendar.png"
                                                            : accessList![index]
                                                                        [
                                                                        "tag"] ==
                                                                    "loan"
                                                                ? "assets/image/loan.png"
                                                                : accessList![index]
                                                                            [
                                                                            "tag"] ==
                                                                        "shop"
                                                                    ? "assets/image/shop.png"
                                                                    : accessList![index]["tag"] ==
                                                                            "shift"
                                                                        ? "assets/image/shift.png"
                                                                        : accessList![index]["tag"] ==
                                                                                "phone"
                                                                            ? "assets/image/voip.png"
                                                                            : ""),
                                        Text(
                                          utf8.decode(accessList![index]["name"]
                                              .codeUnits),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                : is_check_all! == false
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0),
                        itemCount: accessList!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (accessList![index]["tag"] == "leave") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LeavePage(
                                          user_id: id_user, Unit_id: id_unit),
                                    ));
                              } else if (accessList![index]["tag"] == "ezafe") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OvertimeFirstPage(),
                                    ));
                              } else if (accessList![index]["tag"] == "food") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FoodFirstPage(),
                                    ));
                              } else if (accessList![index]["tag"] == "lot") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AnbarFirstPage(),
                                    ));
                              } else if (accessList![index]["tag"] == "loan") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LoanFirstPage(),
                                    ));
                              } else if (accessList![index]["tag"] == "shop") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ShopFirstPage(),
                                    ));
                              } else if (accessList![index]["tag"] == "shift") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ShiftFirstPage(),
                                    ));
                              } else if (accessList![index]["tag"] == "phone") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PhoneFirstPage(),
                                    ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                      height: 40.0,
                                      accessList![index]["tag"] == "leave"
                                          ? "assets/image/leave.png"
                                          : accessList![index]["tag"] == "food"
                                              ? "assets/image/cutlery.png"
                                              : accessList![index]["tag"] ==
                                                      "lot"
                                                  ? "assets/image/warehouse.png"
                                                  : accessList![index]["tag"] ==
                                                          "ezafe"
                                                      ? "assets/image/calendar.png"
                                                      : accessList![index]
                                                                  ["tag"] ==
                                                              "loan"
                                                          ? "assets/image/loan.png"
                                                          : accessList![index]
                                                                      ["tag"] ==
                                                                  "shop"
                                                              ? "assets/image/shop.png"
                                                              : accessList![index]
                                                                          [
                                                                          "tag"] ==
                                                                      "shift"
                                                                  ? "assets/image/shift.png"
                                                                  : accessList![index]
                                                                              [
                                                                              "tag"] ==
                                                                          "phone"
                                                                      ? "assets/image/voip.png"
                                                                      : ""),
                                  Text(
                                    utf8.decode(
                                        accessList![index]["name"].codeUnits),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
      ),
    );
  }
}
