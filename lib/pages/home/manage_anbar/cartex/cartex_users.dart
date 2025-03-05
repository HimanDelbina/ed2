import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:ed/pages/home/manage_anbar/cartex/cartex_select_firstpage.dart';
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';
import 'cartex_select.dart';

class ManagerAnbarCartexUsers extends StatefulWidget {
  const ManagerAnbarCartexUsers({super.key});

  @override
  State<ManagerAnbarCartexUsers> createState() =>
      _ManagerAnbarCartexUsersState();
}

class _ManagerAnbarCartexUsersState extends State<ManagerAnbarCartexUsers> {
  @override
  void initState() {
    get_all_users();
    super.initState();
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
          Container(
            width: my_width,
            child: TextFormField(
              controller: user_search_controller,
              onChanged: (value) {
                setState(() {
                  setState(() {
                    data =
                        SearcUser.search(show_data_Search, value, "firstName");
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
              child: is_get_data!
                  ? ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        user_search_controller.text == ""
                            ? data = data_show
                            : data = data;
                        show_data_Search = data_show!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CartexSelectFirstPage(
                                      user_id: data![index].id,
                                    ),
                                  ));
                            },
                            child: Container(
                              width: my_width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(left: 15.0),
                                          child: Icon(IconlyBold.profile,
                                              size: 20.0, color: Colors.grey)),
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
                                    ],
                                  ),
                                  Text(
                                    data![index].isActive ? "فعال" : "غیر فعال",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: data![index].isActive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
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
    );
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  Future get_all_users() async {
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
        data_show = recive_data;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
