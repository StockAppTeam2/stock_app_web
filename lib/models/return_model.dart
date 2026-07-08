class ReturnModel {
  int? id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  int returnBundle;
  int returnRetail;
  int totalReturnRetailUnits;
  int totalPriceReturn;
  int isSynced;

  ReturnModel({
    this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.returnBundle,
    required this.returnRetail,
    required this.totalReturnRetailUnits,
    required this.totalPriceReturn,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'returnBundle': returnBundle,
      'returnRetail': returnRetail,
      'totalReturnRetailUnits': totalReturnRetailUnits,
      'totalPriceReturn': totalPriceReturn,
      'isSynced': isSynced,
    };
  }

  factory ReturnModel.fromMap(Map<String, dynamic> map) {
    return ReturnModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      returnBundle: map['returnBundle'],
      returnRetail: map['returnRetail'],
      totalReturnRetailUnits: map['totalReturnRetailUnits'],
      totalPriceReturn: map['totalPriceReturn'],
      isSynced: map['isSynced'],
    );
  }
}

class ReturnViewModel {
  int? id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  int returnBundle;
  int returnRetail;
  int totalReturnRetailUnits;
  int totalPriceReturn;
  String brand;
  String itemsGroup;
  String category;
  String range;
  String size;
  int price;
  int bottlePerBundle;
  int isSynced;

  ReturnViewModel({
    this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.returnBundle,
    required this.returnRetail,
    required this.totalReturnRetailUnits,
    required this.totalPriceReturn,
    required this.brand,
    required this.itemsGroup,
    required this.category,
    required this.range,
    required this.size,
    required this.price,
    required this.bottlePerBundle,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'returnBundle': returnBundle,
      'returnRetail': returnRetail,
      'totalReturnRetailUnits': totalReturnRetailUnits,
      'totalPriceReturn': totalPriceReturn,
      'brand': brand,
      'itemsGroup': itemsGroup,
      'category': category,
      'range': range,
      'size': size,
      'price': price,
      'bottlePerBundle': bottlePerBundle,
      'isSynced': isSynced,
    };
  }

  factory ReturnViewModel.fromMap(Map<String, dynamic> map) {
    return ReturnViewModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      returnBundle: map['returnBundle'],
      returnRetail: map['returnRetail'],
      totalReturnRetailUnits: map['totalReturnRetailUnits'],
      totalPriceReturn: map['totalPriceReturn'],
      brand: map['brand'],
      itemsGroup: map['groups'],
      category: map['category'],
      range: map['range'],
      size: map['size'],
      price: map['price'],
      bottlePerBundle: map['bottlePerBundle'],
      isSynced: map['isSynced'],
    );
  }
}
