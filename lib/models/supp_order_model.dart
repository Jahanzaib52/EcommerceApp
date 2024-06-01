import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class SupplierOrderModel extends StatefulWidget {
  final dynamic order;
  const SupplierOrderModel({super.key, required this.order});

  @override
  State<SupplierOrderModel> createState() => _SupplierOrderModelState();
}

class _SupplierOrderModelState extends State<SupplierOrderModel> {
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
              color: Colors.yellow.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("Name: " + widget.order["customer_name"]),
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
                //---------------------------------------------------------//
                //---------------------------------------------------------//
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
                //----------------------------------------
                Text("Order Date: " +
                    DateFormat("dd-MM-yyyy").format(widget.order["order_date"]
                        .toDate())), //widget.order["order_date"]
                widget.order["delivery_status"] == "delivered"
                    ? const Text("This order has been delivered")
                    : Row(
                        children: [
                          const Text("Change Delivery Status To: "),
                          widget.order["delivery_status"] == "prepairing"
                              ? TextButton(
                                  onPressed: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      minTime: DateTime.now(),
                                      maxTime: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      onConfirm: (date) async {
                                        await FirebaseFirestore.instance
                                            .collection("orders")
                                            .doc(
                                              widget.order["order_id"]).update({
                                                "delivery_status": "shipping",
                                                "delivery_date": date,
                                              });
                                      },
                                    );
                                  },
                                  child: const Text("Shipping?"))
                              : TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("orders")
                                        .doc(widget.order["order_id"]).update({
                                          "delivery_status": "delivered",
                                          //"delivery_date":time,
                                        });
                                  },
                                  child: const Text("Delivered?"))
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
