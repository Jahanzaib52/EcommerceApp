import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pakbazzar/classes/auth_repo.dart';
import 'package:pakbazzar/customer_screens/address_book.dart';
import 'package:pakbazzar/customer_screens/customer_orders.dart';
import 'package:pakbazzar/customer_screens/whishlist.dart';
import 'package:pakbazzar/main_screen/cart.dart';
import 'package:pakbazzar/minor_screen/change_password.dart';
import 'package:pakbazzar/widgets/alert_dialog.dart';
import 'package:pakbazzar/widgets/appbar_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  userAddress(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return "country-state-city";
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data["address"] == "") {
      return "Set your Address";
    }
    return data["address"];
  }

  userPhone(dynamic data) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return data["phone"];
    } else if (FirebaseAuth.instance.currentUser!.isAnonymous == false &&
        data["phone"] == "") {
      return "Set your Phone Number";
    }
    return data["phone"];
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(
          const Duration(seconds: 1),
          () {
            setState(() {});
          },
        );
      },
      child: FutureBuilder(
        future: FirebaseAuth.instance.currentUser!.isAnonymous == false
            ? FirebaseFirestore.instance
                .collection("customers")
                .doc(widget.documentId)
                .get()
            : FirebaseFirestore.instance
                .collection("anonymous")
                .doc(widget.documentId)
                .get(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("Document does not exist"));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic>  data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 140,
                    //floating: true,
                    pinned: true,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          title: AnimatedOpacity(
                            opacity: constraints.biggest.height <= 120 ? 1 : 0,
                            duration: const Duration(seconds: 3),
                            child: const Text(
                              "Account",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          background: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.brown],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                children: [
                                  data["profile_image"] == ""
                                      ? const CircleAvatar(
                                          radius: 35,
                                          backgroundImage: AssetImage(
                                              "images/inapp/guest.jpg"),
                                        )
                                      : CircleAvatar(
                                          radius: 35,
                                          backgroundImage: NetworkImage(
                                              data["profile_image"]),
                                        ),
                                  /*const CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage("images/inapp/guest.jpg"),
                            ),*/
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                      data["name"].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow,
                                    Colors.brown,
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 80,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CartScreen(
                                                button: AppBarBackButton(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Center(
                                            child: Text(
                                              "Cart",
                                              style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CustomerOrders()));
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Center(
                                            child: Text(
                                              "Orders",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          bottomRight: Radius.circular(30),
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WhishlistScreen()));
                                        },
                                        child: SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Center(
                                            child: Text(
                                              "Whishlist",
                                              style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 150,
                          child: Image(
                            image: AssetImage("images/inapp/logo.jpg"),
                          ),
                        ),
                        const ProfileHeaderLabel(
                          headerLabel: "  Account Info.  ",
                        ),
                        Container(
                          height: 250,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.email),
                                title: const Text("Email Address"),
                                subtitle: Text(data["email"]),
                              ),
                              const GreyDivider(),
                              ListTile(
                                leading: const Icon(Icons.phone),
                                title: const Text("Phone Number"),
                                subtitle: Text(userPhone(data)),
                              ),
                              const GreyDivider(),
                              //------------------------------------------------------------
                              ListTile(
                                leading: const Icon(Icons.location_pin),
                                title: const Text("Address"),
                                subtitle: Text(userAddress(data)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddressBook(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const ProfileHeaderLabel(
                            headerLabel: "  Account Settings  "),
                        Container(
                          height: 250,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ListTile(
                                onTap: () {},
                                leading: const Icon(Icons.edit),
                                title: const Text("Edit Profile"),
                              ),
                              const GreyDivider(),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePassword(),
                                    ),
                                  );
                                },
                                leading: const Icon(Icons.lock),
                                title: const Text("Change Password"),
                              ),
                              const GreyDivider(),
                              ListTile(
                                onTap: () async {
                                  MyAlertDialog.showMyDialog(
                                    context: context,
                                    title: "Logout",
                                    content: "Are you sure you want to logout",
                                    onTabNo: () {
                                      Navigator.pop(context);
                                    },
                                    onTabYes: () async {
                                      Navigator.pop(context);
                                      await AuthRepo.logout();
                                      //await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacementNamed(
                                          context, "welcome_screen");
                                    },
                                  );
                                },
                                leading: const Icon(Icons.logout),
                                title: const Text("Log Out"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
          );
        },
      ),
    );
  }
}

class GreyDivider extends StatelessWidget {
  const GreyDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 40,
      ),
      child: Divider(
        color: Colors.grey,
        thickness: 1,
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
