import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HotDealsScreen extends StatefulWidget {
  final int maxDiscount;
  const HotDealsScreen({super.key, required this.maxDiscount});

  @override
  State<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends State<HotDealsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser != null) {
              Navigator.pushReplacementNamed(context, "customer_home");
            } else {
              Navigator.pushReplacementNamed(context, "welcome_screen");
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.yellow,
          ),
        ),
        title: SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30.0,
              color: Colors.yellow,
            ),
            child: AnimatedTextKit(
              totalRepeatCount: 5,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Hot Deals',
                  speed: const Duration(milliseconds: 100),
                  cursor: "|",
                ),
                TypewriterAnimatedText(
                  'Up to ${widget.maxDiscount} % off',
                  speed: const Duration(milliseconds: 100),
                  cursor: "|",
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("products")
              .where("discount", isGreaterThan: 0)
              .orderBy("discount", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No Discount on Products Yet!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }
            return StaggeredGridView.countBuilder(
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 8,
              staggeredTileBuilder: (int index) {
                return const StaggeredTile.fit(1);
              },
              itemBuilder: (context, index) {
                return ProductModel(
                  products: snapshot.data!.docs[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
