
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../static/helper_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBiometric = false;
  Future<bool> authentificationWithBiometric() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final bool isBiometricSupported =
        await localAuthentication.isDeviceSupported();
    final bool canCheckBiometrics =
        await localAuthentication.canCheckBiometrics;

    bool isAuthentification = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthentification = await localAuthentication.authenticate(
          localizedReason: "Please finger Print");
    }
    return isAuthentification;
  }

  String? check = "NO";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                isBiometric = await authentificationWithBiometric();
                if (isBiometric) {
                  setState(() {
                    check = "YES";
                  });
                }
              },
              child: const Center(child: Icon(Icons.fingerprint, size: 150.0)),
            ),
            Text(check!)
          ],
        ),
      )),
    );
  }
}
