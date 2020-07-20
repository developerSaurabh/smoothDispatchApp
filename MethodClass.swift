//
//  MethodClass.swift
//  Smoothdispatch
//
//  Created by Ravinder on 02/10/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import AssetsLibrary
import AVFoundation
import AVKit
import CoreLocation

class Methods {
    
    var callBack: SharedInstance.SourceCompletionHandler?
    var locationCallBack: SharedInstance.SourceCompletionHandler?
    static let sharedInstance = Methods()
    
    public var userLiveLocation: CLLocation? {
         get {
             if let latitude = UserDefaults.standard.value(forKey: "userLivelatitude") as? CLLocationDegrees {
                 if let longitude = UserDefaults.standard.value(forKey: "userLivelongitude") as? CLLocationDegrees {
                     return CLLocation(latitude: latitude, longitude: longitude)
                 }
             }
             return nil
         } set (newLocation) {
             
             if let locationBlock = self.locationCallBack {
                 locationBlock(newLocation as AnyObject)
             }
             UserDefaults.standard.set(newLocation?.coordinate.latitude, forKey: "userLivelatitude")
             UserDefaults.standard.set(newLocation?.coordinate.longitude, forKey: "userLivelongitude")
         }
     }


}
