import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/classes/auth_repo.dart';
import 'package:pakbazzar/minor_screen/forgot_password.dart';
import 'package:pakbazzar/widgets/auth_widgets.dart';
import 'package:pakbazzar/widgets/snackbar.dart';
import 'package:pakbazzar/widgets/yellow.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool hide = true;
  late String email;
  late String password;
  bool processing = false;
  bool sendEmailVerification = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
          processing = true;
        });
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);
        // await FirebaseAuth.instance.signInWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );
        await AuthRepo.reloadUserData();
        // await FirebaseAuth.instance.currentUser!.reload();
        if (await AuthRepo.checkEmailVerification()/*FirebaseAuth.instance.currentUser!.emailVerified*/) {
          _formKey.currentState!.reset();
          Navigator.pushReplacementNamed(context, "customer_home");
        } else {
          setState(() {
          processing = false;
          sendEmailVerification=true;
        });
          MyMessangeHandler.showSnackbar(scaffoldKey, "Please check inbox for email");
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        MyMessangeHandler.showSnackbar(scaffoldKey, "${e.message}");
      }
    } else {
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
                      SizedBox(
                        height: 50,
                        child: sendEmailVerification
                            ? Center(
                                child: YellowButton(
                                  widthRatio: 0.45,
                                  label: "Resend Email",
                                  onPressed: () async {
                                    try{
                                      AuthRepo.sendEmailVerification();
                                    }
                                    catch(e){
                                      MyMessangeHandler.showSnackbar(scaffoldKey, e.toString());
                                    }
                                    setState(() {
                                      sendEmailVerification = false;
                                    });
                                  },
                                ),
                              )
                            : const SizedBox(),
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
                            } else if (value.isValidEmail() == false) {
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
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                        },
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
                              context, "customer_signup");
                        },
                      ),
                      processing == true
                          ? const CircularProgressIndicator()
                          : AuthButton(
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

// extension EmailValidator on String {
//   bool isValidEmail() {
//     return RegExp(
//             r'^[a-zA-Z0-9]+[\_\-\.]*[a-zA-Z0-9]*[@][a-z]{2,}[\.][a-zA-Z0-9]{2,3}$')
//         .hasMatch(this);
//   }
// }
