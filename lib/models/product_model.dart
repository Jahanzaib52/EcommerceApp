import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/minor_screen/edit_product.dart';
import 'package:pakbazzar/minor_screen/product_details.dart';
import 'package:pakbazzar/providers/wish_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  const ProductModel({super.key, required this.products});

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ProductDetailsScreen(
              products: widget.products,
            );
          }),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(left: 4, right: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(25),
                //Not work
                // ),
                constraints:
                    const BoxConstraints(minHeight: 100, maxHeight: 250),
                child: Stack(
                  children: [
                    Image(
                      image: NetworkImage(widget.products["prod_images"][0]),
                      fit: BoxFit.cover,
                    ),
                    widget.products["discount"] != 0
                        ? Positioned(
                            top: 20,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25))),
                              child: Text("Save upto " +
                                  widget.products["discount"].toString() +
                                  "%"),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            Text(
              widget.products["prod_name"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "\$",
                      style: TextStyle(color: Colors.red),
                    ),
                    widget.products["discount"] == 0
                        ? Text(
                            widget.products["price"].toString(),
                            style: const TextStyle(color: Colors.red),
                          )
                        : Text(
                            widget.products["price"].toString(),
                            style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                    widget.products["discount"] != 0
                        ? Text(
                            ((1 - widget.products["discount"] / 100) *
                                    widget.products["price"])
                                .toStringAsFixed(2),
                            style: const TextStyle(color: Colors.green),
                          )
                        : const SizedBox(),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    context.read<Wish>().productList.firstWhereOrNull(
                                (element) =>
                                    element.productId ==
                                    widget.products["prod_Id"]) !=
                            null
                        ? context
                            .read<Wish>()
                            .removethis(widget.products["prod_Id"])
                        : context.read<Wish>().addItems(
                              name: widget.products["prod_name"],
                              price: widget.products["discount"] == 0
                                  ? widget.products["price"]
                                  : (1 - widget.products["discount"] / 100) *
                                      widget.products["price"],
                              purcahseQty: 1,
                              instockQty: widget.products["instock"],
                              imagesUrl: widget.products["prod_images"].first,
                              productId: widget.products["prod_Id"],
                              suppId: widget.products["supplier_uid"],
                            );
                  },
                  icon: FirebaseAuth.instance.currentUser!.uid ==
                          widget.products["supplier_uid"]
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProduct(
                                          product: widget.products,
                                        )));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.red,
                          ),
                        )
                      : context.watch<Wish>().productList.firstWhereOrNull(
                                  (element) =>
                                      element.productId ==
                                      widget.products["prod_Id"]) !=
                              null
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.red,
                            ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
