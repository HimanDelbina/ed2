import 'dart:convert';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_page.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;
import '../../../../models/users/users_model.dart';

class GharardadCreatePage extends StatefulWidget {
  const GharardadCreatePage({super.key});

  @override
  State<GharardadCreatePage> createState() => _GharardadCreatePageState();
}

class _GharardadCreatePageState extends State<GharardadCreatePage> {
  Jalali? pickedDateStart = Jalali.now();
  Jalali? pickedDateEnd = Jalali.now();
  String? date_select_start = "";
  String? date_select_end = "";

  @override
  void initState() {
    super.initState();
    get_all_user();
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Container(
                height: my_height * 0.06,
                width: my_width,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0)),
                child: ListTile(
                  onTap: () async {
                    pickedDateStart = await showModalBottomSheet<Jalali>(
                      context: context,
                      builder: (context) {
                        Jalali? tempPickedDate;
                        return Container(
                          height: 250,
                          color: Colors.blue,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CupertinoButton(
                                      child: const Text(
                                        'لغو',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoButton(
                                      child: const Text(
                                        'تایید',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            tempPickedDate ?? Jalali.now());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 0, thickness: 1),
                              Expanded(
                                child: Container(
                                  child: PCupertinoDatePicker(
                                    mode: PCupertinoDatePickerMode.date,
                                    onDateTimeChanged: (Jalali dateTime) {
                                      tempPickedDate = dateTime;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                    if (pickedDateStart != null) {
                      setState(() {
                        date_select_start = '${pickedDateStart!.toDateTime()}';
                      });
                    }
                  },
                  title: const Text(
                    "تاریخ شروع قرارداد",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    pickedDateStart!
                        .toGregorian()
                        .toDateTime()
                        .toIso8601String()
                        .toPersianDate(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: my_height * 0.06,
                  width: my_width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListTile(
                    onTap: () async {
                      pickedDateEnd = await showModalBottomSheet<Jalali>(
                        context: context,
                        builder: (context) {
                          Jalali? tempPickedDate;
                          return Container(
                            height: 250,
                            color: Colors.blue,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      CupertinoButton(
                                        child: const Text(
                                          'لغو',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoButton(
                                        child: const Text(
                                          'تایید',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                              tempPickedDate ?? Jalali.now());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 0, thickness: 1),
                                Expanded(
                                  child: Container(
                                    child: PCupertinoDatePicker(
                                      mode: PCupertinoDatePickerMode.date,
                                      onDateTimeChanged: (Jalali dateTime) {
                                        tempPickedDate = dateTime;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      if (pickedDateEnd != null) {
                        setState(() {
                          date_select_end = '${pickedDateEnd!.toDateTime()}';
                        });
                      }
                    },
                    title: const Text(
                      "تاریخ پایان قرارداد",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      pickedDateEnd!
                          .toGregorian()
                          .toDateTime()
                          .toIso8601String()
                          .toPersianDate(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ),
              my_form(controllerMoney, money, "حقوق پایه", false,
                  Icons.attach_money, TextInputType.number),
              controllerMoney.text == ""
                  ? const Text("")
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${controllerMoney.text.toPersianDigit().seRagham()} هزار ریال"),
                        Text(
                            "${controllerMoney.text.beToman().toPersianDigit().seRagham()} هزار تومان"),
                      ],
                    ),
              controllerMoney.text == ""
                  ? const Text("")
                  : Text("${controllerMoney.text.toWord()} ریال"),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  create_gharardad();
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
                          fontSize: 20.0,
                          color: Colors.white,
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

  String? money = "";
  TextEditingController controllerMoney = TextEditingController();
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
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
        },
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
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? formattedStartTime = "";
  String? formattedEndTime = "";

  Future create_gharardad() async {
    if (user_id_select == null) {
      MyMessage.mySnackbarMessage(context, "لطفاً یک کارمند انتخاب کنید", 1);
      return;
    }

    if (controllerMoney.text.isEmpty) {
      MyMessage.mySnackbarMessage(context, "لطفاً مقدار حقوق را وارد کنید", 1);
      return;
    }

    int? moneyValue = int.tryParse(controllerMoney.text);
    if (moneyValue == null) {
      MyMessage.mySnackbarMessage(
          context, "لطفاً مقدار حقوق را به درستی وارد کنید (عدد صحیح)", 1);
      return;
    }

    var jalaliStartDate = pickedDateStart!.formatter.yyyy +
        '-' +
        pickedDateStart!.formatter.mm +
        '-' +
        pickedDateStart!.formatter.dd +
        ' ' +
        '00:00';

    var jalaliEndDate = pickedDateEnd!.formatter.yyyy +
        '-' +
        pickedDateEnd!.formatter.mm +
        '-' +
        pickedDateEnd!.formatter.dd +
        ' ' +
        '00:00';

    var body = jsonEncode({
      "user": user_id_select,
      "start_date": jalaliStartDate,
      "end_date": jalaliEndDate,
      "money": moneyValue,
    });

    String infourl = Helper.url.toString() + 'gharardad/create_gharardad';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 201) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GharardadPage(),
          ));
      MyMessage.mySnackbarMessage(context, "قرارداد با موفقیت ثبت شد", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(
          context, "خطایی رخ داده: ${response.body}", 1);
    }
  }
}
