import 'package:ed/components/count_widget.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: ListView(
            children: [
              Container(
                height: my_height * 0.15,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.only(bottom: 30.0),
                decoration: BoxDecoration(
                    // color: Colors.amber,
                    image: const DecorationImage(
                        scale: 1.5,
                        image: AssetImage("assets/image/sara_team.png")),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                    shape: BoxShape.circle),
              ),
              const AboutUsText(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      // color: Colors.amber,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("تماس با ما :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          _makePhoneCall(09185978639.toString());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "سارا حقیری : ${09185978639.toString().toPersianDigit()}"),
                            const Icon(Icons.phone_enabled_rounded,
                                size: 15.0, color: Colors.blue)
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          _makePhoneCall(09183739816.toString());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "هیمن دل بینا : ${09183739816.toString().toPersianDigit()}"),
                            const Icon(Icons.phone_enabled_rounded,
                                size: 15.0, color: Colors.blue)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneUri';
  }
}

class AboutUsText extends StatelessWidget {
  const AboutUsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      text: const TextSpan(
        style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            // height: 1.5,
            fontFamily: "Vazir"),
        children: [
          TextSpan(
            text: "سارا تیم ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                "با هدف ارائه راهکارهای نوین در دنیای فناوری و اطلاعات تأسیس شده است.\n"
                "ما با تکیه بر دانش و تجربه‌ی متخصصان خود، خدمات متنوعی در حوزه‌های:\n",
          ),
          TextSpan(
            text: "- طراحی و توسعه وب‌سایت‌ها و اپلیکیشن‌های موبایل\n"
                "- پیاده‌سازی راهکارهای هوش مصنوعی برای بهبود عملکرد کسب‌وکار\n"
                "- طراحی سیستم‌های بک‌اند (سرور، دیتابیس) و فرانت‌اند (رابط کاربری)\n"
                "- مشاوره و پیاده‌سازی شبکه‌های کامپیوتری و فناوری اطلاعات\n\n",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "ما در ",
          ),
          TextSpan(
            text: "سارا تیم ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                "تلاش می‌کنیم تا با استفاده از جدیدترین تکنولوژی‌های روز دنیا، "
                "پروژه‌هایی نوآورانه و کارآمد را برای کسب‌وکارها و استارتاپ‌ها توسعه دهیم.\n"
                "هدف ما ایجاد راهکارهای دیجیتالی هوشمند، مقیاس‌پذیر و کاربرپسند است که "
                "نیازهای مشتریان را به بهترین شکل ممکن برآورده کند.\n\n",
          ),
          TextSpan(
            text:
                "با سارا تیم، فناوری را به خدمت بگیرید و کسب‌وکار خود را به سطحی جدید ارتقا دهید.\n\n",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          TextSpan(
            text: "ما آماده‌ایم تا ایده‌های شما را به واقعیت تبدیل کنیم!",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
