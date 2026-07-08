class PreviousYearSalesCumulativeModel {
  int? id;
  String date;
  int imflCases;
  int beerCases;
  int totalPreviousYearSalesCumulative;
  int isSynced;

  PreviousYearSalesCumulativeModel({
    this.id,
    required this.date,
    required this.imflCases,
    required this.beerCases,
    required this.totalPreviousYearSalesCumulative,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'imflCases': imflCases,
      'beerCases': beerCases,
      'totalPreviousYearSalesCumulative': totalPreviousYearSalesCumulative,
      'isSynced': isSynced,
    };
  }

  factory PreviousYearSalesCumulativeModel.fromMap(Map<String, dynamic> data) {
    return PreviousYearSalesCumulativeModel(
      id: data['id'],
      date: data['date'],
      imflCases: data['imflCases'],
      beerCases: data['beerCases'],
      totalPreviousYearSalesCumulative:
          data['totalPreviousYearSalesCumulative'],
      isSynced: data['isSynced'],
    );
  }
}
