import Foundation
import Stripe

class HostController:UIViewController{
    var paymentContext: STPPaymentContext!
    var myAPIClient = MyAPIClient()
    var flutterResults: FlutterResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customerContext = STPCustomerContext(keyProvider:myAPIClient)
        let config=STPPaymentConfiguration.shared()
        
        config.appleMerchantIdentifier = ""
        config.companyName = ""
        
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = .none
        config.additionalPaymentOptions=STPPaymentOptionType.all
        
        self.paymentContext = STPPaymentContext(customerContext: customerContext,configuration: config, theme: STPTheme.default());
        self.paymentContext.delegate = self
        self.paymentContext.hostViewController = self
        self.paymentContext.presentPaymentOptionsViewController()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!paymentContext.loading){
            DispatchQueue.main.async {
                if(self.paymentContext.selectedPaymentOption != nil){
                    self.didTapBuy()
                       }else{
                        self.popContoller()
                       }
            }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            if(self.paymentContext.selectedPaymentOption != nil){
//                self.didTapBuy()
//                   }else{
//                    self.popContoller()
//                   }
//
//               }
        }

    }
    
    
}
    

extension HostController:STPPaymentContextDelegate{
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("didFailToLoadWithError", error.localizedDescription)
        self.flutterResults("Flutter error")
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        //create payment
        print("didCreatePaymentResult", paymentResult)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: myAPIClient.clientSecret)
            paymentIntentParams.paymentMethodId = paymentResult.paymentMethod.stripeId
        
        STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: paymentContext) { status, paymentIntent, error in
                       switch status {
                       case .succeeded:
                           completion(.success, nil)
                       case .failed:
                            completion(.error, error) // Report error
                       case .canceled:
                           completion(.userCancellation, nil) // Customer cancelled
                       @unknown default:
                           completion(.error, nil)
                       }
                   }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("didFinishWith with status",status);
        switch status {
           case .error:
            print("error");
            self.flutterResults!("Payment Error:" + error!.localizedDescription);
            self.popContoller();
            break;
            
           case .success:
            print("success");
            self.flutterResults!("Payment Sucess:" + toString(paymentContext));
            self.popContoller();
            break;
            
           case .userCancellation:
            print("userCancellation");
            self.flutterResults!(FlutterError(code: "payment_cancelled_by_user", message: "User pressed back or Please try again later", details: nil));
            self.popContoller();
            return // Do nothing
        @unknown default:
            fatalError()
        }
    }
   
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print(paymentContext)
    }
    
  func popContoller(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapBuy() {
        self.paymentContext.requestPayment()
    }
        
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
    
}

