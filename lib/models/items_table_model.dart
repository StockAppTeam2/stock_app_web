class ItemsTableModel {
  int? id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  int openingBundle;
  int openingRetail;
  int actualBundle;
  int actualRetail;
  int closingBundle;
  int closingRetail;
  int totalOpenRetailUnits;
  int totalCloseRetailUnits;
  int totalActualRetailUnits;
  int totalPriceOpening;
  int totalPriceClosing;
  int totalPriceActual;
  int unscannedEntry;
  int isSynced;
  int checkOpeningCase;
  int checkOpeningBottle;
  int checkOpeningCaseBottle;
  int checkClosingCase;
  int checkClosingBottle;
  int checkClosingCaseBottle;
  int checkCurrentCase;
  int checkCurrentBottle;
  int checkCurrentCaseBottle;

  ItemsTableModel({
    this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.openingBundle,
    required this.openingRetail,
    required this.actualBundle,
    required this.actualRetail,
    required this.closingBundle,
    required this.closingRetail,
    required this.totalOpenRetailUnits,
    required this.totalCloseRetailUnits,
    required this.totalActualRetailUnits,
    required this.totalPriceOpening,
    required this.totalPriceClosing,
    required this.totalPriceActual,
    required this.unscannedEntry,
    required this.isSynced,
    required this.checkOpeningCase,
    required this.checkOpeningBottle,
    required this.checkOpeningCaseBottle,
    required this.checkClosingCase,
    required this.checkClosingBottle,
    required this.checkClosingCaseBottle,
    required this.checkCurrentCase,
    required this.checkCurrentBottle,
    required this.checkCurrentCaseBottle,
  });

  factory ItemsTableModel.fromMap(Map<String, dynamic> map) {
    return ItemsTableModel(
      id: map['id'],
      productId: map['productId'],
      phoneNumber: map['phoneNumber'],
      date: map['date'],
      time: map['time'],
      openingBundle: map['openingBundle'],
      openingRetail: map['openingRetail'],
      actualBundle: map['actualBundle'],
      actualRetail: map['actualRetail'],
      closingBundle: map['closingBundle'],
      closingRetail: map['closingRetail'],
      totalOpenRetailUnits: map['totalOpenRetailUnits'],
      totalCloseRetailUnits: map['totalCloseRetailUnits'],
      totalActualRetailUnits: map['totalActualRetailUnits'],
      totalPriceOpening: map['totalPriceOpening'],
      totalPriceClosing: map['totalPriceClosing'],
      totalPriceActual: map['totalPriceActual'],
      unscannedEntry: map['unscannedEntry'] ?? 0,
      isSynced: map['isSynced'],
      checkOpeningCase: map['checkOpeningCase'] ?? 0,
      checkOpeningBottle: map['checkOpeningBottle'] ?? 0,
      checkOpeningCaseBottle: map['checkOpeningCaseBottle'] ?? 0,
      checkClosingCase: map['checkClosingCase'] ?? 0,
      checkClosingBottle: map['checkClosingBottle'] ?? 0,
      checkClosingCaseBottle: map['checkClosingCaseBottle'] ?? 0,
      checkCurrentCase: map['checkCurrentCase'] ?? 0,
      checkCurrentBottle: map['checkCurrentBottle'] ?? 0,
      checkCurrentCaseBottle: map['checkCurrentCaseBottle'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'openingBundle': openingBundle,
      'openingRetail': openingRetail,
      'actualBundle': actualBundle,
      'actualRetail': actualRetail,
      'closingBundle': closingBundle,
      'closingRetail': closingRetail,
      'totalOpenRetailUnits': totalOpenRetailUnits,
      'totalCloseRetailUnits': totalCloseRetailUnits,
      'totalActualRetailUnits': totalActualRetailUnits,
      'totalPriceOpening': totalPriceOpening,
      'totalPriceClosing': totalPriceClosing,
      'totalPriceActual': totalPriceActual,
      'unscannedEntry': unscannedEntry,
      'isSynced': isSynced,
      'checkOpeningCase': checkOpeningCase,
      'checkOpeningBottle': checkOpeningBottle,
      'checkOpeningCaseBottle': checkOpeningCaseBottle,
      'checkClosingCase': checkClosingCase,
      'checkClosingBottle': checkClosingBottle,
      'checkClosingCaseBottle': checkClosingCaseBottle,
      'checkCurrentCase': checkCurrentCase,
      'checkCurrentBottle': checkCurrentBottle,
      'checkCurrentCaseBottle': checkCurrentCaseBottle,
    };
  }
}

class ItemsViewModel {
  int id;
  int productId;
  int phoneNumber;
  String date;
  String time;
  String brand;
  String itemsGroup;
  int openingBundle;
  int openingRetail;
  int actualBundle;
  int actualRetail;
  int closingBundle;
  int closingRetail;
  int price;
  int bottlePerBundle;
  int totalOpenRetailUnits;
  int totalCloseRetailUnits;
  String category;
  String range;
  String size;
  int isSynced;
  int totalActualRetailUnits;
  int totalPriceOpening;
  int totalPriceClosing;
  int unscannedEntry;
  int checkOpeningCase;
  int checkOpeningBottle;
  int checkOpeningCaseBottle;
  int checkClosingCase;
  int checkClosingBottle;
  int checkClosingCaseBottle;
  int checkCurrentCase;
  int checkCurrentBottle;
  int checkCurrentCaseBottle;
  int totalPriceActual;

  ItemsViewModel({
    required this.id,
    required this.productId,
    required this.phoneNumber,
    required this.date,
    required this.time,
    required this.brand,
    required this.itemsGroup,
    required this.openingBundle,
    required this.openingRetail,
    required this.actualBundle,
    required this.actualRetail,
    required this.closingBundle,
    required this.closingRetail,
    required this.price,
    required this.bottlePerBundle,
    required this.totalOpenRetailUnits,
    required this.totalCloseRetailUnits,
    required this.totalActualRetailUnits,
    required this.totalPriceOpening,
    required this.totalPriceClosing,
    required this.totalPriceActual,
    required this.category,
    required this.range,
    required this.size,
    required this.unscannedEntry,
    required this.checkOpeningCase,
    required this.checkOpeningBottle,
    required this.checkOpeningCaseBottle,
    required this.checkClosingCase,
    required this.checkClosingBottle,
    required this.checkClosingCaseBottle,
    required this.checkCurrentCase,
    required this.checkCurrentBottle,
    required this.checkCurrentCaseBottle,
    required this.isSynced,
  });

  factory ItemsViewModel.fromMap(Map<String, dynamic> map) {
    return ItemsViewModel(
      id: map['id'] ?? 0,
      productId: map['productId'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      brand: map['brand'] ?? '',
      itemsGroup: map['groups'] ?? '',
      openingBundle: map['openingBundle'] ?? 0,
      openingRetail: map['openingRetail'] ?? 0,
      actualBundle: map['actualBundle'] ?? 0,
      actualRetail: map['actualRetail'] ?? 0,
      closingBundle: map['closingBundle'] ?? 0,
      closingRetail: map['closingRetail'] ?? 0,
      price: map['price'] ?? 0,
      bottlePerBundle: map['bottlePerBundle'] ?? 0,
      totalOpenRetailUnits: map['totalOpenRetailUnits'] ?? 0,
      totalCloseRetailUnits: map['totalCloseRetailUnits'] ?? 0,
      totalActualRetailUnits: map['totalActualRetailUnits'] ?? 0,
      totalPriceOpening: map['totalPriceOpening'] ?? 0,
      totalPriceClosing: map['totalPriceClosing'] ?? 0,
      totalPriceActual: map['totalPriceActual'] ?? 0,
      category: map['category'] ?? '',
      range: map['range'] ?? '',
      size: map['size'] ?? '',
      unscannedEntry: map['unscannedEntry'] ?? 0,
      checkOpeningCase: map['checkOpeningCase'] ?? false,
      checkOpeningBottle: map['checkOpeningBottle'] ?? false,
      checkOpeningCaseBottle: map['checkOpeningCaseBottle'] ?? false,
      checkClosingCase: map['checkClosingCase'] ?? false,
      checkClosingBottle: map['checkClosingBottle'] ?? false,
      checkClosingCaseBottle: map['checkClosingCaseBottle'] ?? false,
      checkCurrentCase: map['checkCurrentCase'] ?? false,
      checkCurrentBottle: map['checkCurrentBottle'] ?? false,
      checkCurrentCaseBottle: map['checkCurrentCaseBottle'] ?? false,
      isSynced: map['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'phone_number': phoneNumber,
      'date': date,
      'time': time,
      'brand': brand,
      'items_group': itemsGroup,
      'opening_bundle': openingBundle,
      'opening_retail': openingRetail,
      'actual_bundle': actualBundle,
      'actual_retail': actualRetail,
      'closing_bundle': closingBundle,
      'closing_retail': closingRetail,
      'price': price,
      'bottle_per_bundle': bottlePerBundle,
      'total_open_retail_units': totalOpenRetailUnits,
      'total_close_retail_units': totalCloseRetailUnits,
      'category': category,
      'range': range,
      'size': size,
      'is_synced': isSynced,
      'total_actual_retail_units': totalActualRetailUnits,
      'total_price_opening': totalPriceOpening,
      'total_price_closing': totalPriceClosing,
      'unscanned_entry': unscannedEntry,
      'check_opening_case': checkOpeningCase,
      'check_opening_bottle': checkOpeningBottle,
      'check_opening_case_bottle': checkOpeningCaseBottle,
      'check_closing_case': checkClosingCase,
      'check_closing_bottle': checkClosingBottle,
      'check_closing_case_bottle': checkClosingCaseBottle,
      'check_current_case': checkCurrentCase,
      'check_current_bottle': checkCurrentBottle,
      'check_current_case_bottle': checkCurrentCaseBottle,
      'total_price_actual': totalPriceActual,
    };
  }
}
