import 'package:flutter/material.dart';
import 'package:pakbazzar/providers/product_class.dart';
import 'package:pakbazzar/providers/sql_helper.dart';

class Wish extends ChangeNotifier {
  List<Product> _list = [];
  List<Product> get productList {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  Future<void> addItems({
    required String name,
    required double price,
    required int purcahseQty,
    required int instockQty,
    required String imagesUrl,
    required String productId,
    required String suppId,
  }) async {
    final Product product = Product(
      name: name,
      price: price,
      purcahseQty: purcahseQty,
      instockQty: instockQty,
      imagesUrl: imagesUrl,
      productId: productId,
      suppId: suppId,
    );
    await SQLHelper.createProductInWhishlist(product)
        .whenComplete(() => _list.add(product));
    notifyListeners();
  }

  void loadProductsInWishlist() async {
    _list = await SQLHelper.readProductInWhishlist().then(
      (list) => list
          .map(
            (product) => Product(
              productId: product["productId"],
              name: product["name"],
              price: product["price"],
              purcahseQty: product["purchaseQty"],
              instockQty: product["instockQty"],
              imagesUrl: product["imagesUrl"],
              suppId: product["suppId"],
            ),
          )
          .toList(),
    );
    notifyListeners();
  }

  void removeItem(Product product) async {
    await SQLHelper.deleteProductInWhishlist(product)
        .whenComplete(() => _list.remove(product));
    notifyListeners();
  }

  void clearWishlist() async {
    await SQLHelper.clearWhishlist().whenComplete(() => _list.clear());
    notifyListeners();
  }

  void removethis(String productId) async {
    await SQLHelper.deleteThisProductInWhishlist(productId).whenComplete(
      () => _list.removeWhere((element) => element.productId == productId),
    );
    notifyListeners();
  }
}
