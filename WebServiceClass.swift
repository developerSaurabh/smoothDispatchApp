//
//  WebServiceClass.swift
//  Smoothdispatch
//
//  Created by Ravinder on 02/10/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceClass {
    
    static let sharedInstance = WebServiceClass()

    //MARK:- Data task
    open func dataTask(urlName: String, method: String, params: Dictionary<String,AnyObject>, completion: @escaping (_ success: Bool, _ object: Any, _ errorMsg: String) -> ()) {
        
        let urlString: URL = URL(string: urlName)!
        print("API Name:- \(urlString) Get body Data: \(params)")
        
        let request = NSMutableURLRequest(url: urlString,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = method
        
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: {

                if (error != nil) {
                    completion(false, "", error?.localizedDescription ?? "")
                } else {
                    
                    if let response = response as? HTTPURLResponse , 200...501 ~= response.statusCode  {
                        
                        if response.statusCode == 201 || response.statusCode == 200 {
                            
                            // Check Data
                            if let data = data {
                                // Json Response
                                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                                    completion(true, jsonResponse, "")
                                } else {
                                    completion(false, "", "Error Occured")
                                }
                            } else {
                                completion(false, "", "Error 2nd")
                            }
                        } else if response.statusCode == 404 {
                            completion(false, "", "Error 3rd")
                        } else {
                            completion(false, "", "Error 4th")
                        }
                    } else {
                            completion(false, "", "Error 5th")
                    }
                }
            })
        })
        dataTask.resume()
    }
   
 }

struct SharedInstance {
      
      static let appDelegate = UIApplication.shared.delegate as? AppDelegate
      
      typealias myDict = Dictionary<String, AnyObject>
      typealias myArrayDict = [Dictionary<String, AnyObject>]
      typealias callBack = () -> ()
      typealias SourceCompletionHandler = (_ success:AnyObject) -> () // for success case
      typealias completionBlock = (_ success: Bool, _ object: Any, _ errorMsg: String) -> ()
      static let googlePicKey = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=60&sensor=false&key=AIzaSyCaSjiwkdmPQrKdhRCSWWJXFAq9gbFPuik&photoreference="
      typealias callBackHandler = (_ success: Bool?, _ object: AnyObject?, _ errorMsg: String?) -> ()

  }
