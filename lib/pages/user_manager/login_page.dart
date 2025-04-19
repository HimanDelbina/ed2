import 'dart:convert';
import 'dart:io';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
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
import 'deactive_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();

  bool validAndSaveUser() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validAndSubmitUser() {
    if (validAndSaveUser()) {
      loginUser();
    }
  }

  int is_exit = 0;
  bool? is_save = false;
  bool? is_eye = true;

  @override
  void initState() {
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
      child: Form(
        key: formkey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Padding(
            padding: PagePadding.page_padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: my_height * 0.2,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  margin: const EdgeInsets.only(bottom: 50.0),
                  decoration: BoxDecoration(
                      // color: Colors.amber,
                      image: const DecorationImage(
                          scale: 1.5,
                          image: AssetImage(
                            "assets/image/sara_team.png",
                          )),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                      shape: BoxShape.circle),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Sara Company",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    my_form(
                      controllerCompanyCode,
                      company_code,
                      "کد پرسنلی",
                      false,
                      Icons.numbers,
                      TextInputType.number,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: controllerPassword,
                        onSaved: (value) => password = value,
                        keyboardType: TextInputType.number,
                        obscureText: is_eye!,
                        cursorColor: Colors.blue,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "رمز عبور",
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: const Icon(IconlyBold.password),
                          suffixIconColor: Colors.grey,
                          prefixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                is_eye = !is_eye!;
                              });
                            },
                            child: is_eye!
                                ? const Icon(IconlyLight.show)
                                : const Icon(IconlyLight.hide),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "ورود خود را ذخیره کنبد",
                        style: TextStyle(
                            fontWeight:
                                is_save! ? FontWeight.bold : FontWeight.normal),
                      ),
                      tileColor: is_save!
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      onTap: () {
                        setState(() {
                          is_save = !is_save!;
                        });
                      },
                      trailing: Checkbox(
                        value: is_save!,
                        onChanged: (value) {
                          setState(() {
                            is_save = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        onTap: validAndSubmitUser,
                        child: Container(
                          height: my_height * 0.06,
                          width: my_width,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: const Center(
                            child: Text(
                              "ورود",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text("سازنده : ${09183739816.toString().toPersianDigit()}")
              ],
            ),
          )),
        ),
      ),
    );
  }

  String? company_code = "";
  TextEditingController controllerCompanyCode = TextEditingController();
  String? password = "";
  TextEditingController controllerPassword = TextEditingController();
  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
        ),
      ),
    );
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
  var access;
  var adminAccess;
  String? unit_name_data;
  int? unit_id_data = 0;
  Future loginUser() async {
    var body = jsonEncode({
      "company_code": controllerCompanyCode.text,
      "password": controllerPassword.text,
    });
    String infourl = Helper.url.toString() + 'user/login_user';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      final SharedPreferences prefsUser = await SharedPreferences.getInstance();
      Map<String, dynamic> result = json.decode(response.body);
      print(response.body);
      access = jsonEncode(result["access"]);
      adminAccess = jsonEncode(result["admin_access"]);
      unit_id_data = result["unit"]['id'];
      // prefsUser.setString('token', result["token"]);
      prefsUser.setInt('id', result["id"]);
      prefsUser.setString(
          'phone_number', utf8.decode(result["phone_number"].codeUnits));
      prefsUser.setString(
          'first_name', utf8.decode(result["first_name"].codeUnits));
      prefsUser.setString(
          'last_name', utf8.decode(result["last_name"].codeUnits));
      prefsUser.setString('company_code', result["company_code"]);
      prefsUser.setString('password', result["password"]);
      prefsUser.setString('melli_code', result["melli_code"]);
      // prefsUser.setString('insurance_code', result["insurance_code"]);
      prefsUser.setInt('company', result["company"]['id']);
      prefsUser.setInt('group', result["group"]['id']);
      // prefsUser.setInt('manager', result["manager"]);
      prefsUser.setInt('unit_id', unit_id_data!);
      prefsUser.setString(
          'unit_name', utf8.decode(result["unit"]["name"].codeUnits));
      prefsUser.setString(
          'group_name', utf8.decode(result["group"]["name"].codeUnits));
      prefsUser.setString('access', access);
      prefsUser.setString('admin_access', adminAccess);
      // prefsUser.setString('image', result["image"]);
      prefsUser.setBool('is_shift', result["is_shift"]);
      prefsUser.setBool('is_admin', result["is_admin"]);
      prefsUser.setBool('is_active', result["is_active"]);
      prefsUser.setBool('is_user', result["is_user"]);
      prefsUser.setBool('is_manager', result["is_manager"]);
      prefsUser.setBool('is_modirTolid', result["is_modirTolid"]);
      prefsUser.setBool('is_kargozini', result["is_kargozini"]);
      prefsUser.setBool('is_anbar', result["is_anbar"]);
      prefsUser.setBool('is_salon_manager', result["is_salon_manager"]);
      prefsUser.setBool('is_unit_manager', result["is_unit_manager"]);
      prefsUser.setBool('is_guard', result["is_guard"]);
      prefsUser.setBool('is_admin_guard', result["is_admin_guard"]);
      prefsUser.setBool('is_bazargani', result["is_bazargani"]);
      prefsUser.setBool('is_save', is_save!);
      prefsUser.setBool('is_user_check_login', false);
      ///////////////////////////////////////////////////////////////////
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
      print(is_bazargani);
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
            ));
      }
    } else if (response.statusCode == 404) {
      MyMessage.mySnackbarMessage(
          context, "نام کاربری یا رمز عبور اشتباه است", 2);
    } else if (response.statusCode == 401) {
      MyMessage.mySnackbarMessage(context, " رمز عبور اشتباه است", 2);
    } else if (response.statusCode == 406) {
      MyMessage.mySnackbarMessage(context, "نام کاربری اشتباه است", 2);
    } else if (response.statusCode == 403) {
      MyMessageErrorLogin.mySnackbarMessage(
          context, "دسترسی شما توسط مدیر غیر فعال شده", 2);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
