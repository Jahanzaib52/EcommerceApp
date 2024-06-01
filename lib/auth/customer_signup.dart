// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pakbazzar/classes/auth_repo.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import "package:firebase_storage/firebase_storage.dart" as f_storage;
import '../widgets/auth_widgets.dart';

class CustomerSignup extends StatefulWidget {
  const CustomerSignup({Key? key}) : super(key: key);

  @override
  State<CustomerSignup> createState() => _CustomerSignupState();
}

class _CustomerSignupState extends State<CustomerSignup> {
  bool processing =false;
  late String profileImageUrl;
  late String name;
  late String email;
  late String password;
  bool hide = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  XFile? image;
  void fromCamera() async {
    try {
      final imagePicked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        image = imagePicked;
      });
    } catch (e) {
      print(e);
    }
  }

  void fromGallery() async {
    try {
      final imagePicked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      setState(() {
        image = imagePicked;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp() async {
    setState(() {
      processing=true;
    });
    if (_formKey.currentState!.validate()) {
      if (image != null) {
        try {
          AuthRepo.signUpWithEmailAndPassword(email, password);
          // await FirebaseAuth.instance.createUserWithEmailAndPassword(
          //   email: email,
          //   password: password,
          // );
          AuthRepo.sendEmailVerification();
          // await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          try{
          f_storage.Reference reference=f_storage.FirebaseStorage.instance.ref("cust-images/$email.jpg");
          await reference.putFile(File(image!.path));
          profileImageUrl=await reference.getDownloadURL();
          }
          on FirebaseException catch(e){
            setState(() {
              processing=false;
            });
            print(e.message);
            MyMessangeHandler.showSnackbar(scaffoldKey, "${e.message}");
          }
          try{
            await FirebaseFirestore.instance.collection("customers").doc(AuthRepo.uid/*FirebaseAuth.instance.currentUser!.uid*/).set({
            "name":name,
            "email":email,
            "profile_image":profileImageUrl,
            "phone":"",
            "address":"",
            "customer_uid":AuthRepo.uid/*FirebaseAuth.instance.currentUser!.uid*/,
          });
          }
          on FirebaseException catch(e){
            setState(() {
              processing=false;
            });
            print(e.message);
          }
          _formKey.currentState!.reset();
          setState(() {
            image = null;
          });
          Navigator.pushReplacementNamed(context, "customer_login");
        }on FirebaseAuthException catch (e) {
          setState(() {
            processing=false;
          });
          MyMessangeHandler.showSnackbar(scaffoldKey,"${e.message}");
        }
      } else {
        setState(() {
          processing=false;
        });
        MyMessangeHandler.showSnackbar(scaffoldKey, "Please select an image");
      }
    } else {
      setState(() {
        processing=false;
      });
      MyMessangeHandler.showSnackbar(scaffoldKey, "Please fill empty fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: "Sign Up",
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 40,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.purple,
                              radius: 60,
                              backgroundImage: image == null
                                  ? null
                                  : FileImage(File(image!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    fromCamera();
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    fromGallery();
                                  },
                                  icon: const Icon(Icons.photo),
                                  color: Colors.white,
                                  /*onPressed
                                  Icons.photo,
                                  color: Colors.white,*/
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            name = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Full Name";
                            }
                            return null;
                          },
                          decoration: textFormDecoration,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Email";
                            } else if (value.isValidEmail() == false) {
                              return "Please Enter Valid Email";
                            } else {
                              MyMessangeHandler.showSnackbar(
                                  scaffoldKey, "Email is Valid");
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Email Address",
                            hintText: "Enter your Email",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: hide,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Password";
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                            labelText: "Password",
                            hintText: "Enter your Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hide = !hide;
                                });
                              },
                              icon: hide
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                      HaveAccount(
                        accountInfo: "already have an account? ",
                        buttonLabel: "Login",
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "customer_login");
                        },
                      ),
                      processing==true?const CircularProgressIndicator():AuthButton(
                        buttonLabel: "SignUp",
                        onPressed: () {
                          signUp();
                          /*if (_formKey.currentState!.validate()) {
                            if(image==null){
                              MyMessangeHandler.showSnackbar(scaffoldKey, "Please pick image");
                            }
                            else{
                            print("Image picked");
                            print("Valid");
                            print(name);
                            print(email);
                            print(password);
                            _formKey.currentState!.reset();
                            setState(() {
                              image=null;
                            });
                            }
                          } else {
                            MyMessangeHandler.showSnackbar(scaffoldKey,"Please fill empty fields");
                            print("Not Valid");
                          }*/
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^[a-zA-Z0-9]+[\_\-\.]*[a-zA-Z0-9]*[@][a-z]{2,}[\.][a-zA-Z0-9]{2,3}$')
        .hasMatch(this);
  }
}
