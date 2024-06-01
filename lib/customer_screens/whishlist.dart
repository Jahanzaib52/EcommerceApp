import 'package:flutter/material.dart';
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/providers/wish_provider.dart';
import 'package:pakbazzar/widgets/alert_dialog.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

class WhishlistScreen extends StatefulWidget {
  const WhishlistScreen({Key? key}) : super(key: key);

  @override
  State<WhishlistScreen> createState() => _WhishlistScreenState();
}

class _WhishlistScreenState extends State<WhishlistScreen> {
  /*final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();*/
      @override
  // void initState() {
  //   context.read<Wish>().loadProductsInWishlist();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "WhishlistScreen"),
        leading: const AppBarBackButton(),
        actions: [
          context.watch<Wish>().productList.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                      context: context,
                      title: "Clear Wishlist",
                      content: "Are you sure you want to clear wishlist items?",
                      onTabNo: (){
                        Navigator.pop(context);
                      },
                      onTabYes: (){
                        context.read<Wish>().clearWishlist();
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
        ],
      ),
      body: context.watch<Wish>().productList.isEmpty? const EmptyWhishlist():const WishItems(),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Wish>(
      builder: (context, wish, child) {
        return ListView.builder(
          itemCount: wish.count,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(5),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Image.network(
                      wish.productList[index].imagesUrl,
                      height: 100,
                      width: 120,
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            wish.productList[index].name,
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
                                    wish.productList[index].price
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  onPressed: () {
                                    wish.removeItem(wish.productList[index]);
                                  },
                                  icon: const Icon(Icons.delete_forever)),
                              IconButton(
                                  onPressed: () async{
                                    wish
                                                  .productList[index]
                                                  .instockQty==0? null:
                                    context
                                                .read<Cart>()
                                                .productList
                                                .firstWhereOrNull((element) =>
                                                    element.productId ==
                                                    wish.productList[index]
                                                        .productId) !=
                                            null
                                        ? null
                                        : await context.read<Cart>().addItems(
                                              name: wish
                                                  .productList[index].name,
                                              price: wish
                                                  .productList[index].price,
                                              purcahseQty: 1,
                                              instockQty: wish
                                                  .productList[index]
                                                  .instockQty,
                                              imagesUrl: wish
                                                  .productList[index]
                                                  .imagesUrl,
                                              producttId: wish
                                                  .productList[index]
                                                  .productId,
                                              suppId: wish
                                                  .productList[index].suppId,
                                            );
                                            wish.removeItem(wish.productList[index]);
                                  },
                                  icon: wish
                                                  .productList[index]
                                                  .instockQty==0
                                      ? const SizedBox()
                                      : const Icon(Icons.shopping_cart)),
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


class EmptyWhishlist extends StatelessWidget {
  const EmptyWhishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
            "Your Wishlist is Empty!",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
    );
  }
}
