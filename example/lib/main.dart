import 'package:flutter/material.dart';
import 'package:stripe_native/stripe_native.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stripe Plugin'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: lunchStripe,
            child: Text('Lunch Stripe'),
          ),
        ),
      ),
    );
  }

  void lunchStripe() {
    var ephemera = {
      "id": "ephkey_1IjJhTHXAQctbbyaPlFZz3gK",
      "object": "ephemeral_key",
      "associated_objects": [
        {
          "type": "customer",
          "id": "cus_JJXJG5V5xdbZha"
        }
      ],
      "created": 1619163919,
      "expires": 1619167519,
      "livemode": false,
      "secret": "ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLE1xdHQ1RkRad1VYU2daQkx3Z1ZXNlJPWFJjMGJHUmU_002c3Ebmu1"
    };
 
    try {
      StripeNative.lunchStripeNative(
              publishableKey: 'pk_test_vgklWgkPbEazPYbSES86lBRk',
              clientSecret: "pi_1IjJhfHXAQctbbyaWYO6sNdL_secret_g57Hxnimxvu3pS3Fh6xiIDuHT",
              ephemeralKeyResponse: ephemera)
          .then((value) {
        print('flutter response');
        print(value);
      });
    } catch (e) {
      print(e.toString());
      // throw e;
    }
  }
}
