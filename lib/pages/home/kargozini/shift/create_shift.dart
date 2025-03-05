// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import 'package:persian_datetime_picker/persian_datetime_picker.dart';
// import 'package:persian_number_utility/persian_number_utility.dart';
// import '../../../../models/users/users_model.dart';
// import '../../../../static/helper_page.dart';

// class CreateShiftPage extends StatefulWidget {
//   const CreateShiftPage({super.key});

//   @override
//   _CreateShiftPageState createState() => _CreateShiftPageState();
// }

// class _CreateShiftPageState extends State<CreateShiftPage> {
//   bool isSoSelected = true;
//   bool isAsSelected = false;
//   bool isShSelected = false;
//   bool isOneSelected = true;
//   bool isTwoSelected = false;
//   bool isThreeSelected = false;
//   int shiftCount = 1;
//   String shiftType = "SO";
//   Jalali? pickedDate = Jalali.now();
//   TextEditingController unitController = TextEditingController();
//   List<String> userItems = [];
//   List? dataUser = [];
//   int? selectedUserId;

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   Future fetchUsers() async {
//     final response = await http.get(Uri.parse('${Helper.url}user/get_all_user'),
//         headers: {"Content-Type": "application/json"});
//     if (response.statusCode == 200) {
//       final List users = usersModelFromJson(response.body);
//       setState(() {
//         dataUser = users;
//         userItems =
//             users.map((user) => "${user.firstName} ${user.lastName}").toList();
//       });
//     } else {
//       showErrorMessage("خطایی رخ داده");
//     }
//   }

//   Future createShift() async {
//     final startDate = pickedDate!.formatter.yyyy +
//         '-' +
//         pickedDate!.formatter.mm +
//         '-' +
//         pickedDate!.formatter.dd;
//     final body = jsonEncode({
//       "user_id": selectedUserId,
//       "shift_type": shiftType,
//       "start_date": startDate,
//       "shift_count": shiftCount
//     });

//     final response = await http
//         .post(Uri.parse('${Helper.url}shift/post_shift'), body: body, headers: {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     }).timeout(const Duration(seconds: 10));

//     if (response.statusCode == 201) {
//       showErrorMessage("شیفت با موفقیت ثبت شد");
//     } else {
//       showErrorMessage("خطا: ${response.body}");
//     }
//   }

//   void showErrorMessage(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   Widget buildShiftSelection(String title, bool isSelected, Function() onTap) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//           child: Center(
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.black,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildShiftOption(String title, bool isSelected, Function() onTap) {
//     return buildShiftSelection(title, isSelected, onTap);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double myHeight = MediaQuery.of(context).size.height;
//     double myWidth = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildUserSelection(),
//           _buildShiftSelectionRow(),
//           _buildShiftCountRow(),
//           _buildDateSelection(),
//           const Spacer(),
//           GestureDetector(
//             onTap: createShift,
//             child: _buildConfirmButton(myWidth, myHeight),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserSelection() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("انتخاب کارمند : "),
//           TypeAheadField<String>(
//             itemBuilder: (context, String suggestion) {
//               return ListTile(title: Text(suggestion));
//             },
//             controller: unitController,
//             onSelected: (String? suggestion) {
//               unitController.text = suggestion!;
//               setState(() {
//                 selectedUserId = dataUser!
//                     .firstWhere((user) =>
//                         "${user.firstName} ${user.lastName}" == suggestion)
//                     .id;
//               });
//             },
//             suggestionsCallback: (String pattern) {
//               return userItems.where((x) => x.contains(pattern)).toList();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildShiftSelectionRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         children: [
//           buildShiftOption("صبح", isSoSelected, () {
//             setState(() {
//               isSoSelected = true;
//               isShSelected = false;
//               isAsSelected = false;
//               shiftType = "SO";
//             });
//           }),
//           buildShiftOption("عصر", isAsSelected, () {
//             setState(() {
//               isSoSelected = false;
//               isShSelected = false;
//               isAsSelected = true;
//               shiftType = "AS";
//             });
//           }),
//           buildShiftOption("شب", isShSelected, () {
//             setState(() {
//               isSoSelected = false;
//               isShSelected = true;
//               isAsSelected = false;
//               shiftType = "SH";
//             });
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildShiftCountRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         children: [
//           buildShiftOption(1.toString().toPersianDigit(), isOneSelected, () {
//             setState(() {
//               isOneSelected = true;
//               isTwoSelected = false;
//               isThreeSelected = false;
//               shiftCount = 1;
//             });
//           }),
//           buildShiftOption(2.toString().toPersianDigit(), isTwoSelected, () {
//             setState(() {
//               isOneSelected = false;
//               isTwoSelected = true;
//               isThreeSelected = false;
//               shiftCount = 2;
//             });
//           }),
//           buildShiftOption(3.toString().toPersianDigit(), isThreeSelected, () {
//             setState(() {
//               isOneSelected = false;
//               isTwoSelected = false;
//               isThreeSelected = true;
//               shiftCount = 3;
//             });
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateSelection() {
//     return GestureDetector(
//       onTap: () async {
//         final selectedDate = await showModalBottomSheet<Jalali>(
//           context: context,
//           builder: (context) {
//             Jalali? tempPickedDate;
//             return Container(
//               height: 250,
//               color: Colors.blue,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       CupertinoButton(
//                         child: const Text('لغو',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold)),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                       CupertinoButton(
//                         child: const Text('تایید',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold)),
//                         onPressed: () => Navigator.of(context)
//                             .pop(tempPickedDate ?? Jalali.now()),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 0, thickness: 1),
//                   Expanded(
//                     child: PCupertinoDatePicker(
//                       mode: PCupertinoDatePickerMode.date,
//                       onDateTimeChanged: (Jalali dateTime) {
//                         tempPickedDate = dateTime;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//         if (selectedDate != null) {
//           setState(() {
//             pickedDate = selectedDate;
//           });
//         }
//       },
//       child: Container(
//         height: 60,
//         decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(5.0)),
//         child: ListTile(
//           title: const Text("انتخاب تاریخ",
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           trailing: Text(
//             pickedDate!
//                 .toGregorian()
//                 .toDateTime()
//                 .toIso8601String()
//                 .toPersianDate(),
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//                 fontSize: 14.0),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildConfirmButton(double width, double height) {
//     return Container(
//       height: height * 0.06,
//       width: width,
//       decoration: BoxDecoration(
//           color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
//       child: const Center(
//         child: Text(
//           "تایید",
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
//         ),
//       ),
//     );
//   }
// }
