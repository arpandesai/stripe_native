import Foundation
import Stripe

class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {

    var ephemeralKey : [String:Any]!
    var clientSecret : String =  ""
    var publishableKey : String =  ""

    static let myAPISharedClient = MyAPIClient()

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//        print(ephemeralKey)
        //completion(convertToDictionary(text: ephemeralKey), nil)
        completion(ephemeralKey, nil)

        }
    
    func setupKeys(ephemeralKey:[String:Any],clientSecret:String,publishableKey:String)  {
        self.ephemeralKey=ephemeralKey
        self.clientSecret=clientSecret
        self.publishableKey=publishableKey;
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
            if let data = text.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
    
}
