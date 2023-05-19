import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePayment3 extends StatefulWidget {
  static const routeName = "stripe-pay";
  const StripePayment3({super.key});

  @override
  State<StripePayment3> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment3> {
  bool payCheck = false;
  Map<String, dynamic>? paymentIntentData;
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
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
      print(response.body);
      body = jsonDecode(response.body);
      print(body["id"]);
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
        throw Exception(err.toString());
      }
    }
  }

  void displayPaymentSheet() async {
    print("test 4 passed");
    try {
      print("test 5 passed");
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        print("test 6 passed");
        // payFee();
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
      });
      print("test 7 passed");
    } on StripeException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(content: Text("Cancelled")));
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  Future<bool> makePayment() async {
    print("test 1 passed");
    try {
      paymentIntentData =
          await createPaymentIntent("200", "USD"); //json.decode(response.body);
      print("test 2 passed");
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});
      print("test 3 passed");
      displayPaymentSheet();
      print("test 8 passed");
      return true;
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Stripe Payment"),
            ElevatedButton(
                onPressed: () async {
                  print("hehhe");
                  await makePayment();
                  print("hohoho");
                },
                child: Text("Pay"))
          ]),
    );
  }
}
