import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';
import 'report_shift_user_select.dart';

class ReportShiftUser extends StatefulWidget {
  const ReportShiftUser({super.key});

  @override
  _ReportShiftUserState createState() => _ReportShiftUserState();
}

class _ReportShiftUserState extends State<ReportShiftUser> {
  List? data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    final response =
        await http.get(Uri.parse('${Helper.url}user/get_all_user'), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      setState(() {
        data = usersModelFromJson(response.body);
        isLoading = false;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: isLoading
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : ListView.builder(
              itemCount: data?.length ?? 0,
              itemBuilder: (context, index) {
                final user = data![index];
                return _UserTile(user: user);
              },
            ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportShiftUserSelect(user_id: user.id),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Icon(IconlyBold.profile, color: Colors.grey),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${user.firstName} ${user.lastName}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(user.unit.name,
                          style: const TextStyle(color: Colors.blue)),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  user.isActive ? "فعال" : "غیر فعال",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
