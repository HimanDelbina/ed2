import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/static/helper_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../../models/phone/phone_get_model.dart';

class PhoneAdminFirstPage extends StatefulWidget {
  const PhoneAdminFirstPage({super.key});

  @override
  State<PhoneAdminFirstPage> createState() => _PhoneAdminFirstPageState();
}

class _PhoneAdminFirstPageState extends State<PhoneAdminFirstPage> {
  @override
  void initState() {
    get_all_phone();
    super.initState();
  }

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();

  void showEditDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ویرایش اطلاعات"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "نام"),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "تلفن"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // بستن دیالوگ
              },
              child: const Text("لغو"),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  editPhone(data![index].id); // فراخوانی تابع ویرایش
                  Navigator.of(context).pop(); // بستن دیالوگ
                } else {
                  MyMessage.mySnackbarMessage(
                      context, "لطفاً همه فیلدها را پر کنید", 1);
                }
              },
              child: const Text("ذخیره"),
            ),
          ],
        );
      },
    );
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
          children: [
            const Text(
                textAlign: TextAlign.justify,
                "در این بخش، می‌توانید لیست شماره‌های داخلی شرکت را مشاهده کنید. برای تماس با هر بخش، کافی است روی شماره مورد نظر کلیک کنید و تماس خود را شروع کنید."),
            const Divider(),
            Container(
              width: my_width,
              child: TextFormField(
                controller: user_search_controller,
                onChanged: (value) {
                  setState(() {
                    setState(() {
                      data = SearcPhone.search(show_data_Search, value, "name");
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
              child: ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  user_search_controller.text == ""
                      ? data = data_show
                      : data = data;
                  show_data_Search = data_show!;
                  return GestureDetector(
                    onTap: () {
                      _makePhoneCall("03591009898");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data![index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text("( ${data![index].company.name} )",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ],
                          ),
                          Text(data![index].phone.toString().toPersianDigit(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      phoneID = data![index].id;
                                    });
                                    delete_phone(phoneID);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5)),
                                    ),
                                    child: const Icon(IconlyBold.delete,
                                        color: Colors.red, size: 20.0),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    nameController.text = data![index].name;
                                    phoneController.text =
                                        data![index].phone.toString();
                                  });
                                  showEditDialog(context, index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.5)),
                                  ),
                                  child: const Icon(IconlyBold.edit,
                                      color: Colors.blue, size: 20.0),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  List? data_show = [];
  List? data = [];
  bool? is_get_data = false;
  Future get_all_phone() async {
    String infourl = Helper.url.toString() + 'phone/get_all_phone';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = phoneModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? phoneID;
  Future delete_phone(int? id) async {
    String infourl =
        Helper.url.toString() + 'phone/delete_phone_by_id/${id.toString()}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "شماره داخلی با موفقیت حذف شد", 1);
      get_all_phone();
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Future editPhone(int? id) async {
    var body = jsonEncode(
        {"name": nameController.text, "phone": phoneController.text});
    String infourl = Helper.url.toString() + 'phone/edit_phone/${id}';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_phone();
      MyMessage.mySnackbarMessage(
          context, "درخواست شما با موفقیت ویرایش شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
