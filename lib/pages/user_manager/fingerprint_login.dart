
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../static/helper_page.dart';
import '../home/admin_page/admin_firstpage.dart';
import '../home/bazargani/bazargani_firstpage.dart';
import '../home/guard/admin/admin_guard.dart';
import '../home/manage_anbar/ma_firstpage.dart';
import '../home/user_page/user_firstpage.dart';
import 'deactive_user.dart';

class FingerPrintLoginPage extends StatefulWidget {
  const FingerPrintLoginPage({super.key});

  @override
  State<FingerPrintLoginPage> createState() => _FingerPrintLoginPageState();
}

class _FingerPrintLoginPageState extends State<FingerPrintLoginPage> {
  bool isBiometric = false;
  Future<bool> authentificationWithBiometric() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final bool isBiometricSupported =
        await localAuthentication.isDeviceSupported();
    final bool canCheckBiometrics =
        await localAuthentication.canCheckBiometrics;

    bool isAuthentification = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthentification = await localAuthentication.authenticate(
          localizedReason: "لطفا احراز هویت خود را تکمیل کنید");
    }
    return isAuthentification;
  }

  bool? is_admin = false;
  bool? is_shift = false;
  bool? is_active;
  bool? is_user = false;
  bool? is_salon_manager = false;
  bool? is_manager = false;
  bool? is_anbar = false;
  bool? is_kargozini = false;
  int? id_user = 0;
  bool? is_bazargani = false;
  bool? is_admin_guard = false;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      is_admin = prefsUser.getBool("is_admin") ?? false;
      is_active = prefsUser.getBool("is_active") ?? false;
      is_shift = prefsUser.getBool("is_shift") ?? false;
      is_user = prefsUser.getBool("is_user") ?? false;
      is_salon_manager = prefsUser.getBool("is_salon_manager") ?? false;
      is_manager = prefsUser.getBool("is_manager") ?? false;
      is_anbar = prefsUser.getBool("is_anbar") ?? false;
      is_kargozini = prefsUser.getBool("is_kargozini") ?? false;
      id_user = prefsUser.getInt("id") ?? 0;
      is_admin_guard = prefsUser.getBool("is_admin_guard") ?? false;
      is_bazargani = prefsUser.getBool("is_bazargani") ?? false;
    });
  }

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
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const Text("لطفا برای ورود روی ایکون کلیک کنید"),
              GestureDetector(
                onTap: () async {
                  isBiometric = await authentificationWithBiometric();
                  if (isBiometric) {
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
                      } else if (is_anbar!) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ManagerAnbarFirstPage(),
                            ));
                      } else if (is_admin_guard!) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GuardAdminFirstPage(),
                            ));
                      } else if (is_bazargani!) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BazarganiFirstPage(),
                            ));
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeactiveUserPage(),
                        ),
                      );
                    }
                  }
                },
                child: const Icon(
                  Icons.fingerprint,
                  size: 120.0,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
