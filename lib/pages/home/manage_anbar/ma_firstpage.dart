import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ed/pages/home/fish/fish_page.dart';
import 'package:ed/pages/home/manage_anbar/ma_check.dart';
import 'package:ed/pages/home/setting_page/setting_page.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../models/anbar/count_anbar_all_model.dart';
import '../../../models/message/message_count.dart';
import '../../../static/helper_page.dart';
import '../admin_page/admin_home.dart';
import '../mail_box/mail_box_page.dart';

class ManagerAnbarFirstPage extends StatefulWidget {
  const ManagerAnbarFirstPage({super.key});

  @override
  State<ManagerAnbarFirstPage> createState() => _ManagerAnbarFirstPageState();
}

class _ManagerAnbarFirstPageState extends State<ManagerAnbarFirstPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    ManagerAnbarCheck(),
    AdminHome(),
    FishPage(),
    SettingPage(),
  ];
  int is_exit = 0;

  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_count_message();
  }

  Timer? timer;
  @override
  void initState() {
    get_user_data();
    get_count_message();
    super.initState();
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => get_count_message());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Future.delayed(const Duration(milliseconds: 500), () {
          is_exit = 0;
        });
        is_exit++;
        if (is_exit == 2) {
          exit(1);
        } else {
          MyMessage.mySnackbarMessage(
              context, "برای خروج لطفا 2 بار ضربه برنید", 1);
        }
        return false;
      },
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MailBoxPage()));
                  },
                  child: Stack(
                    children: [
                      const Icon(IconlyLight.message),
                      count_all != 0
                          ? Container(
                              height: my_height * 0.015,
                              width: my_width * 0.03,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Center(
                                child: Text(
                                  count_all.toString().toPersianDigit(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  )),
            ),
          ],
        ),
        bottomNavigationBar: FlashyTabBar(
          items: [
            FlashyTabBarItem(
                icon: const Icon(Icons.linear_scale_outlined),
                title: const Text("دسترسی ها")),
            FlashyTabBarItem(
                icon: const Icon(IconlyLight.home), title: const Text("خانه")),
            FlashyTabBarItem(
                icon: const Icon(IconlyLight.paper),
                title: const Text("فیش حقوقی")),
            FlashyTabBarItem(
                icon: const Icon(IconlyLight.setting),
                title: const Text("تنظیمات")),
          ],
          animationCurve: Curves.linear,
          selectedIndex: _selectedIndex,
          iconSize: 26,
          showElevation: false,
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),
        body: SafeArea(
          child: _pages.elementAt(_selectedIndex),
        ),
      ),
    );
  }

  int? count_all = 0;
  bool? is_get_data = false;
  Future<void> get_count_message() async {
    String infourl = Helper.url.toString() +
        'message/get_count_message/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      CountMessageModel recive_data =
          CountMessageModel.fromJson(json.decode(x));
      setState(() {
        count_all = recive_data.count;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

}
