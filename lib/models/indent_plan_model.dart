class IndentPlanModel {
  final int id;
  final int productId;

  final String brand;
  final String range;
  final String size;
  final int price;

  final String brandGroups;
  final String brandCategory;

  final int totalActualRetailUnits;
  final int totalSalesRetailUnits;
  final int totalCloseRetailUnits;
  final int totalPriceSales;

  IndentPlanModel({
    required this.id,
    required this.productId,
    required this.brand,
    required this.range,
    required this.size,
    required this.price,
    required this.brandGroups,
    required this.brandCategory,
    required this.totalActualRetailUnits,
    required this.totalSalesRetailUnits,
    required this.totalCloseRetailUnits,
    required this.totalPriceSales,
  });

  factory IndentPlanModel.fromMap(Map<String, dynamic> map) {
    return IndentPlanModel(
      id: (map['sales_id'] ?? 0) as int,
      productId: (map['sales_productId'] ?? 0) as int,

      brand: (map['brand_brand'] ?? '') as String,
      range: (map['brand_range'] ?? '') as String,
      size: (map['brand_size'] ?? '') as String,

      price: (map['brand_price'] ?? 0) as int,

      brandGroups: (map['brand_groups'] ?? '') as String,
      brandCategory: (map['brand_category'] ?? '') as String,

      totalActualRetailUnits: (map['items_totalActualRetailUnits'] ?? 0) as int,

      totalSalesRetailUnits: (map['sales_totalSalesRetailUnits'] ?? 0) as int,

      totalCloseRetailUnits: (map['items_totalCloseRetailUnits'] ?? 0) as int,

      totalPriceSales: (map['sales_totalPriceSales'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sales_id': id,
      'sales_productId': productId,
      'brand_brand': brand,
      'brand_range': range,
      'brand_size': size,
      'brand_price': price,
      'brand_groups': brandGroups,
      'brand_category': brandCategory,
      'items_totalActualRetailUnits': totalActualRetailUnits,
      'sales_totalSalesRetailUnits': totalSalesRetailUnits,
      'items_totalCloseRetailUnits': totalCloseRetailUnits,
      'sales_totalPriceSales': totalPriceSales,
    };
  }
}
