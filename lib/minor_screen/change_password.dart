import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/classes/auth_repo.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import 'package:pakbazzar/widgets/yellow.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool checkPassword = true;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const AppBarBackButton(),
          title: const AppBarTitle(title: "Change Password"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "to change password please\nfill in the form below\nand click save changes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: oldPasswordController,
                    decoration: txtDecoration.copyWith(
                      errorText: checkPassword != true
                          ? " Password not match with previous password"
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: newPasswordController,
                    decoration: txtDecoration.copyWith(
                        label: const Text("New Password"),
                        hintText: "Enter new Password"),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field is empty";
                      } else if (value != newPasswordController.text) {
                        return "Password not matching";
                      }
                      return null;
                    },
                    decoration: txtDecoration.copyWith(
                        label: const Text("Repeat Password"),
                        hintText: "Enter new Password again"),
                  ),
                  const SizedBox(height: 10,),
                  FlutterPwValidator(
                    width: 400,
                    height: 150,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    //lowercaseCharCount: 2,
                    numericCharCount: 1,
                    specialCharCount: 1,
                    onSuccess: () {},
                    onFail: () {},
                    controller: newPasswordController,
                  ),
                  YellowButton(
                    widthRatio: 0.5,
                    label: "Save Changes",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        checkPassword = await AuthRepo.checkOldPassword(
                          FirebaseAuth.instance.currentUser!.email,
                          oldPasswordController.text,
                        );
                        setState(() {});
                        checkPassword == true
                            ? await AuthRepo.updateUserPassword(
                                    newPasswordController.text)
                                .whenComplete(() {
                                formKey.currentState!.reset();
                                oldPasswordController.clear();
                                newPasswordController.clear();
                                MyMessangeHandler.showSnackbar(
                                    scaffoldKey, "Password Updated");
                                Future.delayed(const Duration(seconds: 3))
                                    .whenComplete(() => Navigator.pop(context));
                              })
                            : MyMessangeHandler.showSnackbar(
                                    scaffoldKey, "Password not Updated");
                      }
                      else{
                        MyMessangeHandler.showSnackbar(
                                    scaffoldKey, "Please fill fields");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var txtDecoration = InputDecoration(
  label: const Text("Old Password"),
  hintText: "Enter Previous Password",
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
