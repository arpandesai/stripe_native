//
//  MyAPIClient.swift
//  stripe_native
//
//  Created by Pushkar Raj Yadav on 12/04/21.
//

import Foundation

import Stripe

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
