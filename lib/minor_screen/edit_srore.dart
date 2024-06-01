import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({super.key, required this.data});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String storeName;
  late String storePhone;

  XFile? imageFileLogo;
  pickimageFileLogo() async {
    try {
      final XFile? imagePicked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        imageFileLogo = imagePicked;
      });
    } catch (e) {
      print(e);
    }
  }

  XFile? imageFileCover;
  pickimageFileCover() async {
    try {
      final XFile? imagePicked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        imageFileCover = imagePicked;
      });
    } catch (e) {
      print(e);
    }
  }

  //-------------------------------------------------------------------------
  bool processing = false;
  saveChanges() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        processing = true;
      });
      formKey.currentState!.save();
      await uploadStoreLogo().whenComplete(() async => await uploadCoverImage()
          .whenComplete(() async => await editStoreData()));
    } else {
      MyMessangeHandler.showSnackbar(scaffoldKey, "Please fill empty fields");
    }
  }

  late String storeLogo;
  Future<void> uploadStoreLogo() async {
    if (imageFileLogo != null) {
      f_storage.Reference reference = f_storage.FirebaseStorage.instance
          .ref("supp-images/${widget.data["email"]}.jpg");
      await reference.putFile(File(imageFileLogo!.path));
      storeLogo = await reference.getDownloadURL();
    } else {
      storeLogo = widget.data["profile_image"];
    }
  }

  late String coverImage;
  Future<void> uploadCoverImage() async {
    if (imageFileCover != null) {
      f_storage.Reference reference = f_storage.FirebaseStorage.instance
          .ref("supp-images/${widget.data["email"]}.jpg-cover");
      await reference.putFile(File(imageFileCover!.path));
      coverImage = await reference.getDownloadURL();
    } else {
      coverImage = widget.data["cover_image"];
    }
  }

  editStoreData() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("suppliers")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        "name": storeName,
        "phone": storePhone,
        "profile_image": storeLogo,
        "cover_image": coverImage,
      });
    }).whenComplete(
      () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
          title: const AppBarTitle(
            title: "Edit Store",
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const Text(
                "Store Logo",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.data["profile_image"]),
                  ),
                  Column(
                    children: [
                      YellowButton(
                        widthRatio: 0.25,
                        label: "Change",
                        onPressed: () {
                          pickimageFileLogo();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      imageFileLogo == null
                          ? const SizedBox()
                          : YellowButton(
                              widthRatio: 0.25,
                              label: "Reset",
                              onPressed: () {
                                setState(() {
                                  imageFileLogo = null;
                                });
                              },
                            ),
                    ],
                  ),
                  imageFileLogo == null
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(imageFileLogo!.path)),
                        ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 3,
                color: Colors.yellow,
                indent: 20,
              ),

              //-------------------------------------------

              const Text(
                "Cover Image",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.data["cover_image"] == ""?
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("images/inapp/coverimage.jpg",),
                    ):
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.data["cover_image"]),
                  ),
                  Column(
                    children: [
                      YellowButton(
                        widthRatio: 0.25,
                        label: "Change",
                        onPressed: () {
                          pickimageFileCover();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      imageFileCover == null
                          ? const SizedBox()
                          : YellowButton(
                              widthRatio: 0.25,
                              label: "Reset",
                              onPressed: () {
                                setState(() {
                                  imageFileCover = null;
                                });
                              },
                            ),
                    ],
                  ),
                  imageFileCover == null
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(
                            File(imageFileCover!.path),
                          ),
                        ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 3,
                color: Colors.yellow,
                indent: 20,
              ),

              //--------------------------------------------------------------

              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        initialValue: widget.data["name"],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter store name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          storeName = value!;
                        },
                        decoration: InputDecoration(
                          label: const Text("Store Name"),
                          hintText: "Store Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 1,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        initialValue: widget.data["phone"],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter phone number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          storePhone = value!;
                        },
                        decoration: InputDecoration(
                          label: const Text("Phone"),
                          hintText: "Phone",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 1,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurple,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //-----------------------------------------------------------

              Padding(
                padding: const EdgeInsets.all(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    YellowButton(
                        widthRatio: 0.25,
                        label: "Cancel",
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    YellowButton(
                        widthRatio: 0.4,
                        label: processing==false?"Save Changes":"Please wait...",
                        onPressed: processing==false?() {
                          saveChanges();
                        }:() => null),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
