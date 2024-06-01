import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/customer_screens/add_address.dart';
import 'package:pakbazzar/customer_screens/address_book.dart';
import 'package:pakbazzar/minor_screen/payment_screen.dart';
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  late dynamic dt;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("customers")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("address")
            .where("default", isEqualTo: true)
            .limit(1)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          /*if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> dt =
              snapshot.data!.data() as Map<String, dynamic>;*/
          /*late Map<String, dynamic> dt;
          /*var data=*/ snapshot.data!.docs.map((DocumentSnapshot document) {
            /*Map<String,dynamic> */ dt =
                document.data()! as Map<String, dynamic>;
          });*/
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              leading: const AppBarBackButton(),
              title: const Text("Place Order"),
            ),
            body: Column(
              children: [
                GestureDetector(
                  onTap: snapshot.data!.docs.isEmpty
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddAddress()));
                        }
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddressBook()));
                        },
                  child: snapshot.data!.docs.isEmpty
                      ? Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            // border: Border.all(
                            //   width: 2,
                            // ),
                          ),
                          child: const Center(
                            child: Text("Set Your Address"),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            // border: Border.all(
                            //   width: 2,
                            // ),
                          ),
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                dt = snapshot.data!.docs[index];
                                return ListTile(
                                  title: SizedBox(
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: " +
                                              dt["first_name"] +
                                              " " +
                                              dt["last_name"],
                                          style: const TextStyle(
                                              //fontSize: 18,
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          "Phone: " +
                                              dt["phone_number"].toString(),
                                          style: const TextStyle(
                                              //fontSize: 18,
                                              //fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        // Text(
                                        //   "Address: " + dt["country"]+", "+dt["state"]+", "+dt["city"],
                                        //   style: const TextStyle(
                                        //     //fontSize: 18,
                                        //     //fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  subtitle: SizedBox(
                                    height: 50,
                                    child: Text(
                                      "Address: " +
                                          dt["country"] +
                                          ", " +
                                          dt["state"] +
                                          ", " +
                                          dt["city"],
                                      style: const TextStyle(
                                          //fontSize: 18,
                                          //fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Consumer<Cart>(
                      builder: (context, cart, child) {
                        return ListView.builder(
                          itemCount: cart.productList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(8),
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 1),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      cart.productList[index].imagesUrl,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          cart.productList[index].name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
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
                                            Text(
                                              "x " +
                                                  cart.productList[index]
                                                      .purcahseQty
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: YellowButton(
              widthRatio: 0.8,
              label: "Confirm " +
                  context.read<Cart>().totalPrice.toStringAsFixed(2) +
                  " \$",
              onPressed: snapshot.data!.docs.isEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressBook(),
                        ),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            name: dt["first_name"] + " " + dt["last_name"],
                            phone: dt["phone_number"].toString(),
                            address: dt["country"] +
                                ", " +
                                dt["state"] +
                                ", " +
                                dt["city"],
                          ),
                        ),
                      );
                    },
            ),
          );
        });
  }
  //);
}
//}
