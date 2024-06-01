import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:pakbazzar/main_screen/cart.dart';
import 'package:pakbazzar/minor_screen/edit_product.dart';
import 'package:pakbazzar/minor_screen/full_screen_view.dart';
import 'package:pakbazzar/minor_screen/visit_store.dart';
import 'package:pakbazzar/models/product_model.dart';
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/providers/wish_provider.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailsScreen extends StatefulWidget {
  final dynamic products;
  const ProductDetailsScreen({super.key, required this.products});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
      late List<dynamic> imagesUrlList=widget.products["prod_images"];
  //late double avgRating;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FullScreenView(
                              imagesList: widget.products["prod_images"],
                            );
                          },
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Swiper(
                            control: const SwiperControl(),
                            pagination: const SwiperPagination(
                              margin: EdgeInsets.all(5),
                              builder: SwiperPagination.rect,
                            ),
                            itemCount: widget.products["prod_images"].length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                  widget.products["prod_images"][index]);
                            },
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.products["prod_name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                              : const Text(""),
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
                                        : (1 -
                                                widget.products["discount"] /
                                                    100) *
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
                            : context
                                        .watch<Wish>()
                                        .productList
                                        .firstWhereOrNull((element) =>
                                            element.productId ==
                                            widget.products["prod_Id"]) !=
                                    null
                                ? const Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_border_outlined,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                      ),
                    ],
                  ),
                  widget.products["instock"] == 0
                      ? const Text("this item is out of stock")
                      : Text(
                          "${widget.products["instock"]} pieces available in stock",
                        ),
                  const ProDetailHeader(
                    label: "Items Description",
                  ),
                  Text(
                    widget.products["prod_desc"],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Stack(
                    children: [
                      ExpandablePanel(
                        header: const Text(
                          "Reviews",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        expanded: allReviews(FirebaseFirestore.instance
                            .collection("products")
                            .doc(widget.products["prod_Id"])
                            .collection("reviews")
                            .snapshots()),
                        //--------------------------------------------------------
                        collapsed: SizedBox(
                          height: 230,
                          child: allReviews(FirebaseFirestore.instance
                              .collection("products")
                              .doc(widget.products["prod_Id"])
                              .collection("reviews")
                              .snapshots()),
                        ),
                      ),
                      //--------------------------------------------------------
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("products")
                              .doc(widget.products["prod_Id"])
                              .collection("reviews")
                              .snapshots(),
                          builder: (context, snapshot3) {
                            double avg() {
                              double sumOfRatings = 0.0;
                              for (var review in snapshot3.data!.docs) {
                                sumOfRatings = review["rate"] + sumOfRatings;
                              }
                              int noOfReviews = snapshot3.data!.docs.length;
                              return sumOfRatings / noOfReviews;
                            }

                            return Positioned(
                              right: 25,
                              top: 10,
                              child: Row(
                                children: [
                                  snapshot3.connectionState ==
                                          ConnectionState.waiting
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          snapshot3.data!.docs.isNotEmpty
                                              ? avg().toStringAsFixed(1)
                                              : "0.0",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                  //----------------------------------------------------------------------
                  //---------------------------------------------------------------------
                  const ProDetailHeader(label: "Similar Items"),
                  SizedBox(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .where(
                            "maincateg",
                            isEqualTo: widget.products["maincateg"],
                          )
                          .where("subcateg",
                              isEqualTo: widget.products[
                                  "subcateg"]) //.where("prod_Id",isNotEqualTo: widget.products["prod_Id"])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Something went wrong"));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              "This Category Has\n\nNo Other Item Yet!",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 8,
                            staggeredTileBuilder: (int index) {
                              return const StaggeredTile.fit(1);
                            },
                            itemBuilder: (context, index) {
                              return ProductModel(
                                products: snapshot.data!.docs[index],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VisitStore(
                        suppId: widget.products["supplier_uid"],
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.store),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: badges.Badge(
                showBadge:
                    context.watch<Cart>().productList.isEmpty ? false : true,
                badgeContent:
                    Text(context.watch<Cart>().productList.length.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
            YellowButton(
                widthRatio: 0.55,
                label: context.read<Cart>().productList.firstWhereOrNull(
                            (product) =>
                                product.productId ==
                                widget.products["prod_Id"]) !=
                        null
                    ? "Added in Cart "
                    : "Add to Cart ",
                onPressed: () {
                  widget.products["instock"] == 0
                      ? MyMessangeHandler.showSnackbar(
                          scaffoldKey, "this item is out of stock")
                      : context.read<Cart>().productList.firstWhereOrNull(
                                  (product) =>
                                      product.productId ==
                                      widget.products["prod_Id"]) !=
                              null
                          ? MyMessangeHandler.showSnackbar(
                              scaffoldKey, "Product already exists in cart")
                          : context.read<Cart>().addItems(
                                name: widget.products["prod_name"],
                                price: widget.products["discount"] == 0
                                    ? widget.products["price"]
                                    : (1 - widget.products["discount"] / 100) *
                                        widget.products["price"],
                                purcahseQty: 1,
                                instockQty: widget.products["instock"],
                                imagesUrl: imagesUrlList.first,//widget.products["prod_images"],
                                producttId: widget.products["prod_Id"],
                                suppId: widget.products["supplier_uid"],
                              );
                }),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> allReviews(
      Stream<QuerySnapshot<Map<String, dynamic>>> reviewStream) {
    return StreamBuilder(
        stream: reviewStream,
        builder: (context, snapshot2) {
          if (snapshot2.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot2.data!.docs.isEmpty) {
            return const Center(child: Text("No reviews yet!"));
          }

          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot2.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]["profile_image"],
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot2.data!.docs[index]["name"]),
                      Row(
                        children: [
                          Text(snapshot2.data!.docs[index]["rate"]
                              .toStringAsFixed(1)),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Text(snapshot2.data!.docs[index]["comment"]),
                );
              });
        });
  }
}

class ProDetailHeader extends StatelessWidget {
  final String label;
  const ProDetailHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
          child: Divider(
            thickness: 3,
            height: 50,
            color: Colors.yellow.shade900,
          ),
        ),
        Text(
          "  " + label + "  ",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.yellow.shade900),
        ),
        SizedBox(
          width: 50,
          child:
              Divider(thickness: 3, height: 50, color: Colors.yellow.shade900),
        ),
      ],
    );
  }
}
