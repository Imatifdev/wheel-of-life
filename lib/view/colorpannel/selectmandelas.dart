// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:com.example.wheel_of_life/models/sketchmodel.dart';
import 'package:com.example.wheel_of_life/view/library/mylibrary.dart';
import 'package:com.example.wheel_of_life/view/settings/settingsscreen.dart';
import 'package:com.example.wheel_of_life/utils/mycolors.dart';
import 'package:com.example.wheel_of_life/view/colorpannel/animal.dart';

import '../purchasedDashboard.dart';

class SelectMandelas extends StatefulWidget {
  final int package;
  final String money;

  const SelectMandelas({super.key, required this.package, required this.money});

  @override
  State<SelectMandelas> createState() => _SelectMandelasState();
}

class _SelectMandelasState extends State<SelectMandelas> {
  Map<String, dynamic>? paymentIntentData;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  payFee() {
    try {
      //if you want to upload data to any database do it here
    } catch (e) {
      // exception while uploading data
    }
  }

  Future<bool> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(
          widget.money, 'USD'); //json.decode(response.body);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});
      displayPaymentSheet();
      return true;
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
      }
      return false;
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        payFee();

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51N6W5EGatw2HfTd69z1LuUuLJrwj7MhFbZSaHQXgpzbLzt4YDVFKSA8V2X0jcd9kcWXEEyvEK5OsyJwmqmAkCrmm00lQyI5js7',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      // showDialog(
      //     context: context,
      //     builder: (_) => const AlertDialog(
      //           content: Text("Success "),
      // ));
      print(response.body);
      body = jsonDecode(response.body);
      print(body["id"]);
      // showPaymentInfo(body["id"]);
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  Future<void> showPaymentInfo(String paymentIntentId) async {
    try {
      PaymentIntent paymentIntent =
          await Stripe.instance.retrievePaymentIntent(paymentIntentId);
      String amount = (paymentIntent.amount / 100).toStringAsFixed(2);
      String currency = paymentIntent.currency.toUpperCase();
      PaymentIntentsStatus status = paymentIntent.status;

      // Display the payment information to the user
      print('Payment of $amount $currency was $status.');
    } catch (e) {
      print('Error retrieving payment information: $e');
    }
  }

  Map<String, String> _selectedImages = {};
  int itemCount = 0;
  List<String> _imageList = [
    'assets/art/2.png',
    'assets/art/3.png',
    'assets/art/4.png',
    'assets/art/5.png',
    'assets/art/6.png',
    'assets/art/7.png',
    'assets/art/8.png',
    'assets/art/9.png',
    'assets/art/12.png',
    'assets/art/11.png',
    'assets/art/2.png',
    'assets/art/3.png',
    'assets/art/4.png',
    'assets/art/5.png',
    'assets/art/6.png',
    'assets/art/7.png',
    'assets/art/8.png',
    'assets/art/9.png',
    'assets/art/12.png',
    'assets/art/2.png',
    'assets/art/3.png',
    'assets/art/4.png',
    'assets/art/5.png',
    'assets/art/6.png',
    'assets/art/7.png',
    'assets/art/8.png',
    'assets/art/9.png',
    'assets/art/12.png',
  ];
  //int package;

  void _onImageSelected(String imageUrl) {
    setState(() {
      if (_selectedImages.values.contains(imageUrl)) {
        _selectedImages.removeWhere((key, value) => value == imageUrl);
      } else {
        if (_selectedImages.length < widget.package) {
          _selectedImages.addAll({"image$itemCount": imageUrl});
          itemCount++;
        } else {
          // Show an error message or other feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have reached the maximum number of images.'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbg,
      appBar: AppBar(
        title: Text(
          "All Mandelas",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 1 / 10,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.black,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => SettingsScreen());
              },
              child: Icon(
                Icons.settings,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
        backgroundColor: appbg,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1 / 13,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [gd2, gd1],
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Get All Pictures!",
                    style: TextStyle(
                        color: appbg,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Try Premium",
                    style: TextStyle(
                        color: appbg,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          // Expanded(
          //   child: ListView(children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         SizedBox(
          //           height: MediaQuery.of(context).size.height * 1 / 30,
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 20),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "All Mandelas",
          //                 style: TextStyle(
          //                     fontSize: 20, fontWeight: FontWeight.bold),
          //               ),
          //               GestureDetector(
          //                 onTap: () {
          //                   Get.to(() => AnimalMandel());
          //                 },
          //                 child: Text(
          //                   "View More...",
          //                   style: TextStyle(
          //                       fontSize: 18,
          //                       color: gd2,
          //                       fontWeight: FontWeight.bold),
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height * 1 / 5,
          //           child: ListView.builder(
          //               itemCount: _imageList.length,
          //               scrollDirection: Axis.horizontal,
          //               itemBuilder: (context, index) {
          //                 return Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       _onImageSelected(_imageList[index]);
          //                     },
          //                     child: Stack(
          //                       children: [
          //                         Image.asset(_imageList[index]),
          //                         if (_selectedImages
          //                             .contains(_imageList[index]))
          //                           Positioned(
          //                             top: 0,
          //                             right: 0,
          //                             child: Icon(
          //                               Icons.check_circle_outline,
          //                               color: Colors.green,
          //                             ),
          //                           ),
          //                         if (!_selectedImages
          //                             .contains(_imageList[index]))
          //                           Positioned(
          //                             top: 0,
          //                             right: 0,
          //                             child: Icon(
          //                               Icons.circle_outlined,
          //                               color: Colors.red,
          //                             ),
          //                           ),
          //                       ],
          //                     ),
          //                     //  ShowGrid(
          //                     //   skectpic: UsersData.users[index],
          //                   ),
          //                 );
          //               }),
          //         ),
          //       ],
          //     ),
          //   ]),
          // ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: _imageList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _onImageSelected(_imageList[index]);
                    },
                    child: Container(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Center(child: Image.asset(_imageList[index])),
                            if (_selectedImages.values
                                .contains(_imageList[index]))
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                            if (!_selectedImages.values
                                .contains(_imageList[index]))
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Icon(
                                  Icons.circle_outlined,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    //  ShowGrid(
                    //   skectpic: UsersData.users[index],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                onPressed: () async {
                  bool check = false;
                  check = await makePayment();
                  if (check) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MyLibrary()));
                                    // Navigator.of(context).push(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             PurchasedDashboard()));
                                  },
                                  child: Text("Success")),
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                              content: Text("Cancelled "),
                            ));
                  }
                  await FirebaseFirestore.instance
                      .collection("Payment Details")
                      .doc(userId)
                      .set({
                    "Billing Date": DateTime.now(),
                    "Next Billing Date":
                        DateTime.now().add(Duration(days: 365)),
                    "Plan Name": "Ksh ${widget.money}/year",
                    "Images": _selectedImages,
                    "Payment Method": "Stripe"
                  });
                },
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Text("Done"),
                )),
          )
        ],
      ),
    );
  }
}

// class SelectMandelasGrid extends StatefulWidget {
  
//   const SelectMandelasGrid({super.key});

//   @override
//   State<SelectMandelasGrid> createState() => _SelectMandelasGridState();
// }

// class _SelectMandelasGridState extends State<SelectMandelasGrid> {
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//         itemCount: UsersData.users.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             mainAxisSpacing: 15, crossAxisSpacing: 15, crossAxisCount: 2),
//         itemBuilder: (context, index) {
//           final show = UsersData.users[index];
//           return InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailMandela(
//                       sketch: show,
//                     ),
//                   ),
//                 );
//               },
//               child: ShowGrid(sketchpic: show));
//         });
//   }
// }
// // class ShowGrid extends StatefulWidget {
// //   final SketchModel skectpic;

// //   const  ShowGrid({super.key, required this.skectpic});

// //   @override
// //   State<ShowGrid> createState() => _ShowGridState();
// // }

// // class _ShowGridState extends State<ShowGrid> {
// // List<String> _selectedImages = [];
// //   List<String> _imageList = [
// //     'assets/art/2.png',
// //     'assets/art/3.png',
// //     'assets/art/4.png',
// //     'assets/art/5.png',
// //     'assets/art/6.png',
// //     'assets/art/7.png',
// //     'assets/art/8.png',
// //     'assets/art/9.png',
// //     'assets/art/12.png',
// //     'assets/art/11.png'
// //   ];
// //   int _maxImages = 3;


// //   void _onImageSelected(String imageUrl) {
// //     setState(() {
// //       if (_selectedImages.contains(imageUrl)) {
// //         _selectedImages.remove(imageUrl);
// //       } else {
// //         if (_selectedImages.length < _maxImages) {
// //           _selectedImages.add(imageUrl);
// //         } else {
// //           // Show an error message or other feedback to the user
// //           Get.snackbar("Message","You have reached the maximum number of images.");
         
// //         }
// //       }
// //     });
// //   }

// //   @override

// //   Widget build(BuildContext context) {
// //     return
// //  GestureDetector(
// //             onTap: () {
// //               _onImageSelected(_imageLis);
// //             },
// //             child: Stack(
// //               children: [
// //                 Image.asset(_imageList[index]),
// //                 if (_selectedImages.contains(_imageList[index]))
// //                   Positioned(
// //                     bottom: 0,
// //                     right: 0,
// //                     child: Icon(
// //                       Icons.check_circle,
// //                       color: Colors.green,
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           );
// //      //  Image(
// //     //   fit: BoxFit.cover,
// //     //   height: 200,
// //     //   width: 200,
// //     //   image: AssetImage(skectpic.url),
// //     // );
// //   }
// // }
