import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  const PaymentScreen({super.key,required this.name,required this.phone,required this.address});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  void showProgress(){
    ProgressDialog progressDialog=ProgressDialog(context: context);
    progressDialog.show(msg: "Please wait...");
  }
  @override
  Widget build(BuildContext context) {
    double priceToBePaid = context.read<Cart>().totalPrice + 10;
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(
            child: Text("Document does not exists"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> dt =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              leading: const AppBarBackButton(),
              title: const Text("Payment"),
            ),
            body: Column(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            priceToBePaid.toStringAsFixed(2) + " USD",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 3,
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("subtotal"),
                          Text(context
                                  .read<Cart>()
                                  .totalPrice
                                  .toStringAsFixed(2) +
                              " USD"),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Shipment Cost"), Text("10.00  USD")],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      RadioListTile(
                        title: const Text(
                          "Cash on Delivery",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text("Pay Cash On Arival"),
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text(
                          "Pay via Visa/Master Card",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                FontAwesomeIcons.ccMastercard,
                                color: Colors.blue,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.ccVisa,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        value: 2,
                        groupValue: selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: const Text(
                          "Pay via Paypal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Row(
                          children: [
                            //Icon(Icons.paypal),
                            Icon(
                              FontAwesomeIcons.paypal,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.ccPaypal,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        value: 3,
                        groupValue: selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomSheet: YellowButton(
              widthRatio: 1,
              label: "Confirm " + priceToBePaid.toStringAsFixed(2) + " \$",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    if (selectedValue == 1) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Pay at Home $priceToBePaid",
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            YellowButton(
                              widthRatio: 0.8,
                              label: "Confirm " +
                                  priceToBePaid.toStringAsFixed(2) +
                                  " \$",
                              onPressed: () async {
                                showProgress();
                                for (var item
                                    in context.read<Cart>().productList) {
                                  orderId = const Uuid().v4();
                                  await FirebaseFirestore.instance
                                      .collection("orders")
                                      .doc(orderId)
                                      .set({
                                    "customer_uid": dt["customer_uid"],
                                    "customer_name": widget.name,
                                    "customer_email": dt["email"],
                                    "customer_address": widget.address,
                                    "customer_phone": widget.phone,
                                    "customer_profile_image":
                                        dt["profile_image"],
                                    "supplier_id": item.suppId,
                                    "product_id": item.productId,
                                    "order_name":item.name,
                                    "order_id": orderId,
                                    "order_image": item.imagesUrl,
                                    "order_quantity": item.purcahseQty,
                                    "order_price":
                                        item.purcahseQty * item.price,
                                    "delivery_status": "prepairing",
                                    "delivery_date": "",
                                    "order_date": DateTime.now(),
                                    "payment_status": "Cash on delivery",
                                    "order_review": false,
                                  }).whenComplete(() async{
                                    DocumentReference ref=FirebaseFirestore.instance.collection("products").doc(item.productId);
                                  FirebaseFirestore.instance.runTransaction((transaction) async{
                                    DocumentSnapshot snapshot=await transaction.get(ref);
                                    if(!snapshot.exists){
                                      throw Exception("Document does not exists");
                                    }
                                    int newInstockQty=snapshot["instock"]-item.purcahseQty;
                                    transaction.update(ref, {"instock":newInstockQty});
                                    return newInstockQty;
                                  }).whenComplete(() {
                                    context.read<Cart>().clearCart();
                                  }).whenComplete(() => Navigator.popUntil(context, ModalRoute.withName("customer_home")));
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (selectedValue == 2) {
                      print("Visa/MasterCard");
                    } else if (selectedValue == 3) {
                      print("Pay via Paypal");
                    }
                    return const Text("123");
                  },
                );
              },
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
