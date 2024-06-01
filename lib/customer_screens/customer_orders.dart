import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/cust_order_model.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "Orders"),
        leading: const AppBarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("orders").where("customer_uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text("Something went wrong."),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              return CustomerOrderModel(order: snapshot.data!.docs[index]);
            }),
          );
        },
      ),
    );
  }
}