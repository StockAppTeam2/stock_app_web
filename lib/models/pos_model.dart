class NewPosModel {
  int? id;
  int posValue;
  int posNumberOfBills;
  int posNumberOfBottles;
  int posImflSalesValue;
  int posBeerSalesValue;
  int posImflBottles;
  int posBeerBottles;
  int posCumulative;
  String posDate;
  int isSynced;
  int posShopCardPos;
  int posShopUpiPos;
  int posBarCardPos;
  int posBarUpiPos;

  NewPosModel({
    this.id,
    required this.posValue,
    required this.posDate,
    required this.posNumberOfBills,
    required this.posNumberOfBottles,
    required this.posImflSalesValue,
    required this.posBeerSalesValue,
    required this.posImflBottles,
    required this.posBeerBottles,
    required this.posCumulative,
    required this.isSynced,
    required this.posShopCardPos,
    required this.posShopUpiPos,
    required this.posBarCardPos,
    required this.posBarUpiPos,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'posDate': posDate,
      'posValue': posValue,
      'posNumberOfBills': posNumberOfBills,
      'posNumberOfBottles': posNumberOfBottles,
      'posImflSalesValue': posImflSalesValue,
      'posBeerSalesValue': posBeerSalesValue,
      'posImflBottles': posImflBottles,
      'posBeerBottles': posBeerBottles,
      'posCumulative': posCumulative,
      'isSynced': isSynced,
      'posShopCardPos': posShopCardPos,
      'posShopUpiPos': posShopUpiPos,
      'posBarCardPos': posBarCardPos,
      'posBarUpiPos': posBarUpiPos,
    };
  }

  factory NewPosModel.fromMap(Map<String, dynamic> map) {
    return NewPosModel(
      id: map['id'],
      posDate: map['posDate'],
      posValue: map['posValue'] ?? 0,
      posNumberOfBills: map['posNumberOfBills'],
      posNumberOfBottles: map['posNumberOfBottles'],
      posImflSalesValue: map['posImflSalesValue'],
      posBeerSalesValue: map['posBeerSalesValue'],
      posImflBottles: map['posImflBottles'],
      posBeerBottles: map['posBeerBottles'],
      posCumulative: map['posCumulative'],
      posShopCardPos: map['posShopCardPos'] ?? 0,
      posShopUpiPos: map['posShopUpiPos'] ?? 0,
      posBarCardPos: map['posBarCardPos'] ?? 0,
      posBarUpiPos: map['posBarUpiPos'] ?? 0,
      isSynced: map['isSynced'],
    );
  }
}
