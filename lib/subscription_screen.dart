import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String email = "";
  String phone = "";
  Timestamp dateOfPayment = Timestamp(152, 5);
  Timestamp nextDate = Timestamp(152, 5);
  String plan = "";
  String paymentMethod = "";
  Map images = {};
  int check = 0;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  void getPaymentInfo() async {
    var collection = FirebaseFirestore.instance.collection('Payment Details');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      print("ok");
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        dateOfPayment = data?["Billing Date"];
        nextDate = data?["Next Billing Date"];
        plan = data?["Plan Name"];
        paymentMethod = data?["Payment Method"];
        images = data?["Images"];
      });
    }
  }

  void getUserInfo() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        email = data?["Email"];
        phone = data?["Phone"];
      });
    }
  }

  void getInfo() {
    getPaymentInfo();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getInfo());
      check++;
    }
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              children: const [
                BackButton(color: Colors.black),
                Text(
                  "Subscription",
                  style: TextStyle(fontSize: 24),
                )
              ],
            ),
            SizedBox(
              width: 300,
              height: 500,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Membership & Billing",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Email: $email"),
                        const Text("Password: *****"),
                        Text("Phone: $phone"),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Billing Details",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            "Next Billing Date: ${nextDate.toDate().year}-${nextDate.toDate().month}-${nextDate.toDate().day}"),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Plan: $plan"),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Payment Mode",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("$paymentMethod")
                      ]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
