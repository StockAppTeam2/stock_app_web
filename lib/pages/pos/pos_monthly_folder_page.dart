import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/pos_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/routes/app_routes.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/pages/widgets/youtube_button.dart';

class PosMonthlyFolderPage extends StatefulWidget {
  const PosMonthlyFolderPage({super.key});

  @override
  State<PosMonthlyFolderPage> createState() => _PosMonthlyFolderPageState();
}

class _PosMonthlyFolderPageState extends State<PosMonthlyFolderPage> {
  final posController = getIt<PosController>();

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              YoutubeButton(url: ''),
              ElevatedButton(
                onPressed: () {},
                child: Row(children: [Text('Add POS'), Icon(Icons.add)]),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: getPosDates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final posDates = snapshot.data ?? [];

                if (posDates.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  itemCount: posDates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 1.0,
                      child: GestureDetector(
                        child: ListTile(
                          title: Text(posDates[index]),
                          trailing: const Icon(Icons.navigate_next),
                          onTap: () {
                            context.go(
                              AppRoutes.pos,
                              extra: {'monthAndYear': posDates[index]},
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> getPosDates() async {
    List<String> posMonths = await posController.getPosMonths('3810');

    return posMonths.reversed.toList();
  }
}
