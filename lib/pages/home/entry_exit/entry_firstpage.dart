import 'package:flutter/material.dart';
import 'package:ed/pages/home/entry_exit/add_user/add_user_entry.dart';
import 'package:ed/static/helper_page.dart';

class EntryFirstPage extends StatefulWidget {
  const EntryFirstPage({super.key});

  @override
  State<EntryFirstPage> createState() => _EntryFirstPageState();
}

class _EntryFirstPageState extends State<EntryFirstPage> {
  List? data = [
    {"id": 1, "title": "اضافه کردن", "icon": "assets/image/add_user.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (data![index]['title'] == "اضافه کردن") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddUserEntry()));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(data![index]['icon'], height: 35.0),
                        Text(
                          data![index]['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
