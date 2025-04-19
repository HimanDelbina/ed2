import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../static/helper_page.dart';
import '../home/admin_page/admin_firstpage.dart';
import '../home/bazargani/bazargani_firstpage.dart';
import '../home/guard/users/guard_firstpage.dart';
import '../home/kargozini/kargozini_firstpage.dart';
import '../home/kargozini/unit/unit_manager_firstpage.dart';
import '../home/manage_anbar/ma_firstpage.dart';
import '../home/manager/manager_firstpage.dart';
import '../home/salon_manager/salon_manager_firstPage.dart';
import '../home/user_page/user_firstpage.dart';
import '../home/user_page/user_home.dart';
import '../user_manager/deactive_user.dart';
import '../user_manager/fingerprint_login.dart';
import '../user_manager/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    get_login();
  }

  bool? is_admin = false;
  bool? is_shift = false;
  bool? is_active = false;
  bool? is_user = false;
  bool? is_unit_manager = false;
  bool? is_manager = false;
  bool? is_salon_manager = false;
  bool? is_user_check_login = false;
  bool? is_kargozini = false;
  bool? is_anbar = false;
  bool? is_admin_guard = false;
  bool? is_guard = false;
  bool? is_bazargani = false;
  bool? is_modirTolid = false;
  int? id_user = 0;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      is_admin = prefsUser.getBool("is_admin") ?? false;
      is_shift = prefsUser.getBool("is_shift") ?? false;
      is_active = prefsUser.getBool("is_active") ?? false;
      is_user = prefsUser.getBool("is_user") ?? false;
      is_unit_manager = prefsUser.getBool("is_unit_manager") ?? false;
      is_manager = prefsUser.getBool("is_manager") ?? false;
      is_kargozini = prefsUser.getBool("is_kargozini") ?? false;
      is_anbar = prefsUser.getBool("is_anbar") ?? false;
      is_salon_manager = prefsUser.getBool("is_salon_manager") ?? false;
      is_guard = prefsUser.getBool("is_guard") ?? false;
      is_admin_guard = prefsUser.getBool("is_admin_guard") ?? false;
      is_save = prefsUser.getBool("is_save") ?? false;
      is_user_check_login = prefsUser.getBool("is_user_check_login") ?? false;
      is_bazargani = prefsUser.getBool("is_bazargani") ?? false;
      is_modirTolid = prefsUser.getBool("is_modirTolid") ?? false;
      id_user = prefsUser.getInt("id") ?? 0;
    });

    if (id_user! == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      if (is_active!) {
        if (is_user!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserFirstPage(),
              ));
        } else if (is_admin!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminFirstpage(),
              ));
        } else if (is_modirTolid!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminFirstpage(),
              ));
        } else if (is_kargozini!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KargoziniFirstPage(),
              ));
        } else if (is_manager!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManagerFirstPage(),
              ));
        } else if (is_anbar!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManagerAnbarFirstPage(),
              ));
        } else if (is_unit_manager!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UnitManagerFirstPage(),
              ));
        } else if (is_guard! || is_admin_guard!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GuardFirstPage(),
              ));
        } else if (is_salon_manager!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SalonManagerFirstPage(),
              ));
        } else if (is_bazargani!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BazarganiFirstPage(),
              ));
        }
        MyMessage.mySnackbarMessage(context, "شما با موفقیت وارد شدید", 1);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeactiveUserPage(),
          ),
        );
      }
    }
  }

  // bool? is_user_check_login = false;
  bool? is_save = true;
  void get_login() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    is_save = prefsUser.getBool('is_save') ?? false;
    is_user_check_login = prefsUser.getBool("is_user_check_login") ?? false;
    setState(() {});
    if (is_save!) {
      get_user_data();
    } else {
      if (is_user_check_login!) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FingerPrintLoginPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Container(
          width: double.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              SizedBox(),
              Text("سامانه اداری"),
            ],
          ),
        ),
      )),
    );
  }
}
