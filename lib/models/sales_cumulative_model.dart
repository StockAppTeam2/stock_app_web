class SalesCumulativeModel {
  int? id;
  String date;
  int imflCumulativeCases;
  int beerCumulativeCases;
  int totalCumulative;
  int isSynced;

  SalesCumulativeModel({
    this.id,
    required this.date,
    required this.imflCumulativeCases,
    required this.beerCumulativeCases,
    required this.totalCumulative,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'imflCumulativeCases': imflCumulativeCases,
      'beerCumulativeCases': beerCumulativeCases,
      'totalCumulative': totalCumulative,
      'isSynced': isSynced,
    };
  }

  factory SalesCumulativeModel.forMap(Map<String, dynamic> map) {
    return SalesCumulativeModel(
      id: map['id'],
      date: map['date'],
      imflCumulativeCases: map['imflCumulativeCases'],
      beerCumulativeCases: map['beerCumulativeCases'],
      totalCumulative: map['totalCumulative'],
      isSynced: map['isSynced'],
    );
  }
}
