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
      "id": "ephkey_1J5TSvHXAQctbbyaTDLHbLup",
      "object": "ephemeral_key",
      "associated_objects": [
        {
          "type": "customer",
          "id": "cus_JivJtGz2K4SOcR"
        }
      ],
      "created": 1624444673,
      "expires": 1624448273,
      "livemode": false,
      "secret": "ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLHNMWnBJc3VLa2tKQ2ZHcnB5eHp3QWNVRnEzVDRnbXQ_006pGeKHkg"
    };
 
    try {
      StripeNative.lunchStripeNative(
              publishableKey: 'pk_test_vgklWgkPbEazPYbSES86lBRk',
              clientSecret: "pi_1J5TTDHXAQctbbyaM2i2aTcW_secret_LsBMa0xLOD1rYTXb7HlxxF3cP",
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
