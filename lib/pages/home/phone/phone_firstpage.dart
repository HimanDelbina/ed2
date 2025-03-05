import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../models/phone/phone_get_model.dart';

class PhoneFirstPage extends StatefulWidget {
  const PhoneFirstPage({super.key});

  @override
  State<PhoneFirstPage> createState() => _PhoneFirstPageState();
}

class _PhoneFirstPageState extends State<PhoneFirstPage> {
  @override
  void initState() {
    get_all_phone();
    super.initState();
  }

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();
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
            const Text(
                textAlign: TextAlign.justify,
                "در این بخش، می‌توانید لیست شماره‌های داخلی شرکت را مشاهده کنید. برای تماس با هر بخش، کافی است روی شماره مورد نظر کلیک کنید و تماس خود را شروع کنید."),
            const Divider(),
            Container(
              width: my_width,
              child: TextFormField(
                controller: user_search_controller,
                onChanged: (value) {
                  setState(() {
                    setState(() {
                      data = SearcPhone.search(show_data_Search, value, "name");
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
              child: data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        user_search_controller.text == ""
                            ? data = data_show
                            : data = data;
                        show_data_Search = data_show!;
                        return GestureDetector(
                          onTap: () {
                            _makePhoneCall("03591009898");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        data![index].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text("( ${data![index].company.name} )",
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Text(
                                  data![index]
                                      .phone
                                      .toString()
                                      .toPersianDigit(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0)),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  List? data_show = [];
  List? data = [];
  bool? is_get_data = false;
  Future get_all_phone() async {
    String infourl = Helper.url.toString() + 'phone/get_all_phone';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = phoneModelFromJson(x);
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
