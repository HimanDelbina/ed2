import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


class CarPlateDisplay extends StatelessWidget {
  final String carPlate;

  CarPlateDisplay({required this.carPlate});

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

  @override
  Widget build(BuildContext context) {
    List<String> parts = splitCarPlate(carPlate);

    return Row(
      children: [
        Text("پلاک خودرو : "),
        Text(parts[3].toString().toPersianDigit()),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text("-"),
        ),
        Text(parts[2].toString().toPersianDigit()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(parts[1].toString().toPersianDigit()),
        ),
        Text(parts[0].toString().toPersianDigit()),
      ],
    );
  }
}