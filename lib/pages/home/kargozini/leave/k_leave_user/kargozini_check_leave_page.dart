import 'package:ed/models/users/users_model.dart';
import 'package:ed/pages/home/kargozini/leave/k_leave_user/k_leave_user_firstpage.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

class KargoziniCheckLeavePage extends StatefulWidget {
  const KargoziniCheckLeavePage({super.key});

  @override
  State<KargoziniCheckLeavePage> createState() =>
      _KargoziniCheckLeavePageState();
}

class _KargoziniCheckLeavePageState extends State<KargoziniCheckLeavePage> {
  @override
  void initState() {
    get_all_users();
    super.initState();
  }

  int? companyID;

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();

  bool isAll = true;
  bool isMahtab = false;
  bool isSadaf = false;
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
              Container(
                width: my_width,
                child: TextFormField(
                  controller: user_search_controller,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        data = SearcUser.search(
                            show_data_Search, value, "firstName");
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAll = true;
                        isMahtab = false;
                        isSadaf = false;
                      });
                      get_all_users();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin: const EdgeInsets.only(left: 15.0),
                      decoration: BoxDecoration(
                        color:
                            isAll ? Colors.blue : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      child: Text(
                        "همه",
                        style: TextStyle(
                            color: isAll ? Colors.white : Colors.black,
                            fontWeight:
                                isAll ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAll = false;
                        isMahtab = true;
                        isSadaf = false;
                        companyID = 1;
                      });
                      get_all_users();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin: const EdgeInsets.only(left: 15.0),
                      decoration: BoxDecoration(
                        color: isMahtab
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      child: Text(
                        "مهتاب",
                        style: TextStyle(
                            color: isMahtab ? Colors.white : Colors.black,
                            fontWeight:
                                isMahtab ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isAll = false;
                        isMahtab = false;
                        isSadaf = true;
                        companyID = 2;
                      });
                      get_all_users();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin: const EdgeInsets.only(left: 15.0),
                      decoration: BoxDecoration(
                        color: isSadaf
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      child: Text(
                        "صدف",
                        style: TextStyle(
                            color: isSadaf ? Colors.white : Colors.black,
                            fontWeight:
                                isSadaf ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                  child: is_get_data!
                      ? ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            user_search_controller.text == ""
                                ? data = data_show
                                : data = data;
                            show_data_Search = data_show!;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KargoziniLeaveUserFirstpage(
                                          user_id: data![index].id,
                                        ),
                                      ));
                                },
                                child: Container(
                                  width: my_width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data![index].firstName} ${data![index].lastName}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            data![index].unit.name,
                                            style: const TextStyle(
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                                "( ${data![index].company.name} )"),
                                          ),
                                          Text(
                                            data![index].isActive
                                                ? "فعال"
                                                : "غیر فعال",
                                            style: TextStyle(
                                              color: data![index].isActive
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Lottie.asset("assets/lottie/loading.json",
                              height: 40.0))),
            ],
          ),
        ),
      ),
    );
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  String? infourl;
  Future get_all_users() async {
    isAll
        ? infourl = Helper.url.toString() + 'user/get_all_user/'
        : infourl = Helper.url.toString() +
            'user/get_all_user/?company_id=${companyID}';
    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      // var jsonResponse = json.decode(response.body);
      // MissionModel recive_data = MissionModel.fromJson(jsonResponse);
      var x = response.body;
      var recive_data = usersModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
