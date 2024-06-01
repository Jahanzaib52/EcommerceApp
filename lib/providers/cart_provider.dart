import 'package:flutter/material.dart';
import 'package:pakbazzar/providers/product_class.dart';
import 'package:pakbazzar/providers/sql_helper.dart';

class Cart extends ChangeNotifier {
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
    required String producttId,
    required String suppId,
  }) async {
    final Product product = Product(
      name: name,
      price: price,
      purcahseQty: purcahseQty,
      instockQty: instockQty,
      imagesUrl: imagesUrl,
      productId: producttId,
      suppId: suppId,
    );
    await SQLHelper.createProductInCart(product)
        .whenComplete(() => _list.add(product));
    notifyListeners();
  }

  void loadProductsInCart() async {
    _list = await SQLHelper.readProductInCart().then(
      (list) => list.map(
        (product) => Product(
          productId: product["productId"],
          name: product["name"],
          price: product["price"],
          purcahseQty: product["purchaseQty"],
          instockQty: product["instockQty"],
          imagesUrl: product["imagesUrl"],
          suppId: product["suppId"],
        ),
      ).toList(),
    );
    notifyListeners();
  }

  void increment(Product product) async {
    await SQLHelper.updateQty(product, "increment")
        .whenComplete(() => product.purcahseQty++);
    notifyListeners();
  }

  void decrement(Product product) async {
    await SQLHelper.updateQty(product, "reduce")
        .whenComplete(() => product.purcahseQty--);
    notifyListeners();
  }

  void removeProduct(Product product) async {
    await SQLHelper.deleteProductInCart(product)
        .whenComplete(() => productList.remove(product));
    notifyListeners();
  }

  void clearCart() async {
    await SQLHelper.clearCart().whenComplete(() => productList.clear());
    notifyListeners();
  }

  double get totalPrice {
    double totalPrice = 0.0;
    for (var item in productList) {
      double price = item.price * item.purcahseQty;
      totalPrice = totalPrice + price;
    }
    return totalPrice;
  }
}
