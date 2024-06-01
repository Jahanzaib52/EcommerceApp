import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/minor_screen/visit_store.dart';

import '../widgets/appbar_widgets.dart';

class Stores extends StatelessWidget {
  const Stores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: "Stores",
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("suppliers").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Store Yet!"),
            );
          }
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VisitStore(
                          suppId: snapshot.data!.docs[index]["supplier_uid"],
                        );
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: Image.asset("images/inapp/store.jpg"),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 28,
                          child: SizedBox(
                            width: 100,
                            height: 48,
                            child: Image.network(
                              snapshot.data!.docs[index]["profile_image"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      snapshot.data!.docs[index]["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      /*GridView.builder(
        itemCount: ,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context,index){
          return Stack(
            children: [
              Image.asset("images/inapp/store.jpg"),
            ],
          );
        },
      ),*/
    );
  }
}
