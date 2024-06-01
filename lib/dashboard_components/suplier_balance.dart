import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/statics_model.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/yellow.dart';

class SupplierBalance extends StatefulWidget {
  const SupplierBalance({Key? key}) : super(key: key);

  @override
  State<SupplierBalance> createState() => _SupplierBalanceState();
}

class _SupplierBalanceState extends State<SupplierBalance> {

double totalPrice(List orderList) {
    double price = 0.0;
    for (var item in orderList) {
      price = (item["order_price"] * item["order_quantity"]) + price;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "SupplierBalance"),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orders").where("supplier_id",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StaticsModel(
                  labelValue: totalPrice(snapshot.data!.docs),
                  digitAfterDecimal: 2,
                  label: "balance",
                ),
                const SizedBox(
                  height: 50,
                ),
                YellowButton(
                  widthRatio: 0.55,
                  label: "Get My Money",
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
