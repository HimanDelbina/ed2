import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ed/pages/home/kargozini/sms/save_sms.dart';
import '../../../../models/message/sms_save_model.dart';
import '../../../../static/helper_page.dart';

class SmsAllSend extends StatefulWidget {
  const SmsAllSend({super.key});

  @override
  State<SmsAllSend> createState() => _SmsAllSendState();
}

class _SmsAllSendState extends State<SmsAllSend> {
  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
    get_sms_save();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          my_form(controllerDescription, description, "متن پیام", false,
              IconlyBold.paper, TextInputType.name),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("پیام های ذخیره شده"),
              ),
              Expanded(child: Divider(color: Colors.grey))
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      select_sms_id = index;
                      select_sms = data![index].content;
                      controllerDescription.text = select_sms!;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInBack,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: select_sms_id == index
                              ? Colors.green.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5)),
                      color: select_sms_id == index
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin:
                        const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                              select_sms_id == index
                                  ? Icons.check
                                  : Icons.remove,
                              color: select_sms_id == index
                                  ? Colors.green
                                  : Colors.grey,
                              size: 15.0),
                        ),
                        Expanded(
                            child: Text(
                          data![index].content,
                          style: TextStyle(
                              fontWeight: select_sms_id == index
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    create_sms();
                  },
                  child: Container(
                    height: my_height * 0.06,
                    // width: my_width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Center(
                      child: Text(
                        "ارسال پیام",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SaveSmsPage(),
                      ));
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width * 0.12,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: const EdgeInsets.only(right: 10.0),
                  child: const Icon(IconlyBold.message),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
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
        maxLines: 5,
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
    var body =
        jsonEncode({"sender": id_user, "content": controllerDescription.text});
    String infourl = Helper.url.toString() + 'message/send_all_sms';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      setState(() {
        controllerDescription.clear();
      });

      MyMessage.mySnackbarMessage(context, "اس ام اس با موفقیت ارسال شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  List? data = [];
  bool? is_get_data = false;
  Future get_sms_save() async {
    String infourl = Helper.url.toString() + 'message/get_all_save_sms';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = smsDefaultModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? select_sms;
  int? select_sms_id;
}
