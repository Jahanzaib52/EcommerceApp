import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../widgets/appbar_widgets.dart';

// ignore: must_be_immutable
class SubCategProducts extends StatefulWidget {
  final String subCategName;
  final String maincategName;
  bool? fromonBoarding;
  SubCategProducts({
    Key? key,
    required this.subCategName,
    required this.maincategName,
    this.fromonBoarding = false,
  }) : super(key: key);

  @override
  State<SubCategProducts> createState() => _SubCategProductsState();
}

class _SubCategProductsState extends State<SubCategProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: widget.fromonBoarding == false
              ? const AppBarBackButton()
              : IconButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.pushReplacementNamed(context, "customer_home");
                    } else {
                      Navigator.pushReplacementNamed(context, "welcome_screen");
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
          title: AppBarTitle(title: widget.subCategName),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("products")
              .where("maincateg", isEqualTo: widget.maincategName)
              .where("subcateg", isEqualTo: widget.subCategName)
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
                  "This Category Has\n\nNo Product Yet!",
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
        ));
  }
}
