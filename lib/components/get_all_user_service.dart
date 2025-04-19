import 'package:ed/models/shift/shift_model.dart';
import 'package:ed/models/users/users_model.dart';

import '../models/users/user_gharardad_model.dart';
import 'package:http/http.dart' as http;

import '../static/helper_page.dart';

class UserService {
  Future<List<UserGharardadModel>?> getAllUsers(int unit) async {
    String infourl = Helper.url.toString() +
        'user/get_all_user_with_gharardad/?unit=${unit}';
    try {
      var response = await http.get(Uri.parse(infourl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var x = response.body;
        var reciveData = userGharardadModelFromJson(x);
        return reciveData;
      } else if (response.statusCode == 204) {
        throw Exception("No content available");
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ShiftModel>> getUserShiftByDate(String date) async {
    String infourl =
        Helper.url.toString() + 'shift/get_shift_by_date/?shift_date=${date}';
    try {
      var response = await http.get(Uri.parse(infourl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        var x = response.body;
        var recive_data = shiftModelFromJson(x);
        return recive_data;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
