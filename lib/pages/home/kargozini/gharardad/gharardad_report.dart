import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/gharardad/ghararda_model.dart';
import 'package:ed/models/gharardad/gharardad_count_model.dart';
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';

class GharardadReport extends StatefulWidget {
  const GharardadReport({super.key});

  @override
  State<GharardadReport> createState() => _GharardadReportState();
}

class _GharardadReportState extends State<GharardadReport> {
  @override
  void initState() {
    super.initState();
    get_all_user();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              textAlign: TextAlign.justify,
              "در این بخش، شما می‌توانید تمامی قراردادهای کاربر را مشاهده و جزئیات آن‌ها را بررسی کنید."),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("انتخاب کارمند : "),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(),
                  ),
                  child: TypeAheadField<String>(
                    itemBuilder: (context, String suggestion) {
                      return ListTile(title: Text(suggestion));
                    },
                    controller: unitController,
                    onSelected: (String? suggestion) {
                      unitController.text = suggestion!;
                      Text(suggestion);
                      for (var i = 0; i < data_user!.length; i++) {
                        if (data_user![i].firstName +
                                " " +
                                data_user![i].lastName ==
                            suggestion) {
                          setState(() {
                            user_id_select = data_user![i].id;
                            user_select = data_user![i].firstName;
                          });
                        }
                      }
                      print(user_id_select);
                      get_all_gharardad_by_userId();
                    },
                    suggestionsCallback: (String pattern) async {
                      return user_items!
                          .where((x) => x.contains(pattern))
                          .toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Text(
              "تعداد قرارداد های موجود تا امروز : ${data_count == null ? 0.toString().toPersianDigit() : data_count.toString().toPersianDigit()} عدد"),
          Expanded(
              child: user_id_select == null
                  ? const Center(child: Text("لطفا کارمند را انتخاب کنید"))
                  : is_get_gh == false
                      ? Center(
                          child: Lottie.asset("assets/lottie/loading.json",
                              height: 40.0))
                      : data_gh!.isEmpty
                          ? const Center(child: Text("قراردادی وجود ندارد"))
                          : ListView.builder(
                              itemCount: data_gh!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                  margin: const EdgeInsetsDirectional.symmetric(
                                      vertical: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "تاریخ شروع : ${FormateDateCreateChange.formatDate(data_gh![index].startDate.toString())}"),
                                          Text(
                                              "تاریخ پایان : ${FormateDateCreateChange.formatDate(data_gh![index].endDate.toString())}"),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "مبلغ پایه قرارداد : ${data_gh![index].money.toString().toPersianDigit().seRagham()} ریال"),
                                          Text(
                                              "مدت قرارداد : ${data_gh![index].daysBetween.toString().toPersianDigit()} روز"),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ))
        ],
      ),
    );
  }

  List<String>? user_items = [];
  List? data_user = [];
  String? user_select = "";
  int? user_id_select;
  TextEditingController unitController = TextEditingController();
  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_all_user() async {
    String infourl = Helper.url.toString() + 'user/get_all_user';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = usersModelFromJson(x);
      setState(() {
        data = recive_data;
        data_user = data;
        is_get_data = true;
      });
      for (var i = 0; i < data_user!.length; i++) {
        setState(() {
          user_items!
              .add(data_user![i].firstName + " " + data_user![i].lastName);
        });
      }
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  List? data_gh = [];
  bool? is_get_gh = false;
  int? data_count;
  Future get_all_gharardad_by_userId() async {
    String infourl = Helper.url.toString() +
        'gharardad/get_all_gharardad_by_userId/${user_id_select}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = gharardadCountModelFromJson(x);
      setState(() {
        data_gh = recive_data.data;
        is_get_gh = true;
        data_count = recive_data.recordCount;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
