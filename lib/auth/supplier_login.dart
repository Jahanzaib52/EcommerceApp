import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/auth/customer_signup.dart';
import 'package:pakbazzar/widgets/auth_widgets.dart';
import 'package:pakbazzar/widgets/snackbar.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({super.key});

  @override
  State<SupplierLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<SupplierLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool hide = true;
  late String email;
  late String password;
  bool processing = false;

  Future<void> login() async {
    setState(() {
      processing = true;
    });
    if(_formKey.currentState!.validate()){
      try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _formKey.currentState!.reset();
    Navigator.pushReplacementNamed(context, "supplier_home");
    }
    on FirebaseAuthException catch(e){
      setState(() {
        processing=false;
      });
      MyMessangeHandler.showSnackbar(scaffoldKey, "${e.message}");
    }
    }
    else{
      setState(() {
        processing=false;
      });
      MyMessangeHandler.showSnackbar(scaffoldKey, "Please fill all fields");
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
                      const AuthHeaderLabel(headerLabel: "Login"),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Email Address";
                            } else if (value.isValidEmail()==false) {
                              return "Please Enter Valid Email";
                            } else {
                              MyMessangeHandler.showSnackbar(
                                  scaffoldKey, "Email is valid");
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Email Address",
                            hintText: "Enter Your Email Address",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          obscureText: hide,
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Password";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: "Password",
                            hintText: "Enter Your Password",
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
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      HaveAccount(
                        accountInfo: "Don't have an account",
                        buttonLabel: "SignUp",
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "supplier_signup");
                        },
                      ),
                      processing==true?const CircularProgressIndicator():AuthButton(
                        buttonLabel: "Login",
                        onPressed: () {
                          login();
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
