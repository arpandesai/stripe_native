import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
      "id": "ephkey_1IgR4eHXAQctbbyagOGthEKm",
      "object": "ephemeral_key",
      "associated_objects": [
        {"type": "customer", "id": "cus_JIziQakRLkTwq5"}
      ],
      "created": 1618477280,
      "expires": 1618480880,
      "livemode": false,
      "secret":
          "ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLDZkaVNHdGtUeHBoTWN5cjc1UFBZRTdLNkRqdUFHV0w_00OBEv39lg"
    };
    try {
      StripeNative.lunchStripeNative(
              publishableKey: 'pk_test_vgklWgkPbEazPYbSES86lBRk',
              clientSecret:
                  "pi_1IgR4yHXAQctbbyazpZA4ZH1_secret_4XXxFDci97Oc3brhdBZdq18WB",
              ephemeralKeyResponse: ephemera.toString())
          .then((value) {
        print('flutter response');
        print(jsonDecode(value));
      });
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
