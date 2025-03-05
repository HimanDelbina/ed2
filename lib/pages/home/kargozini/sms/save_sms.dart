import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:ed/components/delete_default_sms.dart';
import 'package:ed/static/helper_page.dart';
import '../../../../components/sms_save_service.dart';
import '../../../../models/message/sms_save_model.dart';

class SaveSmsPage extends StatefulWidget {
  const SaveSmsPage({super.key});

  @override
  State<SaveSmsPage> createState() => _SaveSmsPageState();
}

class _SaveSmsPageState extends State<SaveSmsPage> {
  List<SmsDefaultModel> data = [];
  bool is_get_data = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var result = await SmsService.getSmsSave(context);
    setState(() {
      data = result;
      is_get_data = true;
    });
  }

  // متد برای ویرایش پیام
  Future<void> _editSms(SmsDefaultModel sms) async {
    TextEditingController controller = TextEditingController(text: sms.content);

    // نمایش دیالوگ و ویرایش متن
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ویرایش پیام'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration:
                const InputDecoration(hintText: 'متن جدید را وارد کنید'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // بستن دیالوگ بدون انجام هیچ کاری
                Navigator.pop(context);
              },
              child: const Text(
                'انصراف',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                // ارسال درخواست ویرایش پیام
                await SmsService.editSmsDefault(
                    context, smsID!, controller.text);
                // بعد از ویرایش داده‌ها را بارگذاری می‌کنیم
                await _loadData();
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: const Text(
                    'ذخیره',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        );
      },
    );
  }

  int? smsID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            children: [
              Expanded(
                child: is_get_data
                    ? ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 7.0, horizontal: 15.0),
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  data[index].content!,
                                  textAlign: TextAlign.justify,
                                )),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      smsID = data[index].id!;
                                    });
                                    // نمایش دیالوگ برای ویرایش
                                    _editSms(data[index]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Center(
                                        child: Icon(IconlyBold.edit,
                                            color: Colors.amber, size: 20.0)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      smsID = data[index].id!;
                                    });
                                    await DefaultSmsService.deleteUserById(
                                        context, smsID!); // حذف کاربر با id 1
                                    _loadData();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: const Center(
                                        child: Icon(IconlyBold.delete,
                                            color: Colors.red, size: 20.0)),
                                  ),
                                ),
                              ],
                            ),
                          );
                          // return ListTile(title: Text(data[index].content!));
                        },
                      )
                    : Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0),
                      ),
              ),
              const Divider(),
              my_form(smsController, smsData, "متن اس ام اس", false,
                  Icons.message, TextInputType.text),
              GestureDetector(
                onTap: () {
                  create_sms();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "اضافه کردن متن اس ام اس",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController smsController = TextEditingController();
  String? smsData;

  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
        ),
      ),
    );
  }

  Future create_sms() async {
    var body = jsonEncode({
      "content": smsController.text,
    });
    String infourl = Helper.url.toString() + 'message/create_save_sms';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 201) {
      setState(() {
        smsController.clear();
      });
      _loadData();
      MyMessage.mySnackbarMessage(context, "اس ام اس با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
