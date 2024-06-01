import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pakbazzar/minor_screen/edit_srore.dart';
import 'package:pakbazzar/models/product_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({super.key, required this.suppId});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool follow = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("suppliers")
          .doc(widget.suppId)
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //To Update
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              toolbarHeight: 100,
              flexibleSpace: data["cover_image"] == ""?Image.asset(
                "images/inapp/coverimage.jpg",
                fit: BoxFit.cover,
              ):
              Image.network(data["cover_image"],
              fit: BoxFit.cover,),
              title: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.yellow,
                        ),
                        borderRadius: BorderRadius.circular(6)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        data["profile_image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                data["name"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              follow = !follow;
                            });
                          },
                          child: Container(
                            height: 25,
                            width: 90,
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(6)),
                            child: FirebaseAuth.instance.currentUser!.uid ==
                                    data["supplier_uid"]
                                ? MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditStore(
                                            data: data,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Edit",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(Icons.edit),
                                      ],
                                    ),
                                  )
                                : Text(
                                    follow == true ? "Follow" : "Following",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where("supplier_uid", isEqualTo: widget.suppId)
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
                      "This Store Has\n\nNo Product Yet!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        //color: Colors.black,
                      ),
                    ),
                  );
                }
                return StaggeredGridView.countBuilder(
                  itemCount: snapshot.data!.docs.length,
                  crossAxisCount: 2,
                  staggeredTileBuilder: (index) {
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
            floatingActionButton: ClipOval(
              child: MaterialButton(
                color: Colors.green,
                shape: const CircleBorder(),
                child: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 50,
                ),
                onPressed: () {},
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}
