import 'package:ed/models/shift/shift_user_guard_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../../static/helper_page.dart';

class GuardShift extends StatefulWidget {
  const GuardShift({super.key});

  @override
  State<GuardShift> createState() => _GuardShiftState();
}

class _GuardShiftState extends State<GuardShift> {
  @override
  void initState() {
    super.initState();
    get_all_shift_guard();
  }

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();
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
              const Text(
                  "در این بخش، شما می‌توانید اطلاعات مربوط به شیفت‌های کاری کاربران را مشاهده کنید. "),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: my_width,
                  child: TextFormField(
                    controller: user_search_controller,
                    onChanged: (value) {
                      setState(() {
                        setState(() {
                          data = SearcUserGuard.search(
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
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${data![index].user.firstName} ${data![index].user.lastName}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        const Text("شیفت : "),
                                        Text(
                                          data![index].daysSelect == "SO"
                                              ? "صبح"
                                              : data![index].daysSelect == "AS"
                                                  ? "عصر"
                                                  : data![index].daysSelect ==
                                                          "SH"
                                                      ? "شب"
                                                      : "",
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Divider(color: Colors.blue),
                                Text(
                                    "کد پرسنلی : ${data![index].user.companyCode.toString().toPersianDigit()}"),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  Future get_all_shift_guard() async {
    String infourl = Helper.url.toString() + 'shift/get_today_shifts';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = shiftUserGuardMpdelFromJson(x);
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
