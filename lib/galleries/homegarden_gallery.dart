import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HomeGardenGalleryScreen extends StatefulWidget {
  const HomeGardenGalleryScreen({super.key});

  @override
  State<HomeGardenGalleryScreen> createState() => _HomeGardenGalleryScreenState();
}

class _HomeGardenGalleryScreenState extends State<HomeGardenGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("products")
          .where("maincateg", isEqualTo: "home & garden")
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
    );
  }
}