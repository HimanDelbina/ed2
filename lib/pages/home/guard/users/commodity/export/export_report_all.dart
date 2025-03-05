import 'package:ed/pages/home/guard/users/commodity/export/export_accept_guard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/guard/export/export_commodity_model.dart';
import 'package:http/http.dart' as http;
import '../../../../../../static/helper_page.dart';

class ExportReportAll extends StatefulWidget {
  const ExportReportAll({super.key});

  @override
  State<ExportReportAll> createState() => _ExportReportAllState();
}

class _ExportReportAllState extends State<ExportReportAll> {
  @override
  void initState() {
    super.initState();
    get_all_commodity();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data! == false
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : data!.isEmpty
              ? const Center(child: Text("داده ای وجود ندارد"))
              : ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: my_width,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "نوع خروجی : ${data![index].select == "A" ? "امانی" : data![index].select == "B" ? "برگشت امانی" : data![index].select == "T" ? "تعمیر کاری" : data![index].select == "T" ? "فروش" : data![index].select == "Z" ? "ضایعات" : ""}",
                              ),
                              Text("شرکت : ${data![index].company.name}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${data![index].name} - تعداد : ${data![index].count.toString().toPersianDigit()} عدد",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                FormateDateCreate.formatDate(
                                    data![index].createAt.toString()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                          data![index].isPrint
                              ? const SizedBox()
                              : const Text(
                                  "شما هنوز از فاکتور پرینت نگرفته اید و بایگانی نکردید",
                                  style: TextStyle(color: Colors.red),
                                ),
                          const Divider(),
                          Row(
                            children: [
                              Text(
                                  " ${data![index].select == "A" ? "دریافت کننده" : data![index].select == "B" ? "دریافت کننده" : data![index].select == "T" ? "تعمیرکار" : data![index].select == "F" ? "خریدار" : data![index].select == "Z" ? "خریدار" : ""} : "),
                              Text(data![index].select == "A"
                                  ? data![index].recipient
                                  : data![index].select == "B"
                                      ? data![index].recipient
                                      : data![index].select == "T"
                                          ? data![index].repairMan
                                          : data![index].select == "F"
                                              ? data![index].buyer
                                              : data![index].select == "Z"
                                                  ? data![index].buyer
                                                  : ""),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Icon(
                                      data![index].isAnbar
                                          ? Icons.check
                                          : Icons.clear,
                                      size: 15.0,
                                      color: data![index].isAnbar
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(
                                      "تاییدیه انبار : ${data![index].isAnbar ? "دارد" : "ندارد"}"),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  data![index].isAdmin
                                      ? Icons.check
                                      : Icons.clear,
                                  size: 15.0,
                                  color: data![index].isAdmin
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(data![index].isAdmin
                                  ? "تاییدیه مدیر : تایید شده"
                                  : "تاییدیه مدیر : لطفا منتظر تایید باشید"),
                            ],
                          ),
                          const Divider(),
                          data![index].isAdmin
                              ? data![index].isGuard
                                  ? Text("درخواست توسط نگهبانی تایید شد")
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ExportAcceptGuard(
                                                data: data![index],
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 5.0),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: const Text(
                                          "تایید",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                              : const Text(
                                  "اول باید تاییدیه مدیر رو داشته باشید بعد میتونید خروح را نهایی کنید"),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget is_accept(String title, bool is_data, var date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Icon(is_data ? Icons.check : Icons.clear,
                  size: 15.0, color: is_data ? Colors.green : Colors.red),
            ),
            Text(title),
          ],
        ),
        Text(date == null ? "" : FormateDateCreate.formatDate(date.toString()))
      ],
    );
  }

  List? data = [];
  bool? is_get_data = false;
  Future get_all_commodity() async {
    String infourl =
        Helper.url.toString() + 'guard/get_all_export_commodity_NOFilter';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = exportCommodityModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
