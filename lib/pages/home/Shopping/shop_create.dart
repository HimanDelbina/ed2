import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../static/helper_page.dart';

class ShopCreate extends StatefulWidget {
  const ShopCreate({super.key});

  @override
  State<ShopCreate> createState() => _ShopCreateState();
}

class _ShopCreateState extends State<ShopCreate> {
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
  }

  bool? is_fori = true;
  bool? is_zarori = false;
  String? selected = "F";

  List<Map> map_parts = [];
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = "F";
                      is_zarori = false;
                      is_fori = true;
                    });
                  },
                  child: Container(
                    height: my_height * 0.04,
                    width: my_width * 0.2,
                    decoration: BoxDecoration(
                      color:
                          is_fori! ? Colors.blue : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        "فوری",
                        style: TextStyle(
                          fontWeight:
                              is_fori! ? FontWeight.bold : FontWeight.normal,
                          color: is_fori! ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = "Z";
                    is_fori = false;
                    is_zarori = true;
                  });
                },
                child: Container(
                  height: my_height * 0.04,
                  width: my_width * 0.2,
                  decoration: BoxDecoration(
                    color:
                        is_zarori! ? Colors.blue : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "خیلی ضروری",
                      style: TextStyle(
                        fontWeight:
                            is_zarori! ? FontWeight.bold : FontWeight.normal,
                        color: is_zarori! ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          my_form(controllerName, name, "نام کالا", false, Icons.description,
              TextInputType.name, 1),
          my_form(controllerCount, count, "تعداد کالا", false, Icons.numbers,
              TextInputType.number, 1),
          GestureDetector(
            onTap: () {
              setState(() {
                map_parts.add({
                  "name": controllerName.text,
                  "count": controllerCount.text,
                  "accept": false
                });
              });
              controllerName.clear();
              controllerCount.clear();
              print(map_parts);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 17.0, color: Colors.white),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("اضافه کردن کالا",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          my_form(controllerDescription, description, "توضیحات", false,
              Icons.description, TextInputType.name, 3),
          const Row(children: [Text("کالا ها  "), Expanded(child: Divider())]),
          Expanded(
              child: map_parts.isNotEmpty
                  ? ListView.builder(
                      itemCount: map_parts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "نام کالا : ${map_parts[index]['name']}"),
                                    Text(
                                        "تعداد : ${map_parts[index]['count'].toString().toPersianDigit()}"),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        map_parts.removeAt(index);
                                      });
                                    },
                                    child: const Icon(IconlyBold.delete,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("کالایی انتخاب نشده"))),
          const Spacer(),
          GestureDetector(
            onTap: () {
              create_shopping();
            },
            child: Container(
              height: my_height * 0.06,
              width: my_width,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Center(
                child: Text(
                  "تایید",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? name = "";
  TextEditingController controllerName = TextEditingController();
  String? count = "";
  TextEditingController controllerCount = TextEditingController();
  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
    int? maxline,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        cursorColor: Colors.blue,
        maxLines: maxline,
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

  Jalali? manager_date = Jalali.now();
  Future create_shopping() async {
    var jalaliManager = manager_date!.formatter.yyyy +
        '-' +
        manager_date!.formatter.mm +
        '-' +
        manager_date!.formatter.dd +
        ' ' +
        '00:00';
    var body = jsonEncode({
      "user": id_user,
      "shop_data": map_parts,
      "description": controllerDescription.text,
      "type": selected,
      "manager_accept": false,
      "anbar_accept": true,
      "bazargani_accept": false,
      "is_shop": false,
      "manager_date": null,
      "anbar_date": jalaliManager,
      "shop_date": null,
      "bazargani_date": null,
    });
    String infourl = Helper.url.toString() + 'anbar/create_shop';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      setState(() {
        controllerName.clear();
        controllerCount.clear();
        controllerDescription.clear();
      });
      MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
