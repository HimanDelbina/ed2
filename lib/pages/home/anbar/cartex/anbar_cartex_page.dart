import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/cartex/cartex_model.dart';
import '../../../../static/helper_page.dart';

class AnbarCartexPage extends StatefulWidget {
  const AnbarCartexPage({super.key});

  @override
  State<AnbarCartexPage> createState() => _AnbarCartexPageState();
}

class _AnbarCartexPageState extends State<AnbarCartexPage> {
  int? id_user = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
    });
    get_cartex_by_user_id();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data! == false
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "تعداد کالا در کارتکس شما : ${data_count!.toString().toPersianDigit()} عدد"),
                Expanded(
                  child: data!.isEmpty
                      ? const Center(child: Text("دادهای وجود ندارد"))
                      : ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "${(index + 1).toString().toPersianDigit()} : ${data![index].name}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  int? data_count;
  double? sumData;
  Future get_cartex_by_user_id() async {
    String infourl = Helper.url.toString() +
        'anbar/get_cartex_by_user_id/${id_user.toString()}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = cartexGetModelFromJson(x);
      setState(() {
        data = recive_data.data;
        data_count = recive_data.count;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
