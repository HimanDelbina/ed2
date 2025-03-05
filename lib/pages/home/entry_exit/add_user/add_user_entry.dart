import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;
import '../../../../models/serial_number/serial_number_model.dart';
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';

class AddUserEntry extends StatefulWidget {
  const AddUserEntry({super.key});

  @override
  State<AddUserEntry> createState() => _AddUserEntryState();
}

class _AddUserEntryState extends State<AddUserEntry> {
  bool isUser = true, isAdmin = false, isFace = false, isCart = true;
  String selectType = "CA";
  List<String> userItems = [];
  List? dataUser, serialData;
  int? userIdSelect, serialSelect;
  TextEditingController unitController = TextEditingController();
  List<bool> selectedSerial = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    serialSelect = 1;
  }

  Future fetchData() async {
    await Future.wait([getAllUsers(), getAllSerials()]);
  }

  Future getAllUsers() async {
    final response =
        await http.get(Uri.parse("${Helper.url}user/get_all_user"));
    if (response.statusCode == 200) {
      final reciveData = usersModelFromJson(response.body);
      setState(() {
        dataUser = reciveData;
        userItems = reciveData
            .map((user) => "${user.firstName} ${user.lastName}")
            .toList();
      });
    }
  }

  Future getAllSerials() async {
    final response =
        await http.get(Uri.parse("${Helper.url}entry_exit/get_all_serial"));
    if (response.statusCode == 200) {
      final reciveData = serialNumberModelFromJson(response.body);
      setState(() {
        serialData = reciveData;
        selectedSerial = List.generate(reciveData.length, (_) => false);
        if (selectedSerial.isNotEmpty) selectedSerial[0] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "برای اضافه کردن کاربر به دستگاه ورود و خروج، اطلاعات شخصی وارد می‌شود...",
                textAlign: TextAlign.justify,
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildTypeAheadField(),
                    _buildSerialList(),
                    _buildSelectionRow("نحوه شناسایی", [
                      _buildSelectableButton("کارت", isCart, () {
                        setState(() {
                          isCart = true;
                          isFace = false;
                          selectType = "CA";
                        });
                      }),
                      _buildSelectableButton("چهره", isFace, () {
                        // setState(() {
                        //   isCart = false;
                        //   isFace = true;
                        //   selectType = "CH";
                        // });
                      }),
                    ]),
                    _buildSelectionRow("سطح دسترسی", [
                      _buildSelectableButton("کاربر", isUser, () {
                        setState(() {
                          isUser = true;
                          isAdmin = false;
                        });
                      }),
                      _buildSelectableButton("مدیر", isAdmin, () {
                        setState(() {
                          isUser = false;
                          isAdmin = true;
                        });
                      }),
                    ]),
                  ],
                ),
              ),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeAheadField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("انتخاب کارمند :"),
          TypeAheadField<String>(
            itemBuilder: (context, suggestion) =>
                ListTile(title: Text(suggestion)),
            controller: unitController,
            onSelected: (suggestion) {
              setState(() {
                unitController.text = suggestion;
                final user = dataUser?.firstWhere((user) =>
                    "${user.firstName} ${user.lastName}" == suggestion);
                userIdSelect = user?.id;
              });
            },
            suggestionsCallback: (pattern) =>
                userItems.where((item) => item.contains(pattern)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSerialList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: serialData?.length ?? 0,
        itemBuilder: (context, index) {
          final isSelected = selectedSerial[index];
          return GestureDetector(
            onTap: () => setState(() {
              selectedSerial[index] = !isSelected;
              serialSelect = serialData![index].id;
            }),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${(index + 1).toString().toPersianDigit()} : ${serialData![index].name}",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  Icon(Icons.circle,
                      size: 10.0,
                      color: isSelected ? Colors.white : Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionRow(String title, List<Widget> buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child:
                Row(children: [Text(title), const Expanded(child: Divider())]),
          ),
          Row(children: buttons),
        ],
      ),
    );
  }

  Widget _buildSelectableButton(
      String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: () {
        create_anbar();
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: const Center(
          child: Text(
            "تایید",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Future create_anbar() async {
    var body = jsonEncode({
      "serial": serialSelect,
      "user": userIdSelect,
      "entry_type": selectType,
      "id_admin": isUser ? false : true,
    });
    String infourl = Helper.url.toString() + 'entry_exit/create_user_cart';
    try {
      var response = await http.post(
        Uri.parse(infourl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      print(body);
      if (response.statusCode == 201) {
        MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
      } else {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
