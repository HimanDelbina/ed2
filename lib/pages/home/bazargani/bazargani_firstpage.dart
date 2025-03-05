import 'dart:io';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/pages/home/bazargani/bazargani_checkPage.dart';

import '../../../static/helper_page.dart';
import '../../user_manager/login_page.dart';
import '../admin_page/admin_home.dart';
import '../admin_page/check_page/admin_checkpage_first.dart';
import '../fish/fish_page.dart';
import '../setting_page/setting_page.dart';
import '../voice_to_text/voice_firstpage.dart';

class BazarganiFirstPage extends StatefulWidget {
  const BazarganiFirstPage({super.key});

  @override
  State<BazarganiFirstPage> createState() => _BazarganiFirstPageState();
}

class _BazarganiFirstPageState extends State<BazarganiFirstPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    BazarganiCheckPage(),
    AdminHome(),
    FishPage(),
    SettingPage(),
  ];
  int is_exit = 0;

  bool? is_save = false;
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
                  width: my_width,
                  // color: Colors.amber,
                  child: const DrawerHeader(
                    child: Text("data"),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    set_data();
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width,
                    decoration: BoxDecoration(
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
        appBar: AppBar(backgroundColor: Colors.white),
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
        body: SafeArea(child: _pages.elementAt(_selectedIndex)),
      ),
    );
  }
}
