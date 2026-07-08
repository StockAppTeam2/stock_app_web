class BrandModel {
  int? id;
  String date;
  String time;
  int productId;
  String brand;
  String category;
  String size;
  String groups;
  String range;
  int price;
  int bottlePerBundle;
  int isSynced;
  int isActive;
  double buyingPrice;

  BrandModel({
    this.id,
    required this.date,
    required this.time,
    required this.productId,
    required this.brand,
    required this.category,
    required this.size,
    required this.groups,
    required this.range,
    required this.price,
    required this.bottlePerBundle,
    required this.isSynced,
    required this.isActive,
    required this.buyingPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'productId': productId,
      'brand': brand,
      'category': category,
      'size': size,
      'groups': groups,
      'range': range,
      'price': price,
      'bottlePerBundle': bottlePerBundle,
      'isSynced': isSynced,
      'isActive': isActive,
      'buyingPrice': buyingPrice,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      productId: map['productId'],
      brand: map['brand'],
      category: map['category'],
      size: map['size'],
      groups: map['groups'],
      range: map['range'],
      price: map['price'],
      bottlePerBundle: map['bottlePerBundle'],
      isSynced: map['isSynced'],
      isActive: map['isActive'],
      buyingPrice: (map['buyingPrice'] as num).toDouble(),
    );
  }
}
