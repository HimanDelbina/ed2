import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/message/sms_save_model.dart';
import '../static/helper_page.dart';

class DefaultSmsService {
  static Future<void> deleteUserById(BuildContext context, int smsID) async {
    String infourl = Helper.url.toString() +
        'message/delete_smsDefault_by_id/' +
        smsID.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "کارمند با موفقیت حذف شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

}
