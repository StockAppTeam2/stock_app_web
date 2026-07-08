import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_app_web/models/inward_table_model.dart';
import 'package:stock_app_web/models/items_table_model.dart';

Text sNoText(String text) {
  return Text(text, style: TextStyle(fontSize: 18, color: Colors.black));
}

Text nameText(String text) {
  return Text(text, style: TextStyle(fontSize: 18, color: Colors.black));
}

Text colonText() {
  return Text(':', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
}

Text valueText(String number) {
  return Text(
    int.parse(number).isNegative ? '0' : number,
    textAlign: TextAlign.end,
    style: TextStyle(fontSize: 18, color: Colors.blue[900]),
  );
}

RichText valueTextPreviousYearCumulative(String number1, String? number2) {
  return RichText(
    textAlign: TextAlign.end,
    text: TextSpan(
      style: TextStyle(fontSize: 18, color: Colors.blue[900]),
      children: [
        TextSpan(text: int.parse(number1).isNegative ? '0' : number1),
        TextSpan(
          text:
              (number2 != null &&
                  number2.isNotEmpty &&
                  int.tryParse(number2) != null)
              ? ' ('
              : '',
        ),
        TextSpan(
          text:
              (number2 != null &&
                  number2.isNotEmpty &&
                  int.tryParse(number2) != null)
              ? (int.parse(number2).isNegative ? number2 : '+$number2')
              : '',
          style: TextStyle(
            color:
                (number2 != null &&
                    number2.isNotEmpty &&
                    int.tryParse(number2) != null)
                ? (int.parse(number2).isNegative ? Colors.red : Colors.green)
                : Colors.black, // Default color for non-numeric or empty input
          ),
        ),
        TextSpan(
          text:
              (number2 != null &&
                  number2.isNotEmpty &&
                  int.tryParse(number2) != null)
              ? ') '
              : '',
        ),
      ],
    ),
  );
}

Text valueTextDate(String number) {
  return Text(
    number,
    textAlign: TextAlign.end,
    style: TextStyle(fontSize: 18, color: Colors.blue[900]),
  );
}

TableRow spaceRow() {
  return const TableRow(
    children: [
      SizedBox(height: 16),
      SizedBox(height: 16),
      SizedBox(height: 16),
      SizedBox(height: 16),
    ],
  );
}

List<String> getMonthYear() {
  DateTime now = DateTime.now();
  DateTime previousYear = DateTime(now.year - 1, now.month, now.day);
  String formattedDatePreviousYear = DateFormat(
    'MMMM yyyy',
  ).format(previousYear);
  String formattedDateNow = DateFormat('MMMM yyyy').format(now);
  return [formattedDatePreviousYear, formattedDateNow];
}

int customRound(double number) {
  if (number - number.floor() < 0.5) {
    return number.floor();
  } else {
    return number.ceil();
  }
}

Future<int> ordinaryImflCBCase(List<ItemsViewModel> openCloseActual) async {
  // ORDINARY imfl cb case
  List<ItemsViewModel> cbOrdImfl = openCloseActual
      .where((element) => element.range == 'ORDINARY')
      .toList();
  List<ItemsViewModel> cdOrd180 = cbOrdImfl
      .where((element) => element.size == '180 ml')
      .toList();
  List<ItemsViewModel> cdOrd375 = cbOrdImfl
      .where((element) => element.size == '375 ml')
      .toList();
  List<ItemsViewModel> cdOrd750 = cbOrdImfl
      .where((element) => element.size == '750 ml')
      .toList();
  List<ItemsViewModel> cdOrd1000 = cbOrdImfl
      .where((element) => element.size == '1000 ml')
      .toList();

  int cb180Bottles = await calcCbUnits(cdOrd180);
  int cb375Bottles = await calcCbUnits(cdOrd375);
  int cb750Bottles = await calcCbUnits(cdOrd750);
  int cb1000Bottles = await calcCbUnits(cdOrd1000);

  double ordImflCbCaseCorrect =
      (cb180Bottles +
          (cb375Bottles * 2) +
          (cb750Bottles * 4) +
          (cb1000Bottles * 5)) /
      48;
  int ordImflCbCase = customRound(ordImflCbCaseCorrect);
  return ordImflCbCase;
}

Future<int> mediumImflCBCase(List<ItemsViewModel> openCloseActual) async {
  // MEDIUM imfl cb case
  List<ItemsViewModel> cbMediumImfl = openCloseActual
      .where((element) => element.range == 'MEDIUM')
      .toList();
  List<ItemsViewModel> cdMedium180 = cbMediumImfl
      .where((element) => element.size == '180 ml')
      .toList();
  List<ItemsViewModel> cdMedium375 = cbMediumImfl
      .where((element) => element.size == '375 ml')
      .toList();
  List<ItemsViewModel> cdMedium750 = cbMediumImfl
      .where((element) => element.size == '750 ml')
      .toList();

  int cb180Bottles = await calcCbUnits(cdMedium180);
  int cb375Bottles = await calcCbUnits(cdMedium375);
  int cb750Bottles = await calcCbUnits(cdMedium750);

  double medImflCbCaseCorrect =
      (cb180Bottles + (cb375Bottles * 2) + (cb750Bottles * 4)) / 48;
  int medImflCbCase = customRound(medImflCbCaseCorrect);
  return medImflCbCase;
}

Future<int> premiumImflCBCase(List<ItemsViewModel> openCloseActual) async {
  // ORDINARY imfl cb case
  List<ItemsViewModel> cbPremiumImfl = openCloseActual
      .where((element) => element.range == 'PREMIUM')
      .toList();
  List<ItemsViewModel> cdPremium180 = cbPremiumImfl
      .where((element) => element.size == '180 ml')
      .toList();
  List<ItemsViewModel> cdPremium375 = cbPremiumImfl
      .where((element) => element.size == '375 ml')
      .toList();
  List<ItemsViewModel> cdPremium750 = cbPremiumImfl
      .where((element) => element.size == '750 ml')
      .toList();
  List<ItemsViewModel> cdPremium1000 = cbPremiumImfl
      .where((element) => element.size == '1000 ml')
      .toList();

  int cb180Bottles = await calcCbUnits(cdPremium180);
  int cb375Bottles = await calcCbUnits(cdPremium375);
  int cb750Bottles = await calcCbUnits(cdPremium750);
  int cb1000Bottles = await calcCbUnits(cdPremium1000);

  double preImflCbCaseCorrect =
      (cb180Bottles +
          (cb375Bottles * 2) +
          (cb750Bottles * 4) +
          (cb1000Bottles * 5)) /
      48;
  int preImflCbCase = customRound(preImflCbCaseCorrect);
  return preImflCbCase;
}

Future<int> strongBeerCBCase(List<ItemsViewModel> openCloseActual) async {
  // STRONG BEER cb case
  List<ItemsViewModel> cbStrongBeer = openCloseActual
      .where((element) => element.range == 'BEER')
      .toList();
  List<ItemsViewModel> cbBeer500 = cbStrongBeer
      .where((element) => element.size == '500 ml')
      .toList();
  List<ItemsViewModel> cbBeer325 = cbStrongBeer
      .where((element) => element.size == '325 ml')
      .toList();
  List<ItemsViewModel> cbBeer650 = cbStrongBeer
      .where((element) => element.size == '650 ml')
      .toList();

  int cb500Bottles = await calcCbUnits(cbBeer500);
  int cb325Bottles = await calcCbUnits(cbBeer325);
  int cb650Bottles = await calcCbUnits(cbBeer650);

  double strongCbCaseCorrect =
      (cb500Bottles + cb325Bottles + (cb650Bottles * 2)) / 24;

  int strongBeerCbCase = customRound(strongCbCaseCorrect);
  return strongBeerCbCase;
}

Future<int> calcCbUnits(List<ItemsViewModel> cbData) async {
  if (cbData.isNotEmpty) {
    int output = cbData.fold(
      0,
      (sum, element) => sum + element.totalCloseRetailUnits,
    );
    return output;
  } else {
    return 0;
  }
}

Future<int> ordinaryImflInwardCase(List<InwardViewModel> inwardData) async {
  // ORDINARY imfl inward case
  List<InwardViewModel> inwardOrdImfl = inwardData
      .where((element) => element.range == 'ORDINARY')
      .toList();
  List<InwardViewModel> inwardOrd180 = inwardOrdImfl
      .where((element) => element.size == '180 ml')
      .toList();
  List<InwardViewModel> inwardOrd375 = inwardOrdImfl
      .where((element) => element.size == '375 ml')
      .toList();
  List<InwardViewModel> inwardOrd750 = inwardOrdImfl
      .where((element) => element.size == '750 ml')
      .toList();
  List<InwardViewModel> inwardOrd1000 = inwardOrdImfl
      .where((element) => element.size == '1000 ml')
      .toList();

  int inward180Bottles = await calcInwardUnits(inwardOrd180);
  int inward375Bottles = await calcInwardUnits(inwardOrd375);
  int inward750Bottles = await calcInwardUnits(inwardOrd750);
  int inward1000Bottles = await calcInwardUnits(inwardOrd1000);

  double ordImflInwardCaseCorrect =
      (inward180Bottles +
          (inward375Bottles * 2) +
          (inward750Bottles * 4) +
          (inward1000Bottles * 5)) /
      48;
  int ordImflInwardCase = customRound(ordImflInwardCaseCorrect);
  return ordImflInwardCase;
}

Future<int> mediumImflInwardCase(List<InwardViewModel> inwardData) async {
  // MEDIUM imfl inward case
  List<InwardViewModel> inwardMediumImfl = inwardData
      .where((element) => element.range == 'MEDIUM')
      .toList();
  List<InwardViewModel> inwardMedium180 = inwardMediumImfl
      .where((element) => element.size == '180 ml')
      .toList();
  List<InwardViewModel> inwardMedium375 = inwardMediumImfl
      .where((element) => element.size == '375 ml')
      .toList();
  List<InwardViewModel> inwardMedium750 = inwardMediumImfl
      .where((element) => element.size == '750 ml')
      .toList();

  int inward180Bottles = await calcInwardUnits(inwardMedium180);
  int inward375Bottles = await calcInwardUnits(inwardMedium375);
  int inward750Bottles = await calcInwardUnits(inwardMedium750);

  double medImflInwardCaseCorrect =
      (inward180Bottles + (inward375Bottles * 2) + (inward750Bottles * 4)) / 48;
  int medImflInwardCase = customRound(medImflInwardCaseCorrect);
  return medImflInwardCase;
}

Future<int> premiumImflInwardCase(List<InwardViewModel> inwardData) async {
  // ORDINARY inward cb case
  List<InwardViewModel> inwardPremiumImfl = inwardData
      .where((element) => element.range == 'PREMIUM')
      .toList();
  List<InwardViewModel> inwardPremium180 = inwardPremiumImfl
      .where((element) => element.size == '180 ml')
      .toList();
  List<InwardViewModel> inwardPremium375 = inwardPremiumImfl
      .where((element) => element.size == '375 ml')
      .toList();
  List<InwardViewModel> inwardPremium750 = inwardPremiumImfl
      .where((element) => element.size == '750 ml')
      .toList();
  List<InwardViewModel> inwardPremium1000 = inwardPremiumImfl
      .where((element) => element.size == '1000 ml')
      .toList();

  int inward180Bottles = await calcInwardUnits(inwardPremium180);
  int inward375Bottles = await calcInwardUnits(inwardPremium375);
  int inward750Bottles = await calcInwardUnits(inwardPremium750);
  int inward1000Bottles = await calcInwardUnits(inwardPremium1000);

  double preImflInwardCaseCorrect =
      (inward180Bottles +
          (inward375Bottles * 2) +
          (inward750Bottles * 4) +
          (inward1000Bottles * 5)) /
      48;
  int preImflInwardCase = customRound(preImflInwardCaseCorrect);
  return preImflInwardCase;
}

Future<int> strongBeerInwardCase(List<InwardViewModel> inwardData) async {
  // STRONG BEER inward case
  List<InwardViewModel> inwardStrongBeer = inwardData
      .where((element) => element.range == 'BEER')
      .toList();
  List<InwardViewModel> inwardBeer500 = inwardStrongBeer
      .where((element) => element.size == '500 ml')
      .toList();
  List<InwardViewModel> inwardBeer325 = inwardStrongBeer
      .where((element) => element.size == '325 ml')
      .toList();
  List<InwardViewModel> inwardBeer650 = inwardStrongBeer
      .where((element) => element.size == '650 ml')
      .toList();

  int inward500Bottles = await calcInwardUnits(inwardBeer500);
  int inward325Bottles = await calcInwardUnits(inwardBeer325);
  int inward650Bottles = await calcInwardUnits(inwardBeer650);

  double strongInwardCaseCorrect =
      (inward500Bottles + inward325Bottles + (inward650Bottles * 2)) / 24;

  int strongBeerInwardCase = customRound(strongInwardCaseCorrect);
  return strongBeerInwardCase;
}

Future<int> calcInwardUnits(List<InwardViewModel> inwardData) async {
  if (inwardData.isNotEmpty) {
    int output = inwardData.fold(
      0,
      (sum, element) => sum + element.totalInwardRetailUnits,
    );
    return output;
  } else {
    return 0;
  }
}

Future<int> stockReceiptImflCase(List<InwardViewModel> imflStockCases) async {
  List<InwardViewModel> inward180 = imflStockCases
      .where((element) => element.size == '180 ml')
      .toList();
  List<InwardViewModel> inward375 = imflStockCases
      .where((element) => element.size == '375 ml')
      .toList();
  List<InwardViewModel> inward750 = imflStockCases
      .where((element) => element.size == '750 ml')
      .toList();
  List<InwardViewModel> inward1000 = imflStockCases
      .where((element) => element.size == '1000 ml')
      .toList();

  int in180Bottles = await calcInwardUnits(inward180);
  int in375Bottles = await calcInwardUnits(inward375);
  int in750Bottles = await calcInwardUnits(inward750);
  int in1000Bottles = await calcInwardUnits(inward1000);

  double inwardImflCbCaseCorrect =
      (in180Bottles +
          (in375Bottles * 2) +
          (in750Bottles * 4) +
          (in1000Bottles * 5)) /
      48;
  int stockReceiptImflCase = customRound(inwardImflCbCaseCorrect);
  return stockReceiptImflCase;
}

Future<int> stockReceiptBeerCase(List<InwardViewModel> beerStockCases) async {
  List<InwardViewModel> beer500 = beerStockCases
      .where((element) => element.size == '500 ml')
      .toList();
  List<InwardViewModel> beer325 = beerStockCases
      .where((element) => element.size == '325 ml')
      .toList();
  List<InwardViewModel> beer650 = beerStockCases
      .where((element) => element.size == '650 ml')
      .toList();

  int inBeer500Bottles = await calcInwardUnits(beer500);
  int inBeer325Bottles = await calcInwardUnits(beer325);
  int inBeer650Bottles = await calcInwardUnits(beer650);

  double inwardBeerCbCaseCorrect =
      (inBeer500Bottles + inBeer325Bottles + (inBeer650Bottles * 2)) / 24;
  int stockReceiptBeerCase = customRound(inwardBeerCbCaseCorrect);
  return stockReceiptBeerCase;
}
