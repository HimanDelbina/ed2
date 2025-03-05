import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final int value;
  final Color badgeColor;

  const BadgeWidget({
    Key? key,
    required this.child,
    required this.value,
    this.badgeColor = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (value > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(50),
            ),
            // constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
            child: Text(value.toString().toPersianDigit(),
                style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          )
      ],
    );
  }
}
