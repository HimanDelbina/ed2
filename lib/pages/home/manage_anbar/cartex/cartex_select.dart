import 'package:ed/models/cartex/cartex_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';

class ManagerAnbarCartexSelect extends StatefulWidget {
  int? user_id;
  ManagerAnbarCartexSelect({super.key, this.user_id});

  @override
  State<ManagerAnbarCartexSelect> createState() =>
      _ManagerAnbarCartexSelectState();
}

class _ManagerAnbarCartexSelectState extends State<ManagerAnbarCartexSelect> {
  @override
  void initState() {
    super.initState();
    get_cartex_by_user_id();
  }

  String? onlyDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cartex_count == null
                  ? const Text("")
                  : Text(
                      "تعداد کالاهای در تحویل : ${cartex_count.toString().toPersianDigit()}"),
              const Divider(),
              Expanded(
                child: is_get_data! == false
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0))
                    : data!.isEmpty
                        ? const Center(child: Text("داده ای وجود ندارد"))
                        : ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              String endDateString =
                                  data![index].createAt.toString();
                              onlyDate = endDateString.split(' ')[0];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${(index + 1).toString().toPersianDigit()} : ${data![index].name}"),
                                        Text(
                                          onlyDate!.toPersianDigit(),
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        )
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("آیا مایل به حذف هستید ؟"),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                select_cartex = data![index].id;
                                              });
                                              delete_cartex_by_id();
                                            },
                                            child: const Icon(IconlyBold.delete,
                                                color: Colors.red, size: 20.0))
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  int? cartex_count;
  Future get_cartex_by_user_id() async {
    String infourl = Helper.url.toString() +
        'anbar/get_cartex_by_user_id/' +
        widget.user_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = cartexGetModelFromJson(x);
      setState(() {
        data = recive_data.data;
        cartex_count = recive_data.count;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? select_cartex;
  Future delete_cartex_by_id() async {
    String infourl = Helper.url.toString() +
        'anbar/delete_cartex_by_id/' +
        select_cartex.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_cartex_by_user_id();
      MyMessage.mySnackbarMessage(context, "کارتکس با موفقیت حذف شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
