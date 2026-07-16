import 'package:flutter/material.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/core/widgets/page_header.dart';
import 'package:web/web.dart' as web;
import 'package:stock_app_web/core/utils/guid_video_links.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            PageHeader(
              title: 'Support',
              viewDate: '',
              query: (String p1) {},
              videoLink: '',
              page: 'support',
              invoiceNo: '',
              showReport: false,
            ),

            const SizedBox(height: 20),
            Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Text('For support please call'),
                      const SizedBox(height: 20),
                      // Display phone number with optional styling
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Phone 1: +91 8807403799',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Phone 2: +91 7305003799',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          print('youtubeUrl $stockChittaPage');
                          final Uri youtubeUrl = Uri.parse(stockChittaPage);
                          web.window.open(youtubeUrl.toString(), '_blank');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(100, 50),
                        ),
                        child: Text(
                          'Youtube : Stock Chitta',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
