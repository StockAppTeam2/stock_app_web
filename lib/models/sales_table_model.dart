class SalesTableModel {
  int? id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  int totalPriceSales;
  int totalSalesRetailUnits;
  int salesBundle;
  int salesRetail;
  int isSynced;

  SalesTableModel({
    this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.totalPriceSales,
    required this.totalSalesRetailUnits,
    required this.salesBundle,
    required this.salesRetail,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'totalPriceSales': totalPriceSales,
      'totalSalesRetailUnits': totalSalesRetailUnits,
      'salesBundle': salesBundle,
      'salesRetail': salesRetail,
      'isSynced': isSynced,
    };
  }

  factory SalesTableModel.fromMap(Map<String, dynamic> map) {
    return SalesTableModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      totalPriceSales: map['totalPriceSales'],
      totalSalesRetailUnits: map['totalSalesRetailUnits'],
      salesBundle: map['salesBundle'],
      salesRetail: map['salesRetail'],
      isSynced: map['isSynced'],
    );
  }
}

class SalesViewModel {
  int id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  String category;
  String group;
  int price;
  int totalPriceSales;
  int bottlePerBundle;
  int totalSalesRetailUnits;
  int salesBundle;
  int salesRetail;
  String brand;
  String size;
  String range;
  int isSynced;

  SalesViewModel({
    required this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.category,
    required this.group,
    required this.price,
    required this.totalPriceSales,
    required this.bottlePerBundle,
    required this.totalSalesRetailUnits,
    required this.salesBundle,
    required this.salesRetail,
    required this.brand,
    required this.size,
    required this.range,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'category': category,
      'group': group,
      'price': price,
      'totalPriceSales': totalPriceSales,
      'bottlePerBundle': bottlePerBundle,
      'totalSalesRetailUnits': totalSalesRetailUnits,
      'salesBundle': salesBundle,
      'salesRetail': salesRetail,
      'brand': brand,
      'size': size,
      'range': range,
      'isSynced': isSynced,
    };
  }

  factory SalesViewModel.fromMap(Map<String, dynamic> map) {
    return SalesViewModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      category: map['category'],
      group: map['groups'],
      price: map['price'],
      totalPriceSales: map['totalPriceSales'],
      bottlePerBundle: map['bottlePerBundle'],
      totalSalesRetailUnits: map['totalSalesRetailUnits'],
      salesBundle: map['salesBundle'],
      salesRetail: map['salesRetail'],
      brand: map['brand'],
      size: map['size'],
      isSynced: map['isSynced'],
      range: map['range'],
    );
  }
}

class SalesEntryViewModel {
  int id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  String category;
  String group;
  int price;
  int totalPriceSales;
  int bottlePerBundle;
  int totalSalesRetailUnits;
  int salesBundle;
  int salesRetail;
  String brand;
  String size;
  String range;
  int isSynced;
  int totalActualRetailUnits;

  SalesEntryViewModel({
    required this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.category,
    required this.group,
    required this.price,
    required this.totalPriceSales,
    required this.bottlePerBundle,
    required this.totalSalesRetailUnits,
    required this.salesBundle,
    required this.salesRetail,
    required this.brand,
    required this.size,
    required this.range,
    required this.isSynced,
    required this.totalActualRetailUnits,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'category': category,
      'group': group,
      'price': price,
      'totalPriceSales': totalPriceSales,
      'bottlePerBundle': bottlePerBundle,
      'totalSalesRetailUnits': totalSalesRetailUnits,
      'salesBundle': salesBundle,
      'salesRetail': salesRetail,
      'brand': brand,
      'size': size,
      'range': range,
      'isSynced': isSynced,
      'totalActualRetailUnits': totalActualRetailUnits,
    };
  }

  factory SalesEntryViewModel.fromMap(Map<String, dynamic> map) {
    return SalesEntryViewModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      category: map['category'],
      group: map['groups'],
      price: map['price'],
      totalPriceSales: map['totalPriceSales'],
      bottlePerBundle: map['bottlePerBundle'],
      totalSalesRetailUnits: map['totalSalesRetailUnits'],
      salesBundle: map['salesBundle'],
      salesRetail: map['salesRetail'],
      brand: map['brand'],
      size: map['size'],
      isSynced: map['isSynced'],
      totalActualRetailUnits: map['totalActualRetailUnits'],
      range: map['range'],
    );
  }
}
