import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/main_screen/stores.dart';
import 'package:pakbazzar/main_screen/upload_product.dart';
import 'package:badges/badges.dart' as badges;

import 'category.dart';
import 'dashboard.dart';
import 'home.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = const [
    HomeScreen(),
    CategoryScreen(),
    Stores(),
    DashboardScreen(),
    UploadProductScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("supplier_id",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where("delivery_status", isEqualTo: "prepairing")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          return Scaffold(
            body: tabs[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Category",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shop),
                  label: "Stores",
                ),
                BottomNavigationBarItem(
                  icon: badges.Badge(
                    showBadge: snapshot.data!.docs.isEmpty ? false : true,
                    badgeContent: Text(snapshot.data!.docs.length.toString()),
                    child: const Icon(Icons.dashboard),
                  ),
                  label: "Dashboard",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.upload),
                  label: "Upload",
                ),
              ],
            ),
          );
        });
  }
}
