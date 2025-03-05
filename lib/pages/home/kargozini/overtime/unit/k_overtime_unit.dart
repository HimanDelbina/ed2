import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/pages/home/kargozini/overtime/unit/k_overtime_unit_select.dart';
import '../../../../../models/unit/unit_model.dart';
import '../../../../../static/helper_page.dart';

class kargoziniOvertimeUnitPage extends StatefulWidget {
  const kargoziniOvertimeUnitPage({super.key});

  @override
  State<kargoziniOvertimeUnitPage> createState() =>
      _kargoziniOvertimeUnitPageState();
}

class _kargoziniOvertimeUnitPageState extends State<kargoziniOvertimeUnitPage> {
  @override
  void initState() {
    super.initState();
    get_unit();
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
                    data = SearcUnit.search(show_data_Search, value, "name");
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
            child: is_get_data
                ? ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      user_search_controller.text == ""
                          ? data = data_show
                          : data = data;
                      show_data_Search = data_show!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    KargoziniOvertimeUnitSelect(
                                  unit_id: data![index].id,
                                ),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            width: my_width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Row(
                              children: [
                                Text(
                                  "${data![index].id.toString().toPersianDigit()} : ${data![index].name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
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
    );
  }

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();
  List? data = [];
  List? data_show = [];
  bool is_get_data = false;
  Future get_unit() async {
    String infourl = Helper.url.toString() + 'user/get_all_unit';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = unitModelFromJson(x);
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
