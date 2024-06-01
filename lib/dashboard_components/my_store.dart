import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/minor_screen/visit_store.dart';

class MyStore extends StatefulWidget {
  const MyStore({Key? key}) : super(key: key);

  @override
  State<MyStore> createState() => _MyStoreState();
}

class _MyStoreState extends State<MyStore> {
  @override
  Widget build(BuildContext context) {
    return VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid);
    
    
    
    
    /*Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const AppBarTitle(title: "My Store"),
        leading: const AppBarBackButton(),
      ),
    );*/
  }
}