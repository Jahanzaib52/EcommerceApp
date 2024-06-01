import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pakbazzar/widgets/yellow.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  late double rate;
  late String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.yellow),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        iconColor: Colors.blue,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              constraints: const BoxConstraints(maxHeight: 80, maxWidth: 80),
              child: Image.network(
                widget.order["order_image"],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.order["order_name"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$ " + widget.order["order_price"].toStringAsFixed(2),
                        style: const TextStyle(color: Colors.red),
                      ),
                      Text("x " + widget.order["order_quantity"].toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "see more...",
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              widget.order["delivery_status"],
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              //border: Border.all(width: 2,color: Colors.yellow),
              color: widget.order["delivery_status"] == "delivered"
                  ? Colors.brown.withOpacity(0.2)
                  : Colors.yellow.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: " + widget.order["customer_name"]),
                Text("Phone No: " + widget.order["customer_phone"]),
                Text("Email: " + widget.order["customer_email"]),
                Text("Address: " + widget.order["customer_address"]),
                // Text("Payment Status: " +
                //     snapshot.data!.docs[index]["payment_status"],style: TextStyle(color: Colors.purple),),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                    text: "Payment Status: ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: widget.order["payment_status"],
                    style: const TextStyle(color: Colors.purple),
                  ),
                ])),
                // Text("Delivery Status: " +
                //     snapshot.data!.docs[index]["delivery_status"],style: TextStyle(color: Colors.green),),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                    text: "Delivery Status: ",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: widget.order["delivery_status"],
                    style: const TextStyle(color: Colors.green),
                  ),
                ])),
                widget.order["delivery_status"] == "shipping"
                    ? Text(
                        "Est. Delivery Date: " +
                            DateFormat("dd-MM-yyyy").format(widget
                                .order["delivery_date"]
                                .toDate()), //widget.order["delivery_date"]
                      )
                    : const Text(""),
                widget.order["delivery_status"] == "delivered" &&
                        widget.order["order_review"] == false
                    ? TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Material(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RatingBar.builder(
                                          itemCount: 5,
                                          initialRating: 0,
                                          minRating: 1,
                                          allowHalfRating: true,
                                          direction: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            );
                                          },
                                          onRatingUpdate: (value) {
                                            rate = value;
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 100,
                                          ),
                                          child: TextField(
                                            onChanged: (value) {
                                              comment = value;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: const BorderSide(
                                                  color: Colors.purple,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                borderSide: const BorderSide(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            YellowButton(
                                              widthRatio: 0.3,
                                              label: "Cancel",
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            YellowButton(
                                              widthRatio: 0.3,
                                              label: "OK",
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection("products")
                                                    .doc(widget
                                                        .order["product_id"])
                                                    .collection("reviews")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .set({
                                                      "name": widget.order[
                                                          "customer_name"],
                                                      "email": widget.order[
                                                          "customer_email"],
                                                      "rate": rate,
                                                      "comment": comment,
                                                      "profile_image": widget
                                                              .order[
                                                          "customer_profile_image"],
                                                    })
                                                    .whenComplete(() =>
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "orders")
                                                            .doc(widget.order[
                                                                "order_id"]).update({"order_review":true}))
                                                    .whenComplete(() =>
                                                        Navigator.pop(context));
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                        child: const Text(
                          "Write Review",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    : const Text(""),
                widget.order["delivery_status"] == "delivered" &&
                        widget.order["order_review"] == true
                    ? const Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.blue,
                          ),
                          Text(
                            "Review Added",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      )
                    : const Text(""),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
