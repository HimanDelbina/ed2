import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/shift/all_report_shift_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../static/helper_page.dart';

class AllReportShiftPage extends StatefulWidget {
  const AllReportShiftPage({super.key});

  @override
  State<AllReportShiftPage> createState() => _AllReportShiftPageState();
}

class _AllReportShiftPageState extends State<AllReportShiftPage> {
  List? data = [];
  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();

  @override
  void initState() {
    get_all_users();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Container(
            width: my_width,
            child: TextFormField(
              controller: user_search_controller,
              onChanged: (value) {
                setState(() {
                  setState(() {
                    data =
                        SearcUser.search(show_data_Search, value, "firstName");
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
          const Divider(),
          Expanded(
            child: is_get_data!
                ? ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      user_search_controller.text == ""
                          ? data = data_show
                          : data = data;
                      show_data_Search = data_show!;
                      var userData = data![index]; // اطلاعات یک کاربر
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${data![index].firstName} ${data![index].lastName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _makePhoneCall(data![index].phoneNumber);
                                  },
                                  child: Text(
                                      "موبایل : ${data![index].phoneNumber.toString().toPersianDigit()}"),
                                ),
                              ],
                            ),
                            const Divider(),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userData.months.length,
                              itemBuilder: (context, monthIndex) {
                                var monthData = userData.months[monthIndex];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue.withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "ماه : ${monthData.month.toString().toPersianDigit()}"),
                                          Text(
                                              "مجموع کل شیفت ها : ${monthData.totalShiftsInMonth.toString().toPersianDigit()} روز")
                                        ],
                                      ),
                                      const Divider(),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: monthData.shiftTypes.length,
                                        itemBuilder: (context, shiftIndex) {
                                          return Text(
                                              "شیفت ${monthData.shiftTypes[shiftIndex].shiftTypeName} : ${monthData.shiftTypes[shiftIndex].totalShifts.toString().toPersianDigit()} روز");
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0)),
          )
        ],
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

  List? data_show = [];
  bool? is_get_data = false;
  Future get_all_users() async {
    String infourl = Helper.url.toString() + 'shift/get_shift_report_all_user';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = allReportShiftModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
