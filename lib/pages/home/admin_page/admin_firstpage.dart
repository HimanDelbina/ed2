import 'dart:io';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/pages/home/admin_page/admin_home.dart';
import 'package:ed/pages/home/admin_page/check_page/admin_checkpage_first.dart';
import 'package:ed/pages/home/fish/fish_page.dart';
import 'package:ed/pages/home/setting_page/setting_page.dart';
import 'package:ed/pages/home/setting_page/user_details/user_details_page.dart';
import 'package:ed/pages/home/voice_to_text/voice_firstpage.dart';
import 'package:ed/pages/user_manager/login_page.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminFirstpage extends StatefulWidget {
  const AdminFirstpage({super.key});

  @override
  State<AdminFirstpage> createState() => _HomePageState();
}

class _HomePageState extends State<AdminFirstpage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    AdminCheckPageFirst(),
    AdminHome(),
    FishPage(),
    SettingPage(),
  ];
  int is_exit = 0;

  bool? is_save = false;
  String? firstName;
  String? lastName;
  String? company;
  String? phoneNumber;
  String? unitName;
  int? uesrID;

  void set_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      prefsUser.setBool('is_save', false);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }

  void get_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefsUser.getString("first_name") ?? "";
      lastName = prefsUser.getString("last_name") ?? "";
      phoneNumber = prefsUser.getString("phone_number") ?? "";
      unitName = prefsUser.getString("unit_name") ?? "";
      uesrID = prefsUser.getInt("id") ?? 0;
    });
  }

  @override
  void initState() {
    get_data();
    super.initState();
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
        drawer: Drawer(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: DrawerHeader(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Center(
                        child: Text(
                          "سامانه اداری",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      const Divider(color: Colors.blue),
                      Text("${firstName} ${lastName}"),
                      Text(
                          "موبایل : ${phoneNumber.toString().toPersianDigit()}"),
                      Text("واحد : ${unitName}"),
                    ],
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(userID: uesrID),
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("اطلاعات شخصی"),
                        Icon(IconlyBold.edit, size: 20.0),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Divider(),
                GestureDetector(
                  onTap: () {
                    set_data();
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("خروج از حساب"),
                        Icon(Icons.exit_to_app),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "${firstName} ${lastName}",
            style: const TextStyle(fontSize: 16.0),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VoiceFirstPage()));
          },
          backgroundColor: Colors.blue,
          child: const Center(
              child: Icon(IconlyBold.voice_2, color: Colors.white, size: 20.0)),
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
}
