import 'package:ed/models/unit/unit_admin_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../static/helper_page.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:url_launcher/url_launcher.dart';

class UnitAdminSelectPage extends StatefulWidget {
  int? unit_id;
  UnitAdminSelectPage({super.key, this.unit_id});

  @override
  State<UnitAdminSelectPage> createState() => _UnitAdminSelectPageState();
}

class _UnitAdminSelectPageState extends State<UnitAdminSelectPage> {
  @override
  void initState() {
    get_users_admin();
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
          child: is_get_data
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "تعداد کل کاربران این واحد : ${data.totalUsers.toString().toPersianDigit() ?? 0}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "تعداد کاربران فعال : ${data.activeUsers.toString().toPersianDigit() ?? 0}"),
                        Text(
                            "تعداد کاربران غیر فعال : ${data.inactiveUsers.toString().toPersianDigit() ?? 0}"),
                      ],
                    ),
                    const Divider(),
                    const Text("مدیر این واحد : "),
                    data.manager != null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "مدیر این واحد : ${data.manager!.firstName.toString()} ${data.manager!.lastName.toString()}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      data.manager!.isActive!
                                          ? Icons.check
                                          : Icons.clear,
                                      color: data.manager!.isActive!
                                          ? Colors.green
                                          : Colors.red,
                                      size: 15.0,
                                    )
                                  ],
                                ),
                                const Divider(),
                                GestureDetector(
                                  onTap: () {
                                    _makePhoneCall(
                                        data.manager!.phoneNumber.toString());
                                  },
                                  child: Text(
                                    "شماره موبایل : ${data.manager!.phoneNumber.toString().toPersianDigit()}",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const Divider(),
                    const Text("کاربران این واحد : "),
                    Expanded(
                        child: data.personnel!.isEmpty
                            ? const Center(child: Text("داده ای وجود ندارد"))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.personnel!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.5)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${data.personnel![index].firstName.toString()} ${data.personnel![index].lastName.toString()}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              data.personnel![index].isActive!
                                                  ? Icons.check
                                                  : Icons.clear,
                                              color: data.personnel![index]
                                                      .isActive!
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 15.0,
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        GestureDetector(
                                          onTap: () {
                                            _makePhoneCall(data
                                                .personnel![index].phoneNumber
                                                .toString());
                                          },
                                          child: Text(
                                            "شماره موبایل : ${data.personnel![index].phoneNumber.toString().toPersianDigit()}",
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ))
                  ],
                )
              : Center(
                  child:
                      Lottie.asset("assets/lottie/loading.json", height: 40.0)),
        ),
      )),
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

  UnitAdminModel data = UnitAdminModel();
  bool is_get_data = false;
  Future<void> get_users_admin() async {
    try {
      String infourl = Helper.url.toString() +
          'user/get_unit_manager/${widget.unit_id.toString()}/personnel';
      var response = await http.get(Uri.parse(infourl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var recive_data = unitAdminModelFromJson(response.body);
        setState(() {
          data = recive_data;
          is_get_data = true;
        });
      } else {
        throw Exception("خطا در دریافت اطلاعات");
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده: ${e.toString()}", 1);
    }
  }
}
