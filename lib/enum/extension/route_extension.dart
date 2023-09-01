import 'package:kuyumcu_stok/enum/routes.dart';

extension ToName on Routes {
  String get nameDefinition {
    switch (this) {
      case Routes.homeScreen:
        return '/home-screen';
      case Routes.goldProductsInventoryScreen:
        return '/gold-products-inventory-screen';
      case Routes.goldProductAddScreen:
        return '/gold-product-add-screen';
      case Routes.goldProductEntriesScreen:
        return '/gold-product-entries-screen';
      case Routes.goldSaleScreen:
        return '/gold-sale-screen';
    }
  }
}