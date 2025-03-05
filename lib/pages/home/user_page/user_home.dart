import 'dart:convert';

import 'package:ed/pages/home/Shopping/shop_firstpage.dart';
import 'package:ed/pages/home/shift/shift_firstpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../static/helper_page.dart';
import '../Leave_page/leave_page.dart';
import '../anbar/anbar_firstpage.dart';
import '../food/food_firstpage.dart';
import '../loan/loan_firstpage.dart';
import '../overtime/overtime_firstpage.dart';
import '../phone/phone_firstpage.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
  bool? is_check_all = false;
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
      if (access != "") {
        accessString = access;
        accessList = jsonDecode(accessString!);
        is_check_all = true;
      } else {
        is_check_all = true;
        accessList = [];
      }
    });
    print(accessList);
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: PagePadding.page_padding,
            child: is_check_all! == false
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
                                  builder: (context) => const FoodFirstPage(),
                                ));
                          } else if (accessList![index]["tag"] == "lot") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AnbarFirstPage(),
                                ));
                          } else if (accessList![index]["tag"] == "loan") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoanFirstPage(),
                                ));
                          } else if (accessList![index]["tag"] == "phone") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PhoneFirstPage(),
                                ));
                          } else if (accessList![index]["tag"] == "shift") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShiftFirstPage(),
                                ));
                          } else if (accessList![index]["tag"] == "shop") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ShopFirstPage(),
                                ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TagImage(
                                  tag: accessList![index]["tag"], height: 40.0),
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

class TagImage extends StatelessWidget {
  final String? tag;
  final double height;

  const TagImage({Key? key, this.tag, this.height = 40.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map of tags to their corresponding image paths
    final Map<String, String> tagToImagePath = {
      "leave": "assets/image/leave.png",
      "food": "assets/image/cutlery.png",
      "lot": "assets/image/warehouse.png",
      "ezafe": "assets/image/calendar.png",
      "loan": "assets/image/loan.png",
      "shop": "assets/image/shop.png",
      "phone": "assets/image/voip.png",
      "shift": "assets/image/shift.png",
    };

    // Get the image path based on the tag, or use a default image if tag is not found
    final String imagePath = tagToImagePath[tag] ?? "assets/image/default.png";

    return Image.asset(
      imagePath,
      height: height,
      fit: BoxFit.contain, // Optional: Adjust the fit as needed
    );
  }
}
