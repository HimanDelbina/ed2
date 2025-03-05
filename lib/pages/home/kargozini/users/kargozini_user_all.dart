import 'dart:async';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/users/get_all_user_model.dart';
import 'package:ed/pages/home/kargozini/users/add_users_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../static/helper_page.dart';
import 'edit_user_page.dart';

class KargoziniUserAllPage extends StatefulWidget {
  const KargoziniUserAllPage({super.key});

  @override
  State<KargoziniUserAllPage> createState() => _KargoziniUsersFirstPageState();
}

class _KargoziniUsersFirstPageState extends State<KargoziniUserAllPage> {
  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();
  @override
  void initState() {
    get_all_users();
    super.initState();
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "تعداد کاربران فعال : ${active_count.toString().toPersianDigit()}"),
                  Text(
                      "تعداد کاربران غیر فعال : ${inActive_count.toString().toPersianDigit()}"),
                ],
              ),
              const Divider(),
              Container(
                width: my_width,
                child: TextFormField(
                  controller: user_search_controller,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        data = SearcUser.search(
                            show_data_Search, value, "firstName");
                      });
                    });
                  },
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.blue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "جستجو",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(IconlyBold.search),
                    suffixIconColor: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        show_filter(
                          "همه",
                          is_all,
                          () {
                            setState(() {
                              is_all = true;
                              is_active = false;
                              is_notActive = false;
                            });
                            get_all_users();
                          },
                        ),
                        show_filter(
                          "فعال",
                          is_active,
                          () {
                            setState(() {
                              is_all = false;
                              is_active = true;
                              is_notActive = false;
                            });
                            get_all_users();
                          },
                        ),
                        show_filter(
                          "غیر فعال",
                          is_notActive,
                          () {
                            setState(() {
                              is_all = false;
                              is_active = false;
                              is_notActive = true;
                            });
                            get_all_users();
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: is_get_data!
                        ? data!.isEmpty
                            ? const Center(child: Text("داده ای وجود ندارد"))
                            : ListView.builder(
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  user_search_controller.text == ""
                                      ? data = data_show
                                      : data = data;
                                  show_data_Search = data_show!;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditUserPage(
                                                      data: data![index]),
                                            ));
                                      },
                                      child: Container(
                                        width: my_width,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    data![index].isActive
                                                        ? "فعال"
                                                        : "غیر فعال",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: data![index]
                                                                .isActive
                                                            ? Colors.green
                                                            : Colors.red),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${data![index].firstName} ${data![index].lastName}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(data![index].unit.name,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.blue)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15.0),
                                                  child: Text(data![index].company.name),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        user_id =
                                                            data![index].id;
                                                        fullName = data![index]
                                                                .firstName +
                                                            " " +
                                                            data![index]
                                                                .lastName;
                                                      });
                                                      startDeleteTimer();
                                                    },
                                                    child: const Icon(
                                                        IconlyBold.delete,
                                                        size: 20.0,
                                                        color: Colors.red)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                        : Center(
                            child: Lottie.asset("assets/lottie/loading.json",
                                height: 40.0)),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 30.0),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUsersPage(),
              ));
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
                color: is_select ? Colors.white : Colors.black,
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  bool? is_all = true;
  bool? is_active = false;
  bool? is_notActive = false;
  String? infourl;
  int? active_count;
  int? inActive_count;
  Future get_all_users() async {
    is_all!
        ? infourl = Helper.url.toString() + 'user/get_all_user_filter/'
        : is_active!
            ? infourl =
                Helper.url.toString() + 'user/get_all_user_filter/?is_active=1'
            : is_notActive!
                ? infourl = Helper.url.toString() +
                    'user/get_all_user_filter/?is_active=0'
                : infourl = Helper.url.toString() + 'user/get_all_user_filter/';
    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = getAllUserModelFromJson(x);
      setState(() {
        data = recive_data.users;
        data_show = recive_data.users;
        active_count = recive_data.activeCount;
        inActive_count = recive_data.inactiveCount;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? user_id;
  Future delete_user_by_id() async {
    String infourl =
        Helper.url.toString() + 'user/delete_user_by_id/' + user_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_users();
      MyMessage.mySnackbarMessage(context, "کارمند با موفقیت حذف شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? fullName;
  bool isTimerActive = false;
  int remainingTime = 10;
  Timer? timer;
  OverlayEntry? overlayEntry;

  void startDeleteTimer() {
    if (isTimerActive) return; // جلوگیری از شروع دوباره تایمر

    isTimerActive = true; // فعال کردن وضعیت تایمر
    overlayEntry = createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        remainingTime--;
      });

      if (remainingTime <= 0) {
        delete_user_by_id();
        overlayEntry?.remove();
        t.cancel();
        resetTimer(); // ریست کردن زمان
      } else {
        overlayEntry?.markNeedsBuild();
      }
    });
  }

  void resetTimer() {
    remainingTime = 10; // ریست کردن زمان
    isTimerActive = false; // غیرفعال کردن وضعیت تایمر
  }

  OverlayEntry createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height - 100,
        left: MediaQuery.of(context).size.width * 0.15,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  "حذف $fullName را میتوانید لغو کنید : $remainingTime ثانیه باقی‌مانده.",
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // تأیید حذف
                        timer?.cancel();
                        delete_user_by_id();
                        overlayEntry?.remove();
                        resetTimer(); // ریست کردن زمان
                      },
                      child: const Text(
                        "تأیید",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // لغو
                        timer?.cancel();
                        overlayEntry?.remove();
                        resetTimer(); // ریست کردن زمان
                      },
                      child: const Text(
                        "لغو",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
