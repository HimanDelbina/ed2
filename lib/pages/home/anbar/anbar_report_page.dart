import 'package:ed/models/anbar_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../static/helper_page.dart';

class AnbarReportPage extends StatefulWidget {
  const AnbarReportPage({super.key});

  @override
  State<AnbarReportPage> createState() => _AnbarReportPageState();
}

class _AnbarReportPageState extends State<AnbarReportPage> {
  int? id_user = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
    });
    get_anbar_by_user_id();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  String? acceptOnlyDate = "";
  String? acceptAnbarOnlyDate = "";
  String onlyTime = "";
  String onlyTimeAnbar = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: PagePadding.page_padding,
        child: ListView.builder(
          itemCount: data!.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsetsDirectional.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data![index].user.firstName ?? ""} ${data![index].user.lastName ?? ""}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        "تاریخ : ${FormateDateCreateChange.formatDate(data![index].createAt.toString())}"),
                  ],
                ),
                subtitle: Column(
                  children: [
                    data![index].isAccept
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " مرحله ${1.toString().toPersianDigit()} تایید مدیر : تایید شد",
                                style: const TextStyle(color: Colors.green),
                              ),
                              const Icon(Icons.check, size: 15.0)
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " مرحله ${1.toString().toPersianDigit()} تایید مدیر : هنوز تایید نشده",
                                style: const TextStyle(color: Colors.red),
                              ),
                              const Icon(Icons.clear, size: 15.0)
                            ],
                          ),
                    data![index].anbarAccept
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " مرحله ${2.toString().toPersianDigit()} تایید انبار : تایید شد",
                                style: const TextStyle(color: Colors.green),
                              ),
                              const Icon(Icons.check, size: 15.0)
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " مرحله ${2.toString().toPersianDigit()} تایید انبار : هنوز تایید نشده",
                                style: const TextStyle(color: Colors.red),
                              ),
                              const Icon(Icons.clear, size: 15.0)
                            ],
                          ),
                  ],
                ),
                children: [
                  const Divider(indent: 10.0, endIndent: 10.0),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(children: [Text("لیست کالا ها : ")])),
                  data![index].commodities.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data![index].commodities.length,
                          itemBuilder: (context, commodityIndex) {
                            var commodity =
                                data![index].commodities[commodityIndex];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${(commodityIndex + 1).toString().toPersianDigit()} : ${commodity.name}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "تعداد : ${commodity.count.toString().toPersianDigit()} ${commodity.unit}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Row(children: [
                          Text('هیچ کالایی برای نمایش وجود ندارد'),
                        ]),
                ],
              ),
            );
          },
        ));
  }

  List? data = [];
  List? data_product = [];
  bool? is_get_data = false;
  List tempDataProduct = [];
  Future<void> get_anbar_by_user_id() async {
    String infourl = Helper.url.toString() +
        'anbar/get_anbar_by_user_id/${(id_user?.toString() ?? '')}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = anbarModelFromJson(x);

      if (recive_data != null) {
        for (var anbar in recive_data) {
          tempDataProduct.add({
            'anbar': anbar,
            'commodities': anbar.commodities,
          });
        }
        setState(() {
          data = recive_data;
          is_get_data = true;
        });
      }
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future delete_anbar(int anbar_id) async {
    String infourl = Helper.url.toString() +
        'anbar/delete_anbar_by_id/${anbar_id.toString()}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت حذف شد", 1);
      get_user_data();
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
