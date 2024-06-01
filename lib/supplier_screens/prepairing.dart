import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/supp_order_model.dart';

class Prepairing extends StatelessWidget {
  const Prepairing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("supplier_id",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("delivery_status", isEqualTo: "prepairing")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text("Something went wrong."),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("You don't have an\n\n Active Order yet!."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              return SupplierOrderModel(order: snapshot.data!.docs[index]);
            }),
          );
        },
      ),
    );
  }
}
