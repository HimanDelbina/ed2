import 'package:http/http.dart' as http;
import 'package:ed/models/food_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodReportPage extends StatefulWidget {
  const FoodReportPage({super.key});

  @override
  State<FoodReportPage> createState() => _FoodReportPageState();
}

class _FoodReportPageState extends State<FoodReportPage> {
  int? id_user = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
    });
    get_food_by_user_id();
    // get_two_leave_today_by_user_id();
  }

  bool? is_today = true;
  bool? is_month = false;
  bool? is_all = false;
  bool? is_accept = false;
  bool? is_reject = false;

  @override
  void initState() {
    super.initState();
    get_user_data();
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                show_filter("امروز", is_today, () {
                  setState(() {
                    is_today = true;
                    is_month = false;
                    is_all = false;
                    is_accept = false;
                    is_reject = false;
                    filter = "today";
                  });
                  get_food_by_user_id();
                }),
                show_filter("این ماه", is_month, () {
                  setState(() {
                    is_today = false;
                    is_month = true;
                    is_all = false;
                    is_accept = false;
                    is_reject = false;
                    filter = "this_month";
                  });
                  get_food_by_user_id();
                }),
                show_filter("همه", is_all, () {
                  setState(() {
                    is_today = false;
                    is_month = false;
                    is_all = true;
                    is_accept = false;
                    is_reject = false;
                    filter = "all";
                  });
                  get_food_by_user_id();
                }),
                show_filter("تایید شده", is_accept, () {
                  setState(() {
                    is_today = false;
                    is_month = false;
                    is_all = false;
                    is_accept = true;
                    is_reject = false;
                    filter = "accepted";
                  });
                  get_food_by_user_id();
                }),
                show_filter("تایید نشده", is_reject, () {
                  setState(() {
                    is_today = false;
                    is_month = false;
                    is_all = false;
                    is_accept = false;
                    is_reject = true;
                    filter = "not_accepted";
                  });
                  get_food_by_user_id();
                }),
              ],
            ),
          ),
          const Divider(),
          Expanded(
              child: is_get_data!
                  ? ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          margin: const EdgeInsetsDirectional.symmetric(
                              vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                               Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "درخواست : ${data![index].lunchSelect == "SH" ? "شام" : data![index].lunchSelect == "SO" ? "صبحانه" : data![index].lunchSelect == "NA" ? "نهار" : ""}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: data![index].lunchSelect == "SH"
                                            ? Colors.deepOrange
                                            : data![index].lunchSelect == "SO"
                                                ? Colors.purple
                                                : data![index].lunchSelect ==
                                                        "NA"
                                                    ? Colors.black
                                                    : Colors.blue),
                                  ),
                                  Text(
                                    data![index].isAccept
                                        ? "تایید شد"
                                        : "تایید نشد",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                        color: data![index].isAccept
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                ],
                              ),


                              const Divider(),
                              Text(
                                  "تاریخ دریافت غذا : ${FormateDateCreateChange.formatDate(data![index].foodDate.toString())}"),
                             
                              data![index].description == ""
                                  ? const SizedBox()
                                  : const Divider(),
                              data![index].description == ""
                                  ? const SizedBox()
                                  : Text(data![index].description)
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0))),
        ],
      ),
    );
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
  bool? is_get_data = false;
  double? sumData;

  String? filter = "today";

  Future get_food_by_user_id() async {
    String infourl = Helper.url.toString() +
        'food/get_food_by_user_id/${id_user.toString()}?filter_type=${filter}';
    print(infourl);
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = foodModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
