import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/statics_model.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

class SupplierStatics extends StatefulWidget {
  const SupplierStatics({Key? key}) : super(key: key);

  @override
  State<SupplierStatics> createState() => _SupplierStaticsState();
}

class _SupplierStaticsState extends State<SupplierStatics> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "SupplierStatics"),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("supplier_id",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          int totalItem = 0;
          for (var item in snapshot.data!.docs) {
            totalItem = item["order_quantity"] + totalItem;
          }
          double totalPrice = 0;
          for (var item in snapshot.data!.docs) {
            totalPrice =
                (item["order_price"] * item["order_quantity"]) + totalPrice;
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StaticsModel(
                  labelValue: snapshot.data!.docs.length,
                  digitAfterDecimal: 0,
                  label: "item count",
                ),
                StaticsModel(
                  labelValue: totalItem,
                  digitAfterDecimal: 0,
                  label: "Total Item",
                ),
                StaticsModel(
                  labelValue: totalPrice,
                  digitAfterDecimal: 2,
                  label: "Balance",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
