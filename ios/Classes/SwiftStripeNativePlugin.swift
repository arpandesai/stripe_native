import Flutter
import UIKit
import Stripe

public class SwiftStripeNativePlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "stripe_native", binaryMessenger: registrar.messenger())
    let instance = SwiftStripeNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    
    
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method.elementsEqual("stripe_init")){
    
     
        result("iOS " + UIDevice.current.systemVersion)
    }else if(call.method.elementsEqual("lunch_stripe")){
         customerContext = STPCustomerContext(keyProvider: MyAPIClient())
        
        STPPaymentContext(customerContext: customerContext)

    }else{
        result(FlutterMethodNotImplemented)
    }
    
  
    
}



    
    
class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {

        func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
            
            
            let json: [String: Any] = [
                "id": "ephkey_1IfMUTHXAQctbbyaYDNdhDgZ",
                "object": "ephemeral_key",
                "transfer": [
                    "type": "customer",
                    "id": "cus_JHtC2X0rfDtOc6"
                ],
                "created": 1618221333,
                "expires": 1618224933,
                "livemode": false,
                "secret": "ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLHNMOHg4cUNhY1I2d25RZE43azlXWFVtaHRiTGh6blQ_00ApvOMxYd"
            ]
            
          
            completion(json, nil);
            
        
        }
    
}

