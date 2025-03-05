import 'package:flutter/material.dart';
import 'package:ed/static/helper_page.dart';

class ServicePlanPage extends StatefulWidget {
  const ServicePlanPage({super.key});

  @override
  State<ServicePlanPage> createState() => _ServicePlanPageState();
}

class _ServicePlanPageState extends State<ServicePlanPage> {
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Container(),
        ),
      ),
    );
  }
}
