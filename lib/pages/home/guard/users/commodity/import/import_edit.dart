import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;
import '../../../../../../models/guard/car/car_model.dart';

class ImportEditPage extends StatefulWidget {
  var data;
  ImportEditPage({super.key, this.data});

  @override
  State<ImportEditPage> createState() => _ImportEditPageState();
}

class _ImportEditPageState extends State<ImportEditPage> {
  Jalali create_at = Jalali.now();
  String? select;
  String? name;
  String? car_plate;
  String? weight_commodity;
  String? count_commodity;
  String? commodity_description;
  String? seller_name;
  String? delivery_person;
  String? edit_description;
  String? car_phone;
  String? company_name;
  int? company_id;
  String? car_name;
  int? car_id;

  @override
  void initState() {
    super.initState();
    if (widget.data.createAt != null) {
      processDate(widget.data.createAt.toString());
    }
    if (widget.data.select != null) {
      select = widget.data.select;
      if (select == "M") {
        is_mavad = true;
        is_kala = false;
        select_kala = "M";
      } else {
        is_mavad = false;
        is_kala = true;
        select_kala = "K";
      }
    }
    if (widget.data.name != null) {
      name = widget.data.name;
      controllerName.text = widget.data.name;
    }
    if (widget.data.carPlate != null) {
      car_plate = widget.data.carPlate;
      // جدا کردن داده‌های پلاک و تنظیم در TextEditingController ها
      List<String> plateParts = splitCarPlate(car_plate ?? "");
      if (plateParts.isNotEmpty) {
        setState(() {
          plate_first = plateParts[0];
          plate_second = plateParts[1];
          plate_three = plateParts[2];
          plate_four = plateParts[3];

          controllerFirst.text = plate_four!;
          controllerSecond.text = plate_three!;
          controllerThree.text = plate_second!;
          controllerFour.text = plate_first!;
        });
      }
    }
    if (widget.data.weightCommodity != null) {
      weight_commodity = widget.data.weightCommodity;
      controllerWeight.text = widget.data.weightCommodity;
    }
    if (widget.data.countCommodity != null) {
      count_commodity = widget.data.countCommodity;
      controllerCount.text = widget.data.countCommodity;
    }
    if (widget.data.commodityDescription != null) {
      commodity_description = widget.data.commodityDescription;
      controllerDescription.text = widget.data.editDescription;
    }
    if (widget.data.sellerName != null) {
      seller_name = widget.data.sellerName;
      controllerSeller.text = widget.data.sellerName;
    }
    if (widget.data.deliveryPerson != null) {
      delivery_person = widget.data.deliveryPerson;
      controllerDelivery.text = widget.data.deliveryPerson;
    }
    if (widget.data.editDescription != null) {
      edit_description = widget.data.editDescription;
    }
    if (widget.data.carPhone != null) {
      car_phone = widget.data.carPhone;
      controllerPhoneNumber.text = widget.data.carPhone;
    }
    if (widget.data.company != null) {
      company_name = widget.data.company.name;
      company_id = widget.data.company.id;
      if (company_name == "مهتاب") {
        is_mahtab = true;
        is_sadaf = false;
      } else {
        is_mahtab = false;
        is_sadaf = true;
      }
    }
    if (widget.data.car != null) {
      car_name = widget.data.car.name;
      car_id = widget.data.car.id;
    }

    // مقدار پیش‌فرض برای carController
    carController = TextEditingController(
      text: widget.data.car != null ? widget.data.car.name : "",
    );

    // تنظیم مقدار پیش‌فرض برای car_id و car_select
    if (widget.data.car != null) {
      car_id_select = widget.data.car.id;
      car_select = widget.data.car.name;
    }

    // دریافت داده‌ها
    get_all_car();
  }

  List<String> splitCarPlate(String carPlate) {
    RegExp regExp = RegExp(r'(\d{2})(\D)(\d{3})(\d{2})');
    Match? match = regExp.firstMatch(carPlate);

    if (match != null) {
      return [
        match.group(1)!, // 58
        match.group(2)!, // ل
        match.group(3)!, // 586
        match.group(4)!, // 53
      ];
    } else {
      return [];
    }
  }

  void processDate(String? createAtString) {
    try {
      if (createAtString == null || createAtString.isEmpty) {
        return;
      }

      // جداسازی تاریخ و زمان
      List<String> dateTimeParts =
          createAtString.split(' '); // قطعاً مقدار non-null است
      String datePart = dateTimeParts[0]; // قسمت تاریخ
      String? timePart = dateTimeParts.length > 1
          ? dateTimeParts[1]
          : null; // قسمت زمان (در صورت وجود)

      // جداسازی اجزای تاریخ
      List<String> dateComponents = datePart.split('-');
      int year = int.parse(dateComponents[0]);
      int month = int.parse(dateComponents[1]);
      int day = int.parse(dateComponents[2]);

      // ساخت شیء Jalali
      Jalali createAtJalali = Jalali(year, month, day);

      // فرمت‌دهی برای نمایش
      formattedDate =
          "${createAtJalali.year}/${createAtJalali.month.toString().padLeft(2, '0')}/${createAtJalali.day.toString().padLeft(2, '0')}";
    } catch (e) {}
  }

  String? formattedDate;
  bool? is_sadaf = false;
  bool? is_mahtab = true;
  bool? is_mavad = false;
  bool? is_kala = true;
  int? company_select = 1;
  String? select_kala = "M";
  String? car_plate_select;
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: ListView(
          children: [
            Text(
                "تاریخ ارسال درخواست : ${formattedDate.toString().toPersianDigit()}"),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is_mahtab = true;
                      is_sadaf = false;
                      company_select = 1;
                    });
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width * 0.42,
                    decoration: BoxDecoration(
                      color: is_mahtab!
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        "مهتاب",
                        style: TextStyle(
                            fontWeight: is_mahtab!
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 18.0,
                            color: is_mahtab! ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is_mahtab = false;
                      is_sadaf = true;
                      company_select = 2;
                    });
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width * 0.42,
                    decoration: BoxDecoration(
                      color: is_sadaf!
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        "صدف",
                        style: TextStyle(
                            fontWeight:
                                is_sadaf! ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18.0,
                            color: is_sadaf! ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is_kala = false;
                      is_mavad = true;
                      select_kala = "M";
                    });
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width * 0.42,
                    decoration: BoxDecoration(
                      color:
                          is_kala! ? Colors.blue : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        "مواد اولیه",
                        style: TextStyle(
                            fontWeight:
                                is_kala! ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18.0,
                            color: is_kala! ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      is_kala = true;
                      is_mavad = false;
                      select_kala = "K";
                    });
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width * 0.42,
                    decoration: BoxDecoration(
                      color: is_mavad!
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        "کالا",
                        style: TextStyle(
                            fontWeight:
                                is_mavad! ? FontWeight.bold : FontWeight.normal,
                            fontSize: 18.0,
                            color: is_mavad! ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text("نوع خودرو : "),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(),
                    ),
                    child: TypeAheadField<String>(
                      itemBuilder: (context, String suggestion) {
                        return ListTile(title: Text(suggestion));
                      },
                      controller: carController,
                      onSelected: (String? suggestion) {
                        carController.text = suggestion!;
                        for (var i = 0; i < data_car!.length; i++) {
                          if (data_car![i].name == suggestion) {
                            setState(() {
                              car_id_select = data_car![i].id;
                              car_select = data_car![i].name;
                            });
                          }
                        }
                        print(car_id_select);
                      },
                      suggestionsCallback: (String pattern) async {
                        return car_items!
                            .where((x) => x.contains(pattern))
                            .toList();
                      },
                    ),
                  ),
                ],
              ),
            ),
            my_form(controllerName, name, "نام کالا", false, Icons.description,
                TextInputType.text, 1),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("پلاک خودرو"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            Row(
              children: [
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: TextFormField(
                        controller: controllerFirst,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        cursorColor: Colors.blue,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "چهارم",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )),
                Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: TextFormField(
                        controller: controllerSecond,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        cursorColor: Colors.blue,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "سوم",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: TextFormField(
                        controller: controllerThree,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        cursorColor: Colors.blue,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "دوم",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )),
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: TextFormField(
                        controller: controllerFour,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        cursorColor: Colors.blue,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "اول",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )),
              ],
            ),
            is_kala!
                ? my_form(controllerCount, count, "تعداد کالا", false,
                    Icons.height, TextInputType.number, 1)
                : my_form(controllerWeight, weight, "وزن بار", false,
                    Icons.height, TextInputType.number, 1),
            my_form(controllerSeller, seller, "نام فروشنده", false,
                Icons.person, TextInputType.text, 1),
            my_form(controllerDelivery, delivery, "تحویل دهنده", false,
                Icons.person, TextInputType.text, 1),
            my_form(controllerPhoneNumber, phoneNumber, "شماره موبایل", false,
                Icons.call, TextInputType.number, 1),
            my_form(controllerDescription, description, "توضیحات", false,
                Icons.description, TextInputType.text, 3),
            const Divider(),
            GestureDetector(
              onTap: () {
                setState(() {
                  car_plate_select = controllerFour.text +
                      controllerThree.text +
                      controllerSecond.text +
                      controllerFirst.text;
                });
                // create_importcommodity();
              },
              child: Container(
                height: my_height * 0.06,
                width: my_width,
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
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  TextEditingController controllerName = TextEditingController();
  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
  String? weight = "";
  TextEditingController controllerWeight = TextEditingController();
  String? count = "";
  TextEditingController controllerCount = TextEditingController();
  String? seller = "";
  TextEditingController controllerSeller = TextEditingController();
  String? delivery = "";
  TextEditingController controllerDelivery = TextEditingController();
  String? phoneNumber = "";
  TextEditingController controllerPhoneNumber = TextEditingController();

  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
    int? maxLine,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        maxLines: maxLine,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
        ),
      ),
    );
  }

  String? plate_first = "";
  TextEditingController controllerFirst = TextEditingController();
  String? plate_second = "";
  TextEditingController controllerSecond = TextEditingController();
  String? plate_three = "";
  TextEditingController controllerThree = TextEditingController();
  String? plate_four = "";
  TextEditingController controllerFour = TextEditingController();
  Widget myFormPlate(
    TextEditingController controller,
    String label,
    bool isObscure,
    TextInputType inputType,
    FocusNode currentFocus,
    FocusNode? nextFocus,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: inputType,
        obscureText: isObscure,
        cursorColor: Colors.blue,
        onChanged: (value) {
          if (value.length == 2 && nextFocus != null) {
            currentFocus.unfocus();
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  List<String>? car_items = [];
  List? data_car = [];
  String? car_select = "";
  int? car_id_select;
  TextEditingController carController = TextEditingController();
  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_all_car() async {
    String infourl = Helper.url.toString() + 'guard/get_all_car';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = carModelFromJson(x);

      setState(() {
        data_car = recive_data;
        is_get_data = true;
        car_items = data_car!.map((e) => e.name as String).toList();
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
