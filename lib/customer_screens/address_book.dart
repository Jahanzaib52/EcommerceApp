import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/customer_screens/add_address.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({super.key});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  Future<void> dfAddressFalse(dynamic eachAddress) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("address")
          .doc(eachAddress["address_id"]);
      transaction.update(documentReference, {
        "default": false,
      });
    });
  }

  Future<void> dfAddressTrue(dynamic data) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("address")
          .doc(data["address_id"]);
      transaction.update(documentReference, {
        "default": true,
      });
    });
  }

  Future<void> updateProfile(dynamic data) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        "address": data["country"] + "-" + data["state"] + "-" + data["city"],
        "phone": data["phone_number"],
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: const AppBarTitle(title: "Address Book"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("customers")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("address")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Saved no Address Yet!"));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () async {
                        ProgressDialog pd = ProgressDialog(context: context);
                        pd.show(msg: "Please Wait...");
                        for (var eachAddress in snapshot.data!.docs) {
                          await dfAddressFalse(eachAddress);
                        }
                        await dfAddressTrue(data).whenComplete(
                          () async => await updateProfile(data)
                              .whenComplete(() => pd.close()),
                        );
                      },
                      child: Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) async =>
                            await FirebaseFirestore.instance.runTransaction(
                          (transaction) async {
                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection("customers")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("address")
                                    .doc(data["address_id"]);
                                    transaction.delete(documentReference);
                          },
                        ),
                        child: Card(
                          color: data["default"] == true
                              ? Colors.yellow
                              : Colors.white,
                          child: ListTile(
                            //tileColor: Colors.white,
                            title: Text(
                                data["first_name"] + " " + data["last_name"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data["phone_number"]),
                                Text(data["country"] +
                                    ", " +
                                    data["state"] +
                                    ", " +
                                    data["city"]),
                              ],
                            ),
                            trailing: data["default"] == true
                                ? const Icon(Icons.home)
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          YellowButton(
            widthRatio: 0.5,
            label: "Add New Address",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAddress(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
