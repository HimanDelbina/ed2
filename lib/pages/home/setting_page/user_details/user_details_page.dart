import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/components/count_widget.dart';
import 'package:ed/models/users/users_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;

class UserDetailsPage extends StatefulWidget {
  int? userID;
  UserDetailsPage({super.key, this.userID});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    get_user_data_all();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: PagePadding.page_padding,
              child: ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showData(
                          "نام و نام خانوادگی : ${data![index].firstName} ${data![index].lastName}"),
                      showData(
                          "شماره موبایل : ${data![index].phoneNumber.toString().toPersianDigit()}"),
                      showData(
                          "کد ملی : ${data![index].melliCode.toString().toPersianDigit()}"),
                      showData(
                          "کد بیمه : ${data![index].insuranceCode.toString().toPersianDigit()}"),
                      showData(
                          "کد پرسنلی شرکت : ${data![index].companyCode.toString().toPersianDigit()}"),
                      showData(
                          "رمز عبور : ${data![index].password.toString().toPersianDigit()}"),
                      showData(
                          "شرکت : ${data![index].company.name.toString().toPersianDigit()}"),
                      showData(
                          "واحد : ${data![index].unit.name.toString().toPersianDigit()}"),
                      showData(
                          "گروه : ${data![index].group.name.toString().toPersianDigit()}"),
                      const Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text("دسترسی های سامانه اداری")),
                          Expanded(child: Divider(color: Colors.blue))
                        ],
                      ),
                      ListView.builder(
                        itemCount: data![index].access.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, accessIndex) {
                          return Text(data![index].access[accessIndex].name);
                        },
                      )
                    ],
                  );
                },
              ))),
    );
  }

  Widget showData(String? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(data!),
    );
  }

  List? data = [];
  bool? is_get = false;
  Future get_user_data_all() async {
    String infourl =
        Helper.url.toString() + 'user/get_user_data_all/${widget.userID}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = usersModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
