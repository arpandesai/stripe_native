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
      "id": "ephkey_1Ij0PWHXAQctbbyatzwoebSJ",
      "object": "ephemeral_key",
      "associated_objects": [
        {
          "type": "customer",
          "id": "cus_JJXJG5V5xdbZha"
        }
      ],
      "created": 1619089770,
      "expires": 1619093370,
      "livemode": false,
      "secret": "ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLElkaU5lTk5GRzFXNW1kZzBBaHRuTHdSNTlCcW5nc0w_00gc25sb0N"
    };
 
    try {
      StripeNative.lunchStripeNative(
              publishableKey: 'pk_test_vgklWgkPbEazPYbSES86lBRk',
              clientSecret: "pi_1Ij0PjHXAQctbbya2BAbxVb9_secret_VXrqhxHoNnZwF551OWeEZYJIH",
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
