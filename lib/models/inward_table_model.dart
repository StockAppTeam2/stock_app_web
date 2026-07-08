class InwardTableModel {
  int? id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  String invoiceNo;
  String invoiceDate;
  int inwardBundle;
  int inwardRetail;
  int totalInwardRetailUnits;
  int totalPriceInward;
  int isSynced;

  InwardTableModel({
    this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.inwardBundle,
    required this.inwardRetail,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.totalInwardRetailUnits,
    required this.totalPriceInward,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'invoiceNo': invoiceNo,
      'invoiceDate': invoiceDate,
      'inwardBundle': inwardBundle,
      'inwardRetail': inwardRetail,
      'totalInwardRetailUnits': totalInwardRetailUnits,
      'totalPriceInward': totalPriceInward,
      'isSynced': isSynced,
    };
  }

  factory InwardTableModel.fromMap(Map<String, dynamic> map) {
    return InwardTableModel(
      id: map['id'] as int,
      productId: map['productId'] as int,
      phoneNumber: map['phoneNumber'] as int,
      date: map['date'] as String,
      time: map['time'] as String,
      invoiceNo: map['invoiceNo'] as String,
      invoiceDate: map['invoiceDate'] as String,
      inwardBundle: map['inwardBundle'] as int,
      inwardRetail: map['inwardRetail'] as int,
      isSynced: map['isSynced'] as int,
      totalInwardRetailUnits: map['totalInwardRetailUnits'] as int,
      totalPriceInward: map['totalPriceInward'] as int,
    );
  }
}

class InwardViewModel {
  int? id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  String invoiceNo;
  String invoiceDate;
  String inwardGroup;
  int inwardBundle;
  int inwardRetail;
  int price;
  String brand;
  String size;
  String category;
  String range;
  int bottlePerBundle;
  int isSynced;
  int totalInwardRetailUnits;
  int totalPriceInward;

  InwardViewModel({
    this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.inwardGroup,
    required this.inwardBundle,
    required this.inwardRetail,
    required this.price,
    required this.brand,
    required this.size,
    required this.category,
    required this.range,
    required this.bottlePerBundle,
    required this.totalInwardRetailUnits,
    required this.totalPriceInward,
    required this.isSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'invoiceNo': invoiceNo,
      'invoiceDate': invoiceDate,
      'inwardGroup': inwardGroup,
      'inwardBundle': inwardBundle,
      'inwardRetail': inwardRetail,
      'price': price,
      'brand': brand,
      'size': size,
      'category': category,
      'range': range,
      'bottlePerBundle': bottlePerBundle,
      'totalInwardRetailUnits': totalInwardRetailUnits,
      'totalPriceInward': totalPriceInward,
      'isSynced': isSynced,
    };
  }

  factory InwardViewModel.fromMap(Map<String, dynamic> map) {
    return InwardViewModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      invoiceNo: map['invoiceNo'],
      invoiceDate: map['invoiceDate'],
      inwardGroup: map['groups'],
      inwardBundle: map['inwardBundle'],
      inwardRetail: map['inwardRetail'],
      price: map['price'],
      brand: map['brand'],
      size: map['size'],
      category: map['category'],
      range: map['range'],
      bottlePerBundle: map['bottlePerBundle'],
      isSynced: map['isSynced'],
      totalInwardRetailUnits: map['totalInwardRetailUnits'],
      totalPriceInward: map['totalPriceInward'],
    );
  }
}

class InwardDailyFolderModel {
  String invoiceNo;
  String date;
  int imfTotalPrice;
  int beerTotalPrice;
  int imflAndBeerTotal;

  InwardDailyFolderModel({
    this.invoiceNo = "",
    this.date = "",
    this.imfTotalPrice = 0,
    this.beerTotalPrice = 0,
    this.imflAndBeerTotal = 0,
  });

  factory InwardDailyFolderModel.fromMap(Map<String, dynamic> map) {
    return InwardDailyFolderModel(
      invoiceNo: map['invoiceNo'] ?? "",
      date: map['date'] ?? "",
      imfTotalPrice: map['imfTotalPrice'] ?? 0,
      beerTotalPrice: map['beerTotalPrice'] ?? 0,
      imflAndBeerTotal: map['imflAndBeerTotal'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceNo': invoiceNo,
      'date': date,
      'imfTotalPrice': imfTotalPrice,
      'beerTotalPrice': beerTotalPrice,
      'imflAndBeerTotal': imflAndBeerTotal,
    };
  }
}
