import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StripeNative {
  static const MethodChannel _channel = const MethodChannel('stripe_native');

  static Future<dynamic> lunchStripeNative(
      {@required String clientSecret,
      @required String publishableKey,
      @required Map<String, dynamic> ephemeralKeyResponse}) async {
    try {
      dynamic response = await _channel.invokeMethod('lunch_stripe', {
        'publishableKey': publishableKey,
        'ephemeralKey': ephemeralKeyResponse,
        'clientSecret': clientSecret,
      });

      return response;
    } catch (e) {
      throw e;
    }
  }
}
