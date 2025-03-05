import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';

class ClothesAddPage extends StatefulWidget {
  const ClothesAddPage({super.key});

  @override
  State<ClothesAddPage> createState() => _ClothesAddPageState();
}

class _ClothesAddPageState extends State<ClothesAddPage> {
  @override
  void initState() {
    super.initState();
    get_all_user();
  }

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("انتخاب کارمند : "),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(),
                  ),
                  child: TypeAheadField<String>(
                    itemBuilder: (context, String suggestion) {
                      return ListTile(title: Text(suggestion));
                    },
                    controller: unitController,
                    onSelected: (String? suggestion) {
                      unitController.text = suggestion!;
                      Text(suggestion);
                      for (var i = 0; i < data_user!.length; i++) {
                        if (data_user![i].firstName +
                                " " +
                                data_user![i].lastName ==
                            suggestion) {
                          setState(() {
                            user_id_select = data_user![i].id;
                            user_select = data_user![i].firstName;
                          });
                        }
                      }
                      print(user_id_select);
                    },
                    suggestionsCallback: (String pattern) async {
                      return user_items!
                          .where((x) => x.contains(pattern))
                          .toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                is_clothe! != is_clothe!;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SwitchListTile(
                title: const Text("لباس کار",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                value: is_clothe!,
                onChanged: (value) {
                  setState(() {
                    is_clothe = value;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  is_shoes! != is_shoes!;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SwitchListTile(
                  title: const Text("کفش کار",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  value: is_shoes!,
                  onChanged: (value) {
                    setState(() {
                      is_shoes = value;
                    });
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              create_clothe();
            },
            child: Container(
              height: my_height * 0.06,
              width: my_width,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
              child: const Center(
                child: Text("ثبت",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool? is_clothe = false;
  bool? is_shoes = false;

  List<String>? user_items = [];
  List? data_user = [];
  String? user_select = "";
  int? user_id_select;
  TextEditingController unitController = TextEditingController();
  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_all_user() async {
    String infourl = Helper.url.toString() + 'user/get_all_user';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = usersModelFromJson(x);
      setState(() {
        data = recive_data;
        data_user = data;
        is_get_data = true;
      });
      for (var i = 0; i < data_user!.length; i++) {
        setState(() {
          user_items!
              .add(data_user![i].firstName + " " + data_user![i].lastName);
        });
      }
      print(user_items);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali? date_now = Jalali.now();
  DateTime timeNow = DateTime.now();

  String? formattedTime = '';
  Future create_clothe() async {
    String jalaliDateTime = "${timeNow.hour}:${timeNow.minute}";
    formattedTime = DateFormat.Hm().format(timeNow);
    var jalaliDate = date_now!.formatter.yyyy +
        '-' +
        date_now!.formatter.mm +
        '-' +
        date_now!.formatter.dd +
        ' ' +
        formattedTime!;
    var body = jsonEncode({
      "user": user_id_select,
      "is_cloth": is_clothe,
      "is_shoes": is_shoes,
      "shoes_date": is_shoes! ? jalaliDate : null,
      "cloth_date": is_clothe! ? jalaliDate : null
    });
    print(body);
    String infourl = Helper.url.toString() + 'anbar/create_cloth';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 201) {
      setState(() {});

      MyMessage.mySnackbarMessage(context, "لباس کار با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
