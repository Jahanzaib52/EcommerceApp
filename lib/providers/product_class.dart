class Product {
  String productId;
  String name;
  double price;
  int purcahseQty;
  int instockQty;
  String imagesUrl;
  String suppId;
  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.purcahseQty,
    required this.instockQty,
    required this.imagesUrl,
    required this.suppId,
  });
  Map<String,dynamic> toMap(){
    return{
      "productId":productId,
      "name":name,
      "price":price,
      "purchaseQty":purcahseQty,
      "instockQty":instockQty,
      "imagesUrl":imagesUrl,
      "suppId":suppId
    };
  }
}