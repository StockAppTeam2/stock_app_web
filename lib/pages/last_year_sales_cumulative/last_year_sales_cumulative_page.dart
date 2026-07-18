import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/controllers/last_year_sales_cumulative_controller.dart';
import 'package:stock_app_web/core/locator/service_locator.dart';
import 'package:stock_app_web/core/repositories/Internet_connection_repo.dart';
import 'package:stock_app_web/core/widgets/app_navigator_wrapper.dart';
import 'package:stock_app_web/models/previous_year_sales_cumulative.dart';
import 'package:stock_app_web/pages/widgets/toast_popup.dart';

class LastYearSalesCumulativePage extends StatefulWidget {
  final String monthAndYear;
  const LastYearSalesCumulativePage({super.key, required this.monthAndYear});

  @override
  State<LastYearSalesCumulativePage> createState() =>
      _LastYearSalesCumulativePageState();
}

class _LastYearSalesCumulativePageState
    extends State<LastYearSalesCumulativePage> {
  final _lastYearSalesCumulativeController =
      getIt<LastYearSalesCumulativeController>();
  final _internetConnectionRepo = getIt<InternetConnectionRepo>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController bundleController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController previousYearTotalSalesCumulativePrice =
      TextEditingController();

  late Future<List<PreviousYearSalesCumulativeModel>> _future;

  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    _future = getData();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigatorWrapper(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last Year Details', style: TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<PreviousYearSalesCumulativeModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (_, index) {
                          final data = products[index];

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          formatDate(data.date),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) async {
                                          bool isConnected =
                                              await _internetConnectionRepo
                                                  .checkInternetConnection();

                                          if (!isConnected) {
                                            showErrorToast(
                                              'No Internet Connection',
                                            );
                                            return;
                                          }

                                          if (value == 'Edit') {
                                            if (!context.mounted) return;
                                            final bool? isEdited =
                                                await _editItem(data, context);

                                            if (isEdited == true) {
                                              setState(() {
                                                _future = getData();
                                              });
                                            }
                                          } else {
                                            if (!context.mounted) return;
                                            final bool? isDeleted =
                                                await _deleteItem(
                                                  data,
                                                  context,
                                                );

                                            if (isDeleted == true) {
                                              setState(() {
                                                _future = getData();
                                              });
                                            }
                                          }
                                        },
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                            value: 'Edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(width: 10),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'Delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 10),
                                                Text('Delete'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    columnWidths: const {
                                      0: FlexColumnWidth(4),
                                      1: FixedColumnWidth(20),
                                      2: FlexColumnWidth(2),
                                    },
                                    children: [
                                      _buildRow(
                                        'CUMULATIVE IMFL SALES IN CASES',
                                        data.imflCases.toString(),
                                      ),
                                      _buildRow(
                                        'CUMULATIVE BEER SALES IN CASES',
                                        data.beerCases.toString(),
                                      ),
                                      _buildRow(
                                        'CUMULATIVE TOTAL SALES VALUE (₹)',
                                        data.totalPreviousYearSalesCumulative
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            ':',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text nameText(String text) {
    return Text(text, style: TextStyle(fontSize: 18, color: Colors.black));
  }

  Text colonText() {
    return Text(
      ':',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  TableRow spaceRow() {
    return const TableRow(
      children: [
        SizedBox(height: 16),
        SizedBox(height: 16),
        SizedBox(height: 16),
      ],
    );
  }

  Text valueText(String number) {
    return Text(
      int.parse(number).isNegative ? '0' : number,
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 18, color: Colors.blue[900]),
    );
  }

  Text valueTextDate(String number) {
    return Text(
      number,
      textAlign: TextAlign.end,
      style: TextStyle(fontSize: 18, color: Colors.blue[900]),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String date1 = DateFormat('dd-MM-yyyy').format(dateTime);
    return date1;
  }

  bool isNumeric(String value) {
    if (value == '') {
      return false;
    }
    if (int.tryParse(value) != null) {
      return !int.tryParse(value)!.isNegative;
    }
    return int.tryParse(value) != null;
  }

  Future<List<PreviousYearSalesCumulativeModel>> getData() async {
    List<PreviousYearSalesCumulativeModel> data = [];
    if (widget.monthAndYear != '') {
      print('widget.date ${widget.monthAndYear}');
      data = await _lastYearSalesCumulativeController
          .getPreviousYearSalesCumulative(widget.monthAndYear);

      data.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
      );
    }

    return data;
  }

  Future<bool?> _editItem(
    PreviousYearSalesCumulativeModel model,
    BuildContext context,
  ) async {
    setState(() {
      bundleController.text = model.imflCases.toString();
      retailController.text = model.beerCases.toString();
      previousYearTotalSalesCumulativePrice.text = model
          .totalPreviousYearSalesCumulative
          .toString();
    });
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: showLoader
                  ? Container()
                  : Text('Edit Date: ${formatDate(model.date)}'),
              content: Form(
                key: _formKey,
                child: showLoader
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Processing...'),
                          CircularProgressIndicator(),
                        ],
                      )
                    : SizedBox(
                        width: 350,
                        height: 350,
                        child: ListView(
                          children: [
                            const Text('CUMULATIVE IMFL\nSALES IN CASES :'),
                            TextFormField(
                              controller: bundleController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isNumeric(value)) {
                                  return 'Enter Valid Number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter Imfl Cases',
                              ),
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text('CUMULATIVE BEER\nSALES IN CASES :'),
                            TextFormField(
                              controller: retailController,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isNumeric(value)) {
                                  return 'Enter Valid Number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter Beer Cases',
                              ),
                              onEditingComplete: () {
                                FocusScope.of(context).nextFocus();
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text('CUMULATIVE TOTAL\nSALES VALUE RS.'),
                            TextFormField(
                              controller: previousYearTotalSalesCumulativePrice,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !isNumeric(value)) {
                                  return 'Enter Valid Number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter Total Sales Value',
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                showLoader
                    ? Container()
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (!mounted) return;
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                showLoader
                    ? Container()
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            showLoader = true;
                          });

                          try {
                            final int? imflCase = int.tryParse(
                              bundleController.text,
                            );
                            final int? beerCase = int.tryParse(
                              retailController.text,
                            );
                            final int? totalPrice = int.tryParse(
                              previousYearTotalSalesCumulativePrice.text,
                            );

                            if (imflCase == null ||
                                beerCase == null ||
                                totalPrice == null) {
                              showErrorToast('Invalid input');
                              return;
                            }

                            final editedModel =
                                PreviousYearSalesCumulativeModel(
                                  id: model.id,
                                  date: model.date,
                                  imflCases: imflCase,
                                  beerCases: beerCase,
                                  totalPreviousYearSalesCumulative: totalPrice,
                                  isSynced: 1,
                                );

                            await _lastYearSalesCumulativeController
                                .addLastYearSalesCumulative(editedModel);

                            if (!context.mounted) return;

                            showSuccessToast('Cumulative Updated Successfully');

                            bundleController.clear();
                            retailController.clear();
                            previousYearTotalSalesCumulativePrice.clear();

                            Navigator.pop(context, true);
                          } catch (e) {
                            showErrorToast('Failed to update data');
                          } finally {
                            if (mounted) {
                              setState(() {
                                showLoader = false;
                              });
                            }
                          }
                        },
                        child: const Text('Ok'),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool?> _deleteItem(
    PreviousYearSalesCumulativeModel model,
    BuildContext context,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: showLoader
                  ? Container()
                  : const Text('Do You Want To Delete?'),
              content: showLoader
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Processing...'),
                        CircularProgressIndicator(),
                      ],
                    )
                  : Text('Date : ${formatDate(model.date)}'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                showLoader
                    ? Container()
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (!mounted) return;
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                showLoader
                    ? Container()
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          setState(() {
                            showLoader = true;
                          });

                          try {
                            await _lastYearSalesCumulativeController
                                .deletePreviousYearSalesCumulative(model.date);

                            if (!context.mounted) return;

                            showSuccessToast('Item Deleted Successfully');

                            Navigator.pop(context, true); // Return success
                          } catch (e) {
                            showErrorToast('Failed to delete item');

                            if (mounted) {
                              setState(() {
                                showLoader = false;
                              });
                            }
                          }
                        },
                        child: const Text('Ok'),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
