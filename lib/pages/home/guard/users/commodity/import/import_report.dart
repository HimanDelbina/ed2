import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/pages/home/guard/users/commodity/import/import_edit.dart';
import '../../../../../../models/guard/import/import_commodity_model.dart';
import '../../../../../../static/helper_page.dart';

class ImportReportPage extends StatefulWidget {
  const ImportReportPage({super.key});

  @override
  State<ImportReportPage> createState() => _ImportReportPageState();
}

class _ImportReportPageState extends State<ImportReportPage> {
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
                                  " نوع ورودی : ${data![index].select == "K" ? "کالا" : "مواد اولیه"}"),
                              Text("شرکت : ${data![index].company.name}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${data![index].name} - تعداد : ${data![index].countCommodity.toString().toPersianDigit()} عدد",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                FormateDateCreate.formatDate(
                                    data![index].createAt.toString()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          data![index].isPrint
                              ? const SizedBox()
                              : const Text(
                                  "شما هنوز از فاکتور پرینت نگرفته اید و بایگانی نکردید",
                                  style: TextStyle(color: Colors.red),
                                ),
                          const Divider(),
                          Text(
                              "درخواست شما دارای ${2.toString().toPersianDigit()} مرحله تاییدیه است لطفا تا تاییدیه کامل منتظر باشید ممنون ."),
                          is_accept(
                              "مرحله ${1.toString().toPersianDigit()} : تاییدیه انبار",
                              data![index].isAnbar,
                              data![index].anbarDate),
                          is_accept(
                              "مرحله ${2.toString().toPersianDigit()} : تاییدیه مدیر",
                              data![index].isAdmin,
                              data![index].adminDate),
                          data![index].isEdit
                              ? const Text(
                                  "درخواست ویرایش براس این ورودی ثبت شده است لطفا در اسرع وفت اقدام به ویرایش کنید ممنون .")
                              : const SizedBox(),
                          data![index].isEdit
                              ? Text(data![index].editDescription == ""
                                  ? "برای ویرایش توضیحاتی ذکر نشده"
                                  : data![index].editDescription)
                              : const SizedBox(),
                          data![index].isEdit
                              ? const Divider()
                              : const SizedBox(),
                          data![index].isEdit
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImportEditPage(
                                                    data: data![index])));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding:
                                        const EdgeInsetsDirectional.all(5.0),
                                    child: const Center(
                                      child: Icon(IconlyBold.edit,
                                          color: Colors.black),
                                    ),
                                  ),
                                )
                              : const SizedBox()
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
    String infourl = Helper.url.toString() + 'guard/get_all_commodity';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = importCommodityModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
