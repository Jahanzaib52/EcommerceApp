import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/main_screen/profile.dart';
import 'package:pakbazzar/main_screen/stores.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pakbazzar/providers/cart_provider.dart';
import 'package:pakbazzar/providers/wish_provider.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
import 'category.dart';
import 'home.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const Stores(),
    const CartScreen(),
    ProfileScreen(documentId: FirebaseAuth.instance.currentUser!.uid),
  ];
  @override
  void initState() {
    context.read<Cart>().loadProductsInCart();
    context.read<Wish>().loadProductsInWishlist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        //elevation: 0,
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
              showBadge: context.watch<Cart>().productList.isEmpty? false:true,
              badgeContent: Text(context.watch<Cart>().productList.length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            label: "Cart",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
