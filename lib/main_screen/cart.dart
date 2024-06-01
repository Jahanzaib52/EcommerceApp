import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakbazzar/minor_screen/place_order.dart';
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/providers/wish_provider.dart';
import 'package:pakbazzar/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../widgets/appbar_widgets.dart';
import '../widgets/yellow.dart';

class CartScreen extends StatefulWidget {
  final Widget? button;
  const CartScreen({
    Key? key,
    this.button,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey.shade200,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: widget.button,
            //leading: const AppBarBackButton(),
            title: const AppBarTitle(
              title: "Cart",
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                      context: context,
                      title: "Clear Cart",
                      content: "Are you sure to clear cart?",
                      onTabNo: () {
                        Navigator.pop(context);
                      },
                      onTabYes: () {
                        Navigator.pop(context);
                        context.read<Cart>().clearCart();
                      },
                    );
                  },
                  icon: context.watch<Cart>().productList.isEmpty
                      ? const SizedBox()
                      : const Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ))
            ],
          ),
          body: context.watch<Cart>().productList.isNotEmpty
              ? const CartItems()
              : const EmptyCart(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Total: \$ ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      context.read<Cart>().totalPrice.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                YellowButton(
                  widthRatio: 0.45,
                  label: "Check Out",
                  onPressed: context.watch<Cart>().productList.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlaceOrderScreen(),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your CartScreen is Empty!",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, "customer_home");
              },
              minWidth: MediaQuery.of(context).size.width * 0.6,
              child: const Text(
                "Continue Shopping",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(5),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 120,
                      child: Image.network(
                        cart.productList[index].imagesUrl,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            cart.productList[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "USD " +
                                    cart.productList[index].price
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              //SizedBox(width: 50,),
                              Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed:
                                            cart.productList[index]
                                                        .purcahseQty ==
                                                    1
                                                ? () {
                                                    showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoActionSheet(
                                                          title: const Text(
                                                              "RemoveItem"),
                                                          message: const Text(
                                                              "Are you sure to Delete/Move to WhishList"),
                                                          actions: [
                                                            CupertinoActionSheetAction(
                                                              onPressed:
                                                                  () async {
                                                                context.read<Wish>().productList.firstWhereOrNull((element) =>
                                                                            element.productId ==
                                                                            cart
                                                                                .productList[
                                                                                    index]
                                                                                .productId) !=
                                                                        null
                                                                    ? null
                                                                    : await context
                                                                        .read<
                                                                            Wish>()
                                                                        .addItems(
                                                                          name: cart
                                                                              .productList[index]
                                                                              .name,
                                                                          price: cart
                                                                              .productList[index]
                                                                              .price,
                                                                          purcahseQty: cart
                                                                              .productList[index]
                                                                              .purcahseQty,
                                                                          instockQty: cart
                                                                              .productList[index]
                                                                              .instockQty,
                                                                          imagesUrl: cart
                                                                              .productList[index]
                                                                              .imagesUrl,
                                                                          productId: cart
                                                                              .productList[index]
                                                                              .productId,
                                                                          suppId: cart
                                                                              .productList[index]
                                                                              .suppId,
                                                                        );
                                                                cart.removeProduct(
                                                                    cart.productList[
                                                                        index]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Move to Wishlist"),
                                                            ),
                                                            CupertinoActionSheetAction(
                                                              onPressed: () {
                                                                cart.removeProduct(
                                                                    cart.productList[
                                                                        index]);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Delete Item"),
                                                            ),
                                                          ],
                                                          cancelButton:
                                                              TextButton(
                                                            child: const Text(
                                                                "Cancel"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    /*cart.removeProduct(
                                                    cart.productList[index]);*/
                                                  }
                                                : () {
                                                    cart.decrement(cart
                                                        .productList[index]);
                                                  },
                                        icon: cart.productList[index]
                                                    .purcahseQty ==
                                                1
                                            ? const Icon(
                                                Icons.delete_forever,
                                                size: 20,
                                              )
                                            : const Icon(
                                                FontAwesomeIcons.minus,
                                                size: 20,
                                              )),
                                    Text(
                                      cart.productList[index].purcahseQty
                                          .toString(),
                                      style: cart.productList[index]
                                                  .purcahseQty ==
                                              cart.productList[index].instockQty
                                          ? const TextStyle(
                                              fontSize: 20, color: Colors.red)
                                          : const TextStyle(
                                              fontSize: 20,
                                            ),
                                    ),
                                    IconButton(
                                        onPressed: cart.productList[index]
                                                    .purcahseQty ==
                                                cart.productList[index]
                                                    .instockQty
                                            ? null
                                            : () {
                                                cart.increment(
                                                    cart.productList[index]);
                                              },
                                        icon: const Icon(
                                          FontAwesomeIcons.plus,
                                          size: 20,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
