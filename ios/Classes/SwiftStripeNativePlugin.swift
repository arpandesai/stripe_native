import Flutter
import UIKit
import Stripe

public class SwiftStripeNativePlugin: NSObject, FlutterPlugin {
   
    
    
    var flutterResults : FlutterResult!
    var delegate : StripeDelegate!

    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "stripe_native", binaryMessenger: registrar.messenger())
    let instance = SwiftStripeNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

  }
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   
    self.flutterResults=result;
    if(call.method.elementsEqual("lunch_stripe")){
        let args = call.arguments as? Dictionary<String,Any>
        setUpStripe(args: args!);
    }
    else{
        result(FlutterMethodNotImplemented)
    }   
  
}
    public func setUpStripe (args:Dictionary<String,Any>){
        print(args);
        let myAPIClient=MyAPIClient();
        let host = HostController();
        
        myAPIClient.setupKeys(ephemeralKey: args["ephemeralKey"] as! [String:Any], clientSecret: args["clientSecret"] as! String, publishableKey: args["publishableKey"] as! String)

        Stripe.setDefaultPublishableKey(myAPIClient.publishableKey)
        host.myAPIClient = myAPIClient;
        host.flutterResults = self.flutterResults;
      

        let viewController = UIApplication.shared.delegate?.window??.rootViewController
        
        viewController?.present(host, animated: true, completion: nil)
        
      
    }
    
    
    
    
    
}





