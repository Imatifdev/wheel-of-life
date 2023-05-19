// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// class MyHomePage extends StatefulWidget {
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Map<String, dynamic>? paymentIntent;

//   void makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent();

//       var gpay = const PaymentSheetGooglePay(
//         merchantCountryCode: "US",
//         currencyCode: "USD",
//         testEnv: true,
//       );
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntent!["client_secret"],
//         style: ThemeMode.light,
//         merchantDisplayName: "Sabir",
//         googlePay: gpay,
//       ));

//       displayPaymentSheet();
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       print("Done");
//     } catch (e) {
//       print("Failed");
//     }
//   }

//   createPaymentIntent() async {
//     try {
//       Map<String, dynamic> body = {
//         "amount": "10000",
//         "currency": "USD",
//       };

//       http.Response response = await http.post(
//           Uri.parse("https://api.stripe.com/v1/payment_intents"),
//           body: body,
//           headers: {
//             "Authorization":
//                 "Bearer sk_test_51MWx8OAVMyklfe3C3gP4wKOhTsRdF6r1PYhhg1PqupXDITMrV3asj5Mmf0G5F9moPL6zNfG3juK8KHgV9XNzFPlq00wmjWwZYA",
//             "Content-Type": "application/x-www-form-urlencoded",
//           });
//       return json.decode(response.body);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Stripe Example"),
//       ),
//       body: Center(
//           child: ElevatedButton(
//               onPressed: () {
//                 makePayment();
//               },
//               child: const Text("Pay Me!"))),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String money;

  const HomeScreen({Key? key, required this.money}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('PAYMENT METHOD (STRIPE)'),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Center(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          minimumSize: const Size(250, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'STRIPE PAYMENT',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {},
      )),
    );
  }

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
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
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
                'Bearer sk_test_51N3ozXKuYtdF845oo54vweQDKUNllgiNE5EZwtO2UVMxVGQhJoysGNOZEYRrHbMtj6SNI72W58B4c50Im7IxXGKs00DASLWthd',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
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
}
