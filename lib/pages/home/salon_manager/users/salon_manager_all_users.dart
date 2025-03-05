import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;
import '../../../../models/users/users_model.dart';

class SalonManagerAllUsers extends StatefulWidget {
  const SalonManagerAllUsers({super.key});

  @override
  State<SalonManagerAllUsers> createState() => _SalonManagerAllUsersState();
}

class _SalonManagerAllUsersState extends State<SalonManagerAllUsers> {
  List data = [];
  List dataShow = [];
  bool isGetData = false;
  TextEditingController userSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  void searchUser(String value) {
    setState(() {
      data = value.isEmpty
          ? dataShow
          : dataShow
              .where((user) =>
                  user.firstName.contains(value) ||
                  user.lastName.contains(value) ||
                  user.companyCode.contains(value))
              .toList();
    });
  }

  Future getAllUsers() async {
    String url = '${Helper.url}user/get_all_user';
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var recivedData = usersModelFromJson(response.body);
      setState(() {
        data = recivedData;
        dataShow = recivedData;
        isGetData = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    double myWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: userSearchController,
              onChanged: searchUser,
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
            child: isGetData
                ? ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var user = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: myWidth,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${user.firstName} ${user.lastName}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      user.unit.name,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                                Text(
                                  user.isActive ? "فعال" : "غیر فعال",
                                  style: TextStyle(
                                    color: user.isActive
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
                        height: 40.0),
                  ),
          ),
        ],
      ),
    );
  }
}
