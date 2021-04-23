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
      "id": "ephkey_1IjMidHXAQctbbyaGtlnnHV0",
      "object": "ephemeral_key",
      "associated_objects": [
        {
          "type": "customer",
          "id": "cus_JJXJG5V5xdbZha"
        }
      ],
      "created": 1619175523,
      "expires": 1619179123,
      "livemode": false,
      "secret": "ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLDlaZnJWUE54MHR1UHA4eXNpTEdzZjVaUE44ZDNENjM_00hCgPrrwJ"
    };
 
    try {
      StripeNative.lunchStripeNative(
              publishableKey: 'pk_test_vgklWgkPbEazPYbSES86lBRk',
              clientSecret: "pi_1IjMivHXAQctbbya8LSb4mCi_secret_PJHfXIDx6q6goJH0HRpIMKOWl",
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
