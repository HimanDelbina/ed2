import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ed/static/helper_page.dart';
import 'package:path/path.dart';

class SalaryFirstPage extends StatefulWidget {
  const SalaryFirstPage({super.key});

  @override
  State<SalaryFirstPage> createState() => _SalaryFirstPageState();
}

class _SalaryFirstPageState extends State<SalaryFirstPage> {
  File? _selectedFile;
  Uint8List? _webFileBytes;
  String? _fileName;
  bool _isUploading = false;
  String _uploadStatus = '';
  bool _isWeb = kIsWeb;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _fileName = result.files.single.name;

          if (kIsWeb) {
            // Web platform - store bytes
            _webFileBytes = result.files.single.bytes;
            _uploadStatus = 'فایل "$_fileName" انتخاب شد';
          } else {
            // Mobile/Desktop platform - store file
            _selectedFile = File(result.files.single.path!);
            _uploadStatus = 'فایل "${basename(_selectedFile!.path)}" انتخاب شد';
          }
        });
        print("File selected: $_fileName");
      } else {
        print("No file selected");
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'خطا در انتخاب فایل: $e';
      });
      print("Error picking file: $e");
    }
  }

  Future<void> _uploadFile() async {
    if ((_selectedFile == null && _webFileBytes == null) || _fileName == null) {
      setState(() {
        _uploadStatus = 'لطفا ابتدا یک فایل انتخاب کنید';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadStatus = 'در حال آپلود فایل...';
    });

    try {
      String url = Helper.url.toString() + 'salary/import_salaryExcel';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (kIsWeb) {
        // Web platform - upload bytes
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            _webFileBytes!,
            filename: _fileName,
          ),
        );
      } else {
        // Mobile/Desktop platform - upload file
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            _selectedFile!.path,
            filename: basename(_selectedFile!.path),
          ),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        setState(() {
          _uploadStatus = 'فایل با موفقیت آپلود شد';
          _selectedFile = null;
          _webFileBytes = null;
          _fileName = null;
        });
      } else {
        setState(() {
          _uploadStatus = 'خطا در آپلود فایل: $responseData';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'خطا در ارسال فایل: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('آپلود فایل حقوق'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'لطفا فایل CSV حقوق را انتخاب کنید',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.file_upload),
              label: const Text('انتخاب فایل'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (_fileName != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'فایل انتخاب شده:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_fileName!),
                      if (!kIsWeb && _selectedFile != null)
                        Text(
                            '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB'),
                      if (kIsWeb && _webFileBytes != null)
                        Text(
                            '${(_webFileBytes!.length / 1024).toStringAsFixed(2)} KB'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadFile,
                child: _isUploading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('در حال آپلود...'),
                        ],
                      )
                    : const Text('آپلود فایل'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (_uploadStatus.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _uploadStatus.contains('موفقیت')
                      ? Colors.green.withOpacity(0.1)
                      : _uploadStatus.contains('خطا')
                          ? Colors.red.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _uploadStatus.contains('موفقیت')
                        ? Colors.green
                        : _uploadStatus.contains('خطا')
                            ? Colors.red
                            : Colors.blue,
                  ),
                ),
                child: Text(
                  _uploadStatus,
                  style: TextStyle(
                    color: _uploadStatus.contains('موفقیت')
                        ? Colors.green
                        : _uploadStatus.contains('خطا')
                            ? Colors.red
                            : Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
