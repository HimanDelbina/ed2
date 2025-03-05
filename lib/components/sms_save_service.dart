import 'dart:convert';

import '../models/message/sms_save_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../static/helper_page.dart';

class SmsService {
  static Future<List<SmsDefaultModel>> getSmsSave(BuildContext context) async {
    String infourl = Helper.url.toString() + 'message/get_all_save_sms';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = smsDefaultModelFromJson(x);
      return recive_data;
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      return [];
    }
  }

  static Future<List<SmsDefaultModel>> editSmsDefault(
      BuildContext context, int smsID, String content) async {
    var body = jsonEncode({"content": content});
    String infourl = Helper.url.toString() + 'message/edit_default_sms/$smsID';

    var response = await http.patch(
      Uri.parse(infourl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: body, // ارسال داده‌ها به سرور
    );

    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
      // در اینجا ممکن است بخواهید داده‌ها را از سرور بگیرید یا لیست جدیدی را به روز کنید.
      return []; // به صورت موقت یک لیست خالی باز می‌گردانیم.
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      return []; // در صورت خطا لیست خالی باز می‌گردد.
    }
  }
}

