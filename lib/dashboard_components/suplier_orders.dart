import 'package:flutter/material.dart';
import 'package:pakbazzar/supplier_screens/delivered.dart';
import 'package:pakbazzar/supplier_screens/prepairing.dart';
import 'package:pakbazzar/supplier_screens/shipping.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const AppBarTitle(title: "Orders"),
          leading: const AppBarBackButton(),
          bottom: const TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 6,
            tabs: [
              Tab(
                child: Text("Prepairing"),
              ),
              Tab(
                child: Text("Shipping"),
              ),
              Tab(
                child: Text("Delivered"),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Prepairing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}
