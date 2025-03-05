
import 'package:flutter/material.dart';

import '../../static/helper_page.dart';

class DeactiveUserPage extends StatefulWidget {
  const DeactiveUserPage({super.key});

  @override
  State<DeactiveUserPage> createState() => _DeactiveUserPageState();
}

class _DeactiveUserPageState extends State<DeactiveUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Center(
                child: Image.asset("assets/image/locked.png", height: 100.0)),
            const Text("کاربری شما غیر فعال شده لطفا به کارگزینی مراجعه کنید"),
          ],
        ),
      )),
    );
  }
}
