import Flutter
import UIKit
import Stripe

public class SwiftStripeNativePlugin: NSObject, FlutterPlugin , StripeDelegate {
    
    
    var flutterResults : FlutterResult!
    var delegate : StripeDelegate!
    private var pendingOperation: StripeOperation?

    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "stripe_native", binaryMessenger: registrar.messenger())
    let instance = SwiftStripeNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    Stripe.setDefaultPublishableKey("pk_test_vgklWgkPbEazPYbSES86lBRk")
  }
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    pendingOperation = StripeOperation(flutterResult:result)

    self.flutterResults=result;
    if(call.method.elementsEqual("lunch_stripe")){
        let args = call.arguments as? Dictionary<String,Any>
        setUpStripe(args: args! ,result:result);
    }
    else{
        result(FlutterMethodNotImplemented)
    }
  
}
    public func setUpStripe (args:Dictionary<String,Any>,result: @escaping FlutterResult){
        print(args);
        let myAPIClient=MyAPIClient();
        let host = HostController();
        
        myAPIClient.setupKeys(ephemeralKey: args["ephemeralKey"] as! [String:Any], clientSecret: args["clientSecret"] as! String, publishableKey: args["publishableKey"] as! String)

        Stripe.setDefaultPublishableKey(myAPIClient.publishableKey)
        host.myAPIClient = myAPIClient;
        host.flutterResults = result;
        host.delegate=self;

        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(host, animated: true)
                }

                let storyboard : UIStoryboard? = UIStoryboard.init(name: "Main", bundle: nil);
                let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!

                let objVC: UIViewController? = storyboard!.instantiateViewController(withIdentifier: "FlutterViewController")
                let aObjNavi = UINavigationController(rootViewController: objVC!)
                window.rootViewController = aObjNavi
                aObjNavi.pushViewController(host, animated: true)
        
    }
    
    func resposeToFlutter() {
        self.pendingOperation!.result(FlutterError(code: "Error", message: "Error Message", details: nil))
   
    }
    
}


private class StripeOperation {
      
    let result: FlutterResult
    
    init( flutterResult: @escaping FlutterResult) {
        self.result = flutterResult
    }
}




