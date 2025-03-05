// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:persian_number_utility/persian_number_utility.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../models/message/message_count.dart';
// import '../../../../static/helper_page.dart';
// import '../../../user_manager/login_page.dart';
// import '../../mail_box/mail_box_page.dart';

// class AdminGuardNavigationAdmin extends StatefulWidget {
//   const AdminGuardNavigationAdmin({super.key});

//   @override
//   State<AdminGuardNavigationAdmin> createState() =>
//       _AdminGuardNavigationAdminState();
// }

// class _AdminGuardNavigationAdminState extends State<AdminGuardNavigationAdmin> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   static const List<Widget> _pages = <Widget>[
//     GuardCheckFirstpage(),
//     AdminHome(),
//     FishPage(),
//     SettingPage(),
//   ];
//   int is_exit = 0;

//   bool? is_save = false;
//   void set_data() async {
//     final SharedPreferences prefsUser = await SharedPreferences.getInstance();
//     setState(() {
//       prefsUser.setBool('is_save', false);
//     });
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginPage(),
//         ));
//   }

//   int? id_user = 0;
//   int? id_unit = 0;

//   void get_user_data() async {
//     final SharedPreferences prefsUser = await SharedPreferences.getInstance();
//     setState(() {
//       id_user = prefsUser.getInt("id") ?? 0;
//       id_unit = prefsUser.getInt("unit_id") ?? 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double my_height = MediaQuery.of(context).size.height;
//     double my_width = MediaQuery.of(context).size.width;
//     return WillPopScope(
//       onWillPop: () async {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           is_exit = 0;
//         });
//         is_exit++;
//         if (is_exit == 2) {
//           exit(1);
//         } else {
//           MyMessage.mySnackbarMessage(
//               context, "برای خروج لطفا 2 بار ضربه برنید", 1);
//         }
//         return false;
//       },
//       child: Scaffold(
//         drawer: Drawer(
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
//             child: Column(
//               children: [
//                 Container(
//                   width: my_width,
//                   // color: Colors.amber,
//                   child: const DrawerHeader(
//                     child: Text("data"),
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     set_data();
//                   },
//                   child: Container(
//                     height: my_height * 0.06,
//                     width: my_width,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     padding:
//                         const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("خروج از حساب"),
//                         Icon(Icons.exit_to_app),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(left: 15.0),
//               child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const MailBoxPage()));
//                   },
//                   child: Stack(
//                     children: [
//                       const Icon(IconlyLight.message),
//                       count_all != 0
//                           ? Container(
//                               height: my_height * 0.015,
//                               width: my_width * 0.03,
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(50.0),
//                               ),
//                               child: Center(
//                                 child: is_get_data!
//                                     ? Text(
//                                         count_all.toString().toPersianDigit(),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 10.0,
//                                             color: Colors.white),
//                                       )
//                                     : const SizedBox(),
//                               ),
//                             )
//                           : const SizedBox()
//                     ],
//                   )),
//             ),
//           ],
//         ),
//         bottomNavigationBar: FlashyTabBar(
//           items: [
//             FlashyTabBarItem(
//                 icon: const Icon(Icons.linear_scale_outlined),
//                 title: const Text("دسترسی ها")),
//             FlashyTabBarItem(
//                 icon: const Icon(IconlyLight.home), title: const Text("خانه")),
//             FlashyTabBarItem(
//                 icon: const Icon(IconlyLight.paper),
//                 title: const Text("فیش حقوقی")),
//             FlashyTabBarItem(
//                 icon: const Icon(IconlyLight.setting),
//                 title: const Text("تنظیمات")),
//           ],
//           animationCurve: Curves.linear,
//           selectedIndex: _selectedIndex,
//           iconSize: 26,
//           showElevation: false,
//           onItemSelected: (index) => setState(() {
//             _selectedIndex = index;
//           }),
//         ),
//         body: SafeArea(
//           child: _pages.elementAt(_selectedIndex),
//         ),
//       ),
//     );
//   }

//   int? count_all = 0;
//   bool? is_get_data = false;
//   Future<void> get_count_message() async {
//     String infourl = Helper.url.toString() +
//         'message/get_count_message/' +
//         id_user.toString();
//     var response = await http.get(Uri.parse(infourl), headers: {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     });
//     if (response.statusCode == 200) {
//       var x = response.body;
//       CountMessageModel recive_data =
//           CountMessageModel.fromJson(json.decode(x));
//       setState(() {
//         count_all = recive_data.count;
//         is_get_data = true;
//       });
//     } else if (response.statusCode == 204) {
//       MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
//     } else {
//       MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
//     }
//   }
// }
