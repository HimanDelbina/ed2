import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../../../../models/unit/unit_model.dart';
import '../../../../static/helper_page.dart';
import 'report_shift_unit_select.dart';

class ReportShiftUnit extends StatefulWidget {
  const ReportShiftUnit({super.key});

  @override
  _ReportShiftUnitState createState() => _ReportShiftUnitState();
}

class _ReportShiftUnitState extends State<ReportShiftUnit> {
  List? dataUnit = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUnits();
  }

  Future<void> _getUnits() async {
    final response =
        await http.get(Uri.parse('${Helper.url}user/get_all_unit'), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      setState(() {
        dataUnit = unitModelFromJson(response.body);
        isLoading = false;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: isLoading
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : ListView.builder(
              itemCount: dataUnit?.length ?? 0,
              itemBuilder: (context, index) {
                final unit = dataUnit![index];
                return _UnitTile(unit: unit);
              },
            ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  final unit;
  const _UnitTile({required this.unit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportShiftUnitSelect(unitId: unit.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(unit.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Icon(IconlyBold.activity, size: 20.0),
          ],
        ),
      ),
    );
  }
}
