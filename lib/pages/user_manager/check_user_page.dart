import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../models/check_user_model.dart';
import '../../services/no_internet_page.dart';
import '../../static/helper_page.dart';
import '../splash/splash_screen.dart';
import 'login_page.dart';

class CheckUserPage extends StatefulWidget {
  const CheckUserPage({super.key});

  @override
  State<CheckUserPage> createState() => _CheckUserPageState();
}

class _CheckUserPageState extends State<CheckUserPage> {
  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:
              Padding(padding: PagePadding.page_padding, child: Container())),
    );
  }

  // Future<void> checkRealInternetConnection() async {
  //   try {
  //     final result = await http.get(Uri.parse('https://www.google.com'));
  //     if (result.statusCode == 200) {
  //       get_user_data();
  //     } else {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const NoInternetPage(),
  //           ));
  //     }
  //   } catch (e) {
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const NoInternetPage(),
  //         ));
  //   }
  // }

  int? id_user = 0;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
    });
    if (id_user! == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
    check_user();
  }

  bool? is_active = false;
  Future<List<CheckUserModel>?> check_user() async {
    var response = await http.get(
        Uri.parse(
            Helper.url.toString() + "user/check_user/" + id_user.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        });
    if (response.statusCode == 200) {
      final SharedPreferences prefsUser = await SharedPreferences.getInstance();
      var x = json.decode(response.body);
      prefsUser.setBool('is_active', x['is_active']);
      setState(() {
        is_active = prefsUser.getBool("is_active") ?? false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ));
    }
  }
}
