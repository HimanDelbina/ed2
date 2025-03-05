import 'package:ed/models/unit/unit_with_userCount_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../models/unit/unit_model.dart';
import '../../../../static/helper_page.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'unit_admin_select.dart';

class UnitManagerFirstPage extends StatefulWidget {
  const UnitManagerFirstPage({super.key});

  @override
  State<UnitManagerFirstPage> createState() => _UnitManagerFirstPageState();
}

class _UnitManagerFirstPageState extends State<UnitManagerFirstPage> {
  @override
  void initState() {
    super.initState();
    get_unit();
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
              Container(
                width: my_width,
                child: TextFormField(
                  controller: user_search_controller,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        // بازگشت به داده‌های اصلی
                        data = data_show;
                      } else {
                        // فیلتر کردن واحدها بر اساس مقدار جستجو
                        data = _filterUnits(value);
                      }
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
              Text(
                  "تعداد کل پرسنل : ${data.totalUsersCount.toString().toPersianDigit()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
              Expanded(
                child: is_get_data
                    ? ListView.builder(
                        itemCount: data.unit?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UnitAdminSelectPage(
                                    unit_id: data.unit![index].id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                width: my_width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5)),
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${(index + 1).toString().toPersianDigit()} : ${data.unit![index].name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "تعداد کاربران : ${data.unit![index].userCount.toString().toPersianDigit()}")
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
          ),
        ),
      ),
    );
  }

  UnitWithUserCountModel show_data_Search = UnitWithUserCountModel();
  TextEditingController user_search_controller = TextEditingController();
  UnitWithUserCountModel data = UnitWithUserCountModel();
  UnitWithUserCountModel data_show = UnitWithUserCountModel();
  bool is_get_data = false;

  // تابع فیلتر کردن واحدها بر اساس نام
  UnitWithUserCountModel _filterUnits(String query) {
    List<Unit> filteredUnits = data_show.unit!
        .where((unit) => unit.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return UnitWithUserCountModel(
      unit: filteredUnits,
      totalUsersCount: filteredUnits.length,
    );
  }

  // دریافت واحدها از API
  Future get_unit() async {
    String infourl =
        Helper.url.toString() + 'user/get_all_unit_with_user_count';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = unitWithUserCountModelFromJson(x);

      setState(() {
        data = recive_data;
        data_show = recive_data; // ذخیره داده‌ها در data_show
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
