import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakbazzar/utilities/categ_list.dart';
import 'package:pakbazzar/widgets/Red.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;
import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  final dynamic product;
  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late double price;
  late int discount;
  late int quantity;
  late String productName;
  late String productDescription;
  List<XFile>? imagesFileList = [];
  List<dynamic> imageUrlList = [];

  String mainCategValue = maincateg.first;
  String subCategValue = 'subcatergory';
  List<String> subCategList = [];

  previewCurrentImages() {
    List<dynamic> imagesList = widget.product["prod_images"];
    return ListView.builder(
      itemCount: imagesList.length,
      itemBuilder: (context, index) {
        return Image.network(imagesList[index].toString());
      },
    );
  }

  previewCurrent(AsyncSnapshot snapshot) {
    List<dynamic> images = [];
    for (var image in snapshot.data.data()["prod_images"]) {
      images.add(image);
    }
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.network(images[index].toString());
      },
    );
  }

  previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
        itemCount: imagesFileList!.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(imagesFileList![index].path),
            fit: BoxFit.cover,
          );
        },
      );
    }
    return const Center(
      child: Text("You have not picked\n\nan image yet!"),
    );
  }

  
  changeImages() async {
    final List<XFile> imagesPicked = await ImagePicker().pickMultiImage(
      maxHeight: 300,
      maxWidth: 300,
      imageQuality: 95,
    );
    setState(() {
      imagesFileList = imagesPicked;
    });
  }

  

  saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await uploadImages().whenComplete(() async{
        await editProductData().whenComplete(() {
          Navigator.pop(context);
        });
      });
    } else {
      MyMessangeHandler.showSnackbar(scaffoldKey, "Please fill all fields");
    }
  }

  Future uploadImages() async {
    if (imagesFileList!.isNotEmpty) {
      for (var imagee in imagesFileList!) {
        f_storage.Reference reference = f_storage.FirebaseStorage.instance
            .ref("products/${path.basename(imagee.path)}");
        await reference.putFile(File(imagee.path)).whenComplete(() async {
          await reference.getDownloadURL().then((value) {
            imageUrlList.add(value);
          });
        });
      }
    } else {
      imageUrlList = widget.product["prod_images"];
    }
  }

  Future editProductData() async {
    if (mainCategValue != "main catergory" && subCategValue != 'subcatergory') {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("products")
            .doc(widget.product["prod_Id"]);
        transaction.update(documentReference, {
          "maincateg": mainCategValue,
          "subcateg": subCategValue,
          "price": price,
          "instock": quantity,
          "prod_name": productName,
          "prod_desc": productDescription,
          "supplier_uid": FirebaseAuth.instance.currentUser!.uid,
          "prod_images": imageUrlList,
          "discount": discount,
        });
      });
    } else {
      //Challange Answer-------------------------------------------------------
      //mainCategValue=widget.product["maincateg"];
      //subCategValue=widget.product["subcateg"];
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("products")
            .doc(widget.product["prod_Id"]);
        transaction.update(documentReference, {
          //"maincateg":mainCategValue,
          //"subcateg":subCategValue,
          "price": price,
          "instock": quantity,
          "prod_name": productName,
          "prod_desc": productDescription,
          "supplier_uid": FirebaseAuth.instance.currentUser!.uid,
          "prod_images": imageUrlList,
          "discount": discount,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("products")
            .doc(widget.product["prod_Id"])
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ScaffoldMessenger(
            key: scaffoldKey,
            child: Scaffold(
              /*appBar: AppBar(
                backgroundColor: Colors.white,
                leading: const AppBarBackButton(),
                title: const AppBarTitle(title: "Edit Product"),
              ),*/
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: formKey,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: previewCurrent(snapshot),
                            //previewCurrentImages(),
                          ),
                          Column(
                            children: [
                              const Text(
                                "* main category",
                                style: TextStyle(color: Colors.red),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Text(
                                        snapshot.data!.data()!["maincateg"])),
                              ),
                              const Text(
                                "* Subcategory",
                                style: TextStyle(color: Colors.red),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Text(
                                        snapshot.data!.data()!["subcateg"])),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ExpandablePanel(
                        theme: const ExpandableThemeData(hasIcon: false),
                        header: const Center(
                          child: Text(
                            "Change Images & Categories",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        collapsed: const SizedBox(),
                        expanded: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration:
                                      const BoxDecoration(color: Colors.grey),
                                  child: previewImages(),
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "* Select main category",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    DropdownButton(
                                      value: mainCategValue,
                                      items: maincateg
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          mainCategValue = value!;
                                          subCategValue = 'subcatergory';
                                        });
                                        if (mainCategValue ==
                                            'main catergory') {
                                          subCategList = [];
                                        } else if (mainCategValue == "men") {
                                          subCategList = men;
                                        } else if (mainCategValue == 'women') {
                                          subCategList = women;
                                        } else if (mainCategValue ==
                                            'electronics') {
                                          subCategList = electronics;
                                        } else if (value == 'accessories') {
                                          subCategList = accessories;
                                        } else if (value == "shoes") {
                                          subCategList = shoes;
                                        } else if (value == 'home & garden') {
                                          subCategList = homeandgarden;
                                        } else if (value == 'kids') {
                                          subCategList = kids;
                                        } else {
                                          subCategList = bags;
                                        }
                                      },
                                    ),
                                    const Text(
                                      "* Select Subcategory",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    DropdownButton(
                                      value: subCategValue,
                                      items: subCategList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              child: Text(e),
                                              value: e,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          subCategValue = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //const SizedBox(height: 25,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  YellowButton(
                                      widthRatio: 0.30,
                                      label: "Change",
                                      onPressed: () {
                                        changeImages();
                                      }),
                                  YellowButton(
                                      widthRatio: 0.3,
                                      label: "Reset",
                                      onPressed: () {
                                        setState(() {
                                          imagesFileList = [];
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 3,
                        color: Colors.yellow,
                      ),

                      //------------------------------------------------------------

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextFormField(
                                initialValue:
                                    widget.product["price"].toString(),
                                onSaved: (value) {
                                  price = double.parse(value!);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter price";
                                  } else if (value.isValidPrice() != true) {
                                    return "Please enter valid price";
                                  }
                                  return null;
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: textFormDecoration,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                initialValue:
                                    widget.product["discount"].toString(),
                                onSaved: (value) {
                                  discount = int.parse(value!);
                                },
                                validator: (value) {
                                  if (value!.isValidDiscount() != true) {
                                    return "Please enter valid discount";
                                  }
                                  return null;
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: textFormDecoration.copyWith(
                                  labelText: "discount",
                                  hintText: " discount...%",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            initialValue: widget.product["instock"].toString(),
                            onSaved: (value) {
                              quantity = int.parse(value!);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter quantity";
                              } else if (value.isValidQuantity() != true) {
                                return "Please enter valid quantity";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: textFormDecoration.copyWith(
                                labelText: "Quantity",
                                hintText: "Add quantity"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width*0.4,
                          child: TextFormField(
                            initialValue:
                                widget.product["prod_name"].toString(),
                            onSaved: (value) {
                              productName = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter product name";
                              }
                              return null;
                            },
                            maxLength: 100,
                            maxLines: 3,
                            decoration: textFormDecoration.copyWith(
                                labelText: "Product Name",
                                hintText: "Enter product name "),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width*0.4,
                          child: TextFormField(
                            initialValue:
                                widget.product["prod_desc"].toString(),
                            onSaved: (value) {
                              productDescription = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter product Description";
                              }
                              return null;
                            },
                            maxLength: 1000,
                            maxLines: 8,
                            decoration: textFormDecoration.copyWith(
                              labelText: "Product Description",
                              hintText: "Enter Product Description",
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          YellowButton(
                            widthRatio: 0.3,
                            label: "Cancel",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          YellowButton(
                            widthRatio: 0.4,
                            label: "Save Changes",
                            onPressed: () {
                              saveChanges();
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25,),
                        child: Center(
                          child: RedButton(
                            widthRatio: 0.5,
                            label: "Delete item",
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection("products")
                                        .doc(widget.product["prod_Id"]);
                                transaction.delete(documentReference);
                              }).whenComplete(() => Navigator.pop(context));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

var textFormDecoration = InputDecoration(
  labelText: "Price",
  hintText: "price...\$",
  //labelStyle: const TextStyle(),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.yellow,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.blueAccent,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'([1-9][0-9]*[\.]?[0-9])||([0-9][\.][0-9])$').hasMatch(this);
  }
}

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'[1-9][0-9]*$').hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'[0-9]*$').hasMatch(this);
  }
}
