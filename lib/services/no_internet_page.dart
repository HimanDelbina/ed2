
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../static/helper_page.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: PagePadding.page_padding,
        child: Container(
          width: my_width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Lottie.asset("assets/lottie/404-1.json"),
              const Text(
                "لطفا اتصال اینترنت خود را بررسی کنید",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
