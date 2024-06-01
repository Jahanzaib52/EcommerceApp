import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakbazzar/utilities/categ_list.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import "package:firebase_storage/firebase_storage.dart" as f_storage;
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late double price;
  late int quantity;
  late String productName;
  late String productDescription;
  int? discount=0;

  bool processing=false;

  String mainCategValue = maincateg.first;
  List subCategList = [];
  String subCategValue = 'subcatergory';

  List<String> imageUrlList = [];
  late String prodId;
  uploadProduct() async {
    if (mainCategValue != 'main catergory' && subCategValue != 'subcatergory') {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imagesFileList!.isNotEmpty) {
          setState(() {
            processing=true;
          });

            for (var image in imagesFileList!) {
              f_storage.Reference reference = f_storage.FirebaseStorage.instance
                  .ref("products/${p.basename(image.path)}");
              await reference.putFile(File(image.path)).whenComplete(() async {
                await reference.getDownloadURL().then((value) {
                  imageUrlList.add(value);
                });
              });
            }
          prodId=const Uuid().v4();
          await FirebaseFirestore.instance.collection("products").doc(prodId).set({
            "prod_Id":prodId,
            "maincateg":mainCategValue,
            "subcateg":subCategValue,
            "price":price,
            "instock":quantity,
            "prod_name":productName,
            "prod_desc":productDescription,
            "supplier_uid":FirebaseAuth.instance.currentUser!.uid,
            "prod_images":imageUrlList,
            "discount":discount,
          });

          _formKey.currentState!.reset();
          setState(() {
            imagesFileList = [];
            mainCategValue = maincateg.first;
            //subCategValue = 'subcatergory';
            subCategList=[];
            imageUrlList=[];
            processing=false;
          });
        } else {
          MyMessangeHandler.showSnackbar(
              scaffoldKey, "Please pick image first");
        }
      } else {
        MyMessangeHandler.showSnackbar(scaffoldKey, "Please fill empty fields");
      }
    } else {
      MyMessangeHandler.showSnackbar(scaffoldKey, "Please select categories");
    }
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imagesFileList = [];
  pickProductImages() async {
      final imagesPicked = await imagePicker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        imagesFileList = imagesPicked;
      });
    }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
        itemCount: imagesFileList!.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(imagesFileList![index].path),
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          "You have not\n\nPicked image yet!",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.blueGrey.shade100,
                        child: previewImages(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "* Select main category",
                            style: TextStyle(color: Colors.red),
                          ),
                          DropdownButton(
                            iconSize: 30,
                            iconEnabledColor: Colors.red,
                            dropdownColor: Colors.yellow.shade400,
                            menuMaxHeight: 400,
                            value: mainCategValue,
                            items: maincateg
                                .map<DropdownMenuItem<String>>((element) {
                              return DropdownMenuItem(
                                child: Text(element),
                                value: element,
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == 'main catergory') {
                                subCategList = [];
                              } else if (value == "men") {
                                subCategList = men;
                              } else if (value == 'women') {
                                subCategList = women;
                              } else if (value == 'electronics') {
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
                              setState(() {
                                mainCategValue = value!;
                                subCategValue = 'subcatergory';
                              });
                            },
                          ),
                          const Text(
                            "* Select Subcategory",
                            style: TextStyle(color: Colors.red),
                          ),
                          DropdownButton(
                            iconSize: 30,
                            iconEnabledColor: Colors.red,
                            iconDisabledColor: Colors.black,
                            dropdownColor: Colors.yellow.shade400,
                            menuMaxHeight: 400,
                            disabledHint: const Text("select subcategory"),
                            value: subCategValue,
                            items: subCategList
                                .map<DropdownMenuItem<String>>((element) {
                              return DropdownMenuItem(
                                child: Text(element),
                                value: element,
                              );
                            }).toList(),
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
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: textFormDecoration,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: TextFormField(
                            maxLength: 2,
                            onSaved: (value){
                              if(value!.isEmpty){
                                discount=0;
                              }
                              else{
                                discount=int.parse(value);
                              }
                              //discount=int.parse(value)??0;
                            },
                            validator: (value){
                              // if(value!.isEmpty){
                              //   return null;
                              // }
                              /*else */if(value?.isValidDiscount()==false){
                                return "Please enter valid discount";
                              }
                              return null;
                            },
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                            labelText: "Quantity", hintText: "Add quantity"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      //width: MediaQuery.of(context).size.width*0.4,
                      child: TextFormField(
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
                        onSaved: (value) {
                          productDescription = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter product name";
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
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FloatingActionButton(
                onPressed: imagesFileList!.isEmpty
                    ? () {
                        pickProductImages();
                      }
                    : () {
                        setState(() {
                          imagesFileList = [];
                        });
                      },
                backgroundColor: Colors.yellow,
                child: imagesFileList!.isEmpty
                    ? const Icon(
                        Icons.photo_library,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
              ),
            ),
            FloatingActionButton(
              onPressed: processing==true? null: () {
                uploadProduct();
              },
              backgroundColor: Colors.yellow,
              child: processing==true? const CircularProgressIndicator(color: Colors.black,): const Icon(
                Icons.upload,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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

extension DiscountValidator on String{
  bool isValidDiscount(){
    return RegExp(r'[0-9]*$').hasMatch(this);
  }
}