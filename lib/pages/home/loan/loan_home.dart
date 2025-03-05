import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanHomePage extends StatefulWidget {
  const LoanHomePage({super.key});

  @override
  State<LoanHomePage> createState() => _LoanFirstPageState();
}

class _LoanFirstPageState extends State<LoanHomePage> {
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
    get_user_data();
    super.initState();
  }

  bool? is_za = true;
  bool? is_ma = false;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  show_filter(
                    "ضروری",
                    is_za,
                    () {
                      setState(() {
                        is_za = true;
                        is_ma = false;
                        loan_select = "ZA";
                      });
                    },
                  ),
                  show_filter(
                    "معمولی",
                    is_ma,
                    () {
                      setState(() {
                        is_za = false;
                        is_ma = true;
                        loan_select = "MA";
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              text_form("مبلغ وام", Icons.attach_money_outlined, controllerLoan,
                  loan, false, 1, TextInputType.number),
              controllerLoan.text == ""
                  ? const SizedBox()
                  : Row(
                      children: [
                        Text(
                            '${controllerLoan.text.toString().toPersianDigit().seRagham()} ریال'),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("-------"),
                        ),
                        Text(
                          '${controllerLoan.text.toString().beToman().toPersianDigit().seRagham()} تومان',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
              controllerLoan.text == ""
                  ? const SizedBox()
                  : Text('${controllerLoan.text.toString().toWord()} ریال'),
              text_form("توضیحات", Icons.description, controllerDescription,
                  description, false, 3, TextInputType.name),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  create_loan();
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: const Center(
                    child: Text("تایید",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? loan = "";
  TextEditingController controllerLoan = TextEditingController();
  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
  Widget text_form(
    String lable,
    IconData icon,
    TextEditingController controller,
    String? save,
    bool is_show,
    int? maxline,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        onSaved: (value) => save = value,
        onChanged: (value) {
          setState(() {
            loan = value;
          });
        },
        obscureText: is_show,
        cursorColor: Colors.blue,
        maxLines: maxline,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
          iconColor: Colors.grey,
        ),
      ),
    );
  }

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: my_width * 0.4,
        height: my_height * 0.05,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
                color: is_select ? Colors.white : Colors.black,
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  String? loan_select = "ZA";
  Future create_loan() async {
    var body = jsonEncode({
      "user": id_user,
      "loan_select": loan_select,
      "money_request": controllerLoan.text,
      "is_box": false,
      "box_money": "",
      "is_loan_za": false,
      "loan_za_money": "",
      "is_loan_ma": false,
      "loan_ma_money": "",
      "is_kargozini": false,
      "is_manager": false,
      "is_read": false,
      "kargozini_date": null,
      "manager_date": null,
      "description": controllerDescription.text
    });
    print(body);
    String infourl = Helper.url.toString() + 'loan/create_loan';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 201) {
      setState(() {
        controllerDescription.clear();
        controllerLoan.clear();
      });

      MyMessage.mySnackbarMessage(context, "وام با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
