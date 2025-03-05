import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/models/letter/all_type_letter_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;

import '../../../models/unit/unit_model.dart';

class LetterCreatePage extends StatefulWidget {
  const LetterCreatePage({super.key});

  @override
  State<LetterCreatePage> createState() => _LetterCreatePageState();
}

class _LetterCreatePageState extends State<LetterCreatePage> {
  int? id_user = 0;
  int? id_unit = 0;
  String? first_name;
  String? last_name;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
      first_name = prefsUser.getString("first_name") ?? "";
      last_name = prefsUser.getString("last_name") ?? "";
    });
    get_all_unit();
    get_all_letter();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    Jalali dateNow = Jalali.now();
    String formattedDate = FormateDateJaliliNow.formatDate(dateNow);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("انتخاب واحد : "),
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
                      for (var i = 0; i < data_unit!.length; i++) {
                        if (data_unit![i].name == suggestion) {
                          setState(() {
                            unit_id_select = data_unit![i].id;
                            unit_select = data_unit![i].name;
                          });
                        }
                      }
                    },
                    suggestionsCallback: (String pattern) async {
                      return unit_items!
                          .where((x) => x.contains(pattern))
                          .toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("انتخاب موضوع نامه : "),
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
                    controller: letterController,
                    onSelected: (String? suggestion) {
                      letterController.text = suggestion!;
                      Text(suggestion);
                      for (var i = 0; i < data_letter!.length; i++) {
                        if (data_letter![i].title == suggestion) {
                          setState(() {
                            letter_id_select = data_letter![i].id;
                            letter_select = data_letter![i].title;
                          });
                        }
                      }
                    },
                    suggestionsCallback: (String pattern) async {
                      return letter_items!
                          .where((x) => x.contains(pattern))
                          .toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.blue),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("بسمه تعالی"),
              Text(formattedDate.toPersianDigit()),
            ],
          ),
          const Divider(),
          Text(
            "مدیریت محترم ${unit_select != null ? unit_select : "( لطفا مدیر رارانتخاب کنید )"}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Text(
            " موضوع نامه : ${letter_select != null ? letter_select : "( لطفا موضوع نامه رارانتخاب کنید )"}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          const Text("با سلام و احترام،"),
          const Text("بدین‌وسیله به استحضار می‌رساند:"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(controllerDescription.text),
          ),
          const Text(
              "خواهشمند است دستورات لازم را مبذول فرمایید. پیشاپیش از همکاری شما کمال تشکر و قدردانی را دارم."),
          const Text("با احترام،"),
          Text("${first_name} ${last_name}"),
          my_form(controllerDescription, description, "موضوع نامه", false,
              Icons.description, TextInputType.text, 10),
          const Divider(),
          GestureDetector(
            onTap: () {
              setState(() {
                formattedLetter = """
بسمه تعالی

تاریخ: ${formattedDate.toPersianDigit()}

مدیریت محترم ${unit_select}
موضوع نامه: ${letter_select}

با سلام و احترام،

بدین‌وسیله به استحضار می‌رساند:
${controllerDescription.text}

خواهشمند است دستورات لازم را مبذول فرمایید. پیشاپیش از همکاری شما کمال تشکر و قدردانی را دارم.

با احترام،
${first_name} ${last_name}
""";
              });
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
                  "ارسال نامه",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String? formattedLetter;
  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
    int? maxLine,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          setState(() {
            controllerDescription.text = value;
          });
        },
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        maxLines: maxLine,
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

  // int? select_type = 1;
  // String? select_shift = "SO";
  // Future create_letter() async {
  //   var jalaliStartDate = pickedDate!.formatter.yyyy +
  //       '-' +
  //       pickedDate!.formatter.mm +
  //       '-' +
  //       pickedDate!.formatter.dd;
  //   var body = jsonEncode({
  //     "user_id": user_id_select,
  //     "shift_type": select_shift,
  //     "start_date": jalaliStartDate,
  //     "shift_count": select_type
  //   });
  //   String infourl = Helper.url.toString() + 'shift/post_shift';
  //   var response = await http.post(Uri.parse(infourl), body: body, headers: {
  //     "Content-Type": "application/json",
  //     "Accept": "application/json",
  //   });
  //   print(body);
  //   if (response.statusCode == 201) {
  //     setState(() {
  //       // controllerDescription.clear();
  //     });

  //     MyMessage.mySnackbarMessage(context, "شیفت با موفقیت ثبت شد", 1);
  //   } else if (response.statusCode == 204) {
  //     MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
  //   } else {
  //     MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
  //   }
  // }

  int? unit_id_select;
  String? unit_select;
  TextEditingController unitController = TextEditingController();
  List<String>? unit_items = [];
  List? data_unit = [];
  bool is_data = false;
  int data_count = 0;
  List? data_date_now = [];
  Future get_all_unit() async {
    String infourl = Helper.url.toString() + 'user/get_all_unit';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      data_date_now = unitModelFromJson(x);
      setState(() {
        data_unit = data_date_now;
        is_data = true;
        data_count = data_unit!.length;
        unit_items!.clear();
      });
      for (var i = 0; i < data_unit!.length; i++) {
        setState(() {
          unit_items!.add(data_unit![i].name);
        });
      }
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? letter_id_select;
  String? letter_select;
  TextEditingController letterController = TextEditingController();
  List<String>? letter_items = [];
  List? data_letter = [];
  bool is_data_letter = false;
  int data_count_letter = 0;
  List? data_date_now_letter = [];
  Future get_all_letter() async {
    String infourl = Helper.url.toString() + 'letter/get_all_letterType';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      data_date_now_letter = allTypeLetterModelFromJson(x);
      setState(() {
        data_letter = data_date_now_letter;
        is_data_letter = true;
        data_count_letter = data_letter!.length;
        letter_items!.clear();
      });
      for (var i = 0; i < data_letter!.length; i++) {
        setState(() {
          letter_items!.add(data_letter![i].title);
        });
      }
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
