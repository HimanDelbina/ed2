import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ed/models/users/user_gharardad_model.dart';
import 'package:ed/static/helper_page.dart';
import '../../../components/get_all_user_service.dart';

class CreateShiftPage extends StatefulWidget {
  const CreateShiftPage({super.key});

  @override
  State<CreateShiftPage> createState() => _CreateShiftPageState();
}

class _CreateShiftPageState extends State<CreateShiftPage> {
  List<UserGharardadModel>? data = [];
  bool? isGetData = false;
  List<SelectedUser> selectedUsers = []; // لیست کاربران انتخاب شده
  final userService = UserService();

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    try {
      var users = await userService.getAllUsers();
      setState(() {
        data = users;
        isGetData = true;
      });
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Widget select_pathern(String title, bool select, VoidCallback ontab) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        margin: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: select ? Colors.blue : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.grey.withOpacity(0.5))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: select ? Colors.white : Colors.black,
                fontWeight: select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget select_shift(String title, bool select, VoidCallback ontab) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        margin: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
            color: select ? Colors.blue : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.grey.withOpacity(0.5))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: select ? Colors.white : Colors.black,
                fontWeight: select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  bool isAllSelected = false;

  void toggleSelectAll(bool value) {
    setState(() {
      isAllSelected = value;
      if (value) {
        selectedUsers = data!
            .where(
                (user) => user.contractStartDate != null) // فیلتر کردن کاربران
            .map((user) {
          return SelectedUser(
            userId: user.user!.id!,
            shiftsPatterns: shiftsPatterns,
            initialShift: initialShifts,
            startDate:
                FormateDateCreate.formatDate(user.contractStartDate.toString()),
            endDate:
                FormateDateCreate.formatDate(user.contractEndDate.toString()),
          );
        }).toList();
      } else {
        selectedUsers.clear();
      }
    });
  }

  bool is_sh = false;
  bool is_as = false;
  bool is_so = false;
  bool is_sh_shift = false;
  bool is_as_shift = false;
  bool is_so_shift = false;

  String initialShifts = "";
  List<String> shiftsPatterns = [];

  bool is_sh_select = false;
  bool is_as_select = false;
  bool is_so_select = false;
  @override
  Widget build(BuildContext context) {
    bool isAllSelected =
        selectedUsers.length == data!.length && data!.isNotEmpty;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("انتخاب شیفت"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            Row(
              children: [
                select_pathern(
                  "شب",
                  is_sh,
                  () {
                    setState(() {
                      is_sh = !is_sh;
                      if (is_sh) {
                        shiftsPatterns.add("SH");
                      } else {
                        shiftsPatterns.remove("SH");
                      }
                      print(shiftsPatterns);
                    });
                  },
                ),
                select_pathern(
                  "عصر",
                  is_as,
                  () {
                    setState(() {
                      is_as = !is_as;
                      if (is_as) {
                        shiftsPatterns.add("AS");
                      } else {
                        shiftsPatterns.remove("AS");
                      }
                      print(shiftsPatterns);
                    });
                  },
                ),
                select_pathern(
                  "صبح",
                  is_so,
                  () {
                    setState(() {
                      is_so = !is_so;
                      if (is_so) {
                        shiftsPatterns.add("SO");
                      } else {
                        shiftsPatterns.remove("SO");
                      }
                      print(shiftsPatterns);
                    });
                  },
                ),
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("شروع شیفت"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            Row(
              children: [
                select_shift(
                  "شب",
                  is_sh_shift,
                  () {
                    setState(() {
                      is_sh_shift = true;
                      is_as_shift = false;
                      is_so_shift = false;
                      initialShifts = "SH";
                    });
                  },
                ),
                select_shift(
                  "عصر",
                  is_as_shift,
                  () {
                    setState(() {
                      is_sh_shift = false;
                      is_as_shift = true;
                      is_so_shift = false;
                      initialShifts = "AS";
                    });
                  },
                ),
                select_shift(
                  "صبح",
                  is_so_shift,
                  () {
                    setState(() {
                      is_sh_shift = false;
                      is_as_shift = false;
                      is_so_shift = true;
                      initialShifts = "SO";
                    });
                  },
                ),
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("کاربران"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            Expanded(
              child: (is_sh | is_as | is_so) &
                      (is_sh_shift | is_as_shift | is_so_shift)
                  ? Column(
                      children: [
                        // دکمه انتخاب همه
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: isAllSelected
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: CheckboxListTile(
                            title: const Text("انتخاب همه"),
                            value: isAllSelected,
                            onChanged: (bool? value) {
                              toggleSelectAll(value ?? false);
                            },
                          ),
                        ),
                        const Divider(),
                        // لیست کاربران
                        Expanded(
                          child: ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              UserGharardadModel user = data![index];
                              bool isSelected = selectedUsers.any(
                                  (element) => element.userId == user.user!.id);

                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: CheckboxListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${user.user!.firstName} ${user.user!.lastName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      user.contractStartDate != null
                                          ? GestureDetector(
                                              onTap: () {
                                                // print(
                                                //     selectedUsers[0].userId);
                                                int? userIdToFind =
                                                    user.user!.id;

                                                // پیدا کردن کاربر بر اساس userId
                                                var users =
                                                    selectedUsers.firstWhere(
                                                  (users) =>
                                                      users.userId ==
                                                      userIdToFind,
                                                  orElse: () => SelectedUser(
                                                      userId: 0,
                                                      shiftsPatterns: [],
                                                      initialShift: "",
                                                      startDate: "",
                                                      endDate: ""),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    // duration: const Duration(
                                                    //     days: 365),
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            " ${users.userId} : ویرایش کاربر"),
                                                        const Divider(),
                                                        const Text(
                                                            "شیفت های انتخاب شده"),
                                                        Container(
                                                          height: 50.0,
                                                          width:
                                                              double.infinity,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection: Axis
                                                                .horizontal, // تنظیم اسکرول به صورت افقی
                                                            // shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount: users
                                                                .shiftsPatterns
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Center(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (users
                                                                              .shiftsPatterns[index]
                                                                              .toString() ==
                                                                          "SH") {
                                                                        is_sh_select =
                                                                            !is_sh_select;
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            15.0,
                                                                        vertical:
                                                                            5.0),
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10.0),
                                                                    child: Text(users
                                                                        .shiftsPatterns[
                                                                            index]
                                                                        .toString()),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    action: SnackBarAction(
                                                      label: 'تایید',
                                                      onPressed: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar();
                                                      },
                                                    ),
                                                  ),
                                                );

                                                // انجام عملیات ویرایش
                                                // مثلا نمایش صفحه ویرایش با اطلاعات این کاربر
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 5.0),
                                                  margin: const EdgeInsets.only(
                                                      left: 15.0),
                                                  child: const Text("ویرایش")),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  subtitle: Text(
                                    user.contractStartDate == null
                                        ? "کاربر قرارداد ندارد . حتما اول باید قراداد را تنظبم کرده بعد تعیین شیفت قابل انجام خواهد بود"
                                        : "شیفت را تعیین کنید",
                                    style: TextStyle(
                                        color: user.contractStartDate == null
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        if (user.contractStartDate != null) {
                                          // بررسی مقدار null
                                          selectedUsers.add(
                                            SelectedUser(
                                              userId: user.user!.id!,
                                              shiftsPatterns: shiftsPatterns,
                                              initialShift: initialShifts,
                                              startDate:
                                                  FormateDateCreate.formatDate(
                                                      user.contractStartDate
                                                          .toString()),
                                              endDate:
                                                  FormateDateCreate.formatDate(
                                                      user.contractEndDate
                                                          .toString()),
                                            ),
                                          );
                                        }
                                      } else {
                                        selectedUsers.removeWhere((element) =>
                                            element.userId == user.user!.id);
                                      }
                                      isAllSelected = selectedUsers.length ==
                                          data!
                                              .where((u) =>
                                                  u.contractStartDate != null)
                                              .length;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text("لطفا اول تنظیمات شیفت را انجام دهید")),
            ),
            GestureDetector(
              onTap: () {
                generateShift();
              },
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                margin: const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Center(
                  child: Text(
                    "تایید",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future generateShift() async {
    var body = jsonEncode({"data": selectedUsers});
    String infourl = Helper.url.toString() + 'shift/create_shift_schedule';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      _getAllUsers();
      MyMessage.mySnackbarMessage(context, "شیفت با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 400) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}

class SelectedUser {
  int userId;
  List<String> shiftsPatterns;
  String initialShift;
  String startDate;
  String endDate;

  SelectedUser({
    required this.userId,
    required this.shiftsPatterns,
    required this.initialShift,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "shifts_patterns": shiftsPatterns,
      "initial_shifts": initialShift,
      "start_dates": startDate,
      "end_dates": endDate,
    };
  }
}
