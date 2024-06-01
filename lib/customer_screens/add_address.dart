import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:uuid/uuid.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String firstName;
  late String lastName;
  late String phoneNumber;
  late String countryValue;
  late String stateValue;
  late String cityValue;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
          title: const AppBarTitle(title: "Add Address"),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please write first name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    firstName = value!;
                  },
                  decoration: txtFormDecoration,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please write last name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    lastName = value!;
                  },
                  decoration: txtFormDecoration.copyWith(
                    label: const Text("Last Name"),
                    hintText: "Last Name",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please write phone number";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    phoneNumber = value!;
                  },
                  decoration: txtFormDecoration.copyWith(
                      label: const Text("Phone Number"),
                      hintText: "Enter Phone Number"),
                ),
                SelectState(
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    stateValue = value;
                  },
                  onCityChanged: (value) {
                    cityValue = value;
                  },
                ),
                YellowButton(
                  widthRatio: 0.5,
                  label: "Add in AddressBook",
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (countryValue != "Choose Country" &&
                          stateValue != "Choose State" &&
                          cityValue != "Choose City") {
                            formKey.currentState!.save();
                            var addressId=const Uuid().v4();
                            FirebaseFirestore.instance
                        .collection("customers")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("address")
                        .doc(addressId).set({
                          "address_id":addressId,
                          "first_name":firstName,
                          "last_name":lastName,
                          "phone_number":phoneNumber,
                          "country":countryValue,
                          "state":stateValue,
                          "city":cityValue,
                          "default":false,
                        }).whenComplete(() => Navigator.pop(context));
                          }
                          else{
                            MyMessangeHandler.showSnackbar(
                          scaffoldKey, "Please select lacation");
                          }
                    } else {
                      MyMessangeHandler.showSnackbar(
                          scaffoldKey, "Please fill empty fields");
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var txtFormDecoration = InputDecoration(
  label: const Text("First Name"),
  hintText: "First Name",
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.purple,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.deepPurpleAccent,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(25),
  ),
);
