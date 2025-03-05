import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../models/voice/voice_get_all_data_model.dart';
import '../../../static/helper_page.dart';


class VoiceFirstPage extends StatefulWidget {
  const VoiceFirstPage({super.key});

  @override
  State<VoiceFirstPage> createState() => _VoiceFirstPageState();
}

class _VoiceFirstPageState extends State<VoiceFirstPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "برای شروع دکمه میکروفون را فشار دهید...";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // void _listen() async {
  //   if (!_isListening) {
  //     bool available = await _speech.initialize(
  //       onStatus: (val) {
  //         print('وضعیت: $val');
  //         if (val == 'notListening') {
  //           setState(() => _isListening = false);
  //           sendVoiceToServer();
  //         }
  //       },
  //       onError: (val) => print('خطا: $val'),
  //     );

  //     if (available) {
  //       setState(() => _isListening = true);
  //       _speech.listen(
  //         onResult: (val) {
  //           setState(() {
  //             _text = val.recognizedWords;
  //           });
  //           if (val.finalResult) {
  //             sendVoiceToServer();
  //           }
  //         },
  //         localeId: "fa_IR",
  //         listenMode: stt.ListenMode.dictation,
  //         partialResults: true,
  //       );
  //     }
  //   } else {
  //     setState(() => _isListening = false);
  //     _speech.stop();
  //   }
  // }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('وضعیت: $val'),
      onError: (val) => print('خطا: $val'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
          });
        },
        localeId: "fa_IR",
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
    sendVoiceToServer();
  }

  void _checkAvailableLanguages() async {
    bool available = await _speech.initialize();
    if (available) {
      var locales = await _speech.locales();
      for (var locale in locales) {
        print('Available locale: ${locale.localeId}, name: ${locale.name}');
      }
    } else {
      print('Speech recognition not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onLongPressStart: (details) {
          _startListening();
        },
        onLongPressEnd: (details) {
          _stopListening();
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _listen,
      //   child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      // ),
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            children: [
              const Text(
                  textAlign: TextAlign.justify,
                  "با قابلیت دستیار صوتی سامانه اداری ما، انجام کارهای روزانه‌تان سریع‌تر و آسان‌تر خواهد شد. تنها با گفتن دستورات صوتی، می‌توانید وظایف خود را مدیریت کنید، درخواست‌های خود را ثبت نمایید و به اطلاعات مهم دسترسی داشته باشید. از ثبت مرخصی تا بررسی گزارش‌ها – همه چیز تنها با صدای شما انجام می‌شود"),
              const Divider(),
              Expanded(
                child: Center(
                  child: Text(
                    _text,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  VoiceGetAllDataModel? data;
  List? data_show = [];
  bool? is_get_data = false;

  Future sendVoiceToServer() async {
    var body = jsonEncode({"text": _text});
    String infourl = Helper.url.toString() + 'voice/get_user_data';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    print(response.body); // بررسی پاسخ قبل از پردازش

    if (response.body.isNotEmpty) {
      try {
        // رمزگشایی داده‌ها با utf8
        print("Raw response body bytes: ${response.bodyBytes}");

        var decodedBody = utf8.decode(response.bodyBytes); // تبدیل به UTF-8
        var jsonResponse = jsonDecode(decodedBody); // تجزیه JSON
        print(jsonResponse);

        // var recive_data = voiceGetAllDataModelFromJson(jsonResponse);
        setState(() {
          data = jsonResponse;
          is_get_data = true;
        });
        MyMessage.mySnackbarMessage(context, "داده با موفقیت ارسال شد", 1);
      } catch (e) {
        print('خطا در رمزگشایی داده‌ها: $e');
        MyMessage.mySnackbarMessage(context, "خطا در دریافت داده‌ها", 1);
      }
    } else {
      print('Empty response from server');
      MyMessage.mySnackbarMessage(context, "پاسخ خالی از سرور", 1);
    }
  }
}
