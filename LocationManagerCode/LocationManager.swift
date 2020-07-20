//
//  LocationManager.swift
//  BackgroundFetchIfAppKilled
//
//  Created by Anil on 12/07/18.
//  Copyright © 2018 Anil. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager : CLLocationManager {
    
    //MARK:- Variables
    var anotherLocationManager = CLLocationManager()
    public static let sharedInstance = LocationManager()
    var updateCoordinates : CLLocationCoordinate2D?
    var afterResume = Bool()
    weak var timer: Timer?
    var timerDispatchSourceTimer : DispatchSourceTimer?
    var speed : Double = 0.0
    //    MARK:- startMonitoringLocation
    func startMonitoringLocation() {
        
        anotherLocationManager.stopMonitoringSignificantLocationChanges()
        
        self.anotherLocationManager = CLLocationManager()
        anotherLocationManager.delegate = self
        anotherLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        anotherLocationManager.activityType = CLActivityType.otherNavigation
        anotherLocationManager.distanceFilter = 1
//        anotherLocationManager.allowsBackgroundLocationUpdates = true
        anotherLocationManager.pausesLocationUpdatesAutomatically = false
        anotherLocationManager.requestAlwaysAuthorization()
        anotherLocationManager.requestWhenInUseAuthorization()

        anotherLocationManager.startMonitoringSignificantLocationChanges()
    }
    
    func restartMonitoringLocation(){
        
        anotherLocationManager.stopMonitoringSignificantLocationChanges()
        anotherLocationManager.requestAlwaysAuthorization()
        anotherLocationManager.startMonitoringSignificantLocationChanges()
    }
 
    func stopTimer() {
        timer?.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
        timerDispatchSourceTimer?.cancel()
    }
    
    // if appropriate, make sure to stop your timer in `deinit`
    deinit {
        stopTimer()
    }
}

//MARK:- CLLocationManagerDelegate //Get My Location Details
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = manager.location?.coordinate else {
            return
        }
        self.updateCoordinates = coordinates
        Methods.sharedInstance.userLiveLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        self.speed = self.location?.speed ?? 0.0
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { [weak self] _ in
                    // do something here
                    self?.updateUserLocationToServer(coordinates: coordinates)
                    self?.anotherLocationManager.stopMonitoringSignificantLocationChanges()
                }

            } else {
                // Fallback on earlier versions
                timerDispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
                timerDispatchSourceTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(10))
                timerDispatchSourceTimer?.setEventHandler{
                        // do something here
              
                }
                timerDispatchSourceTimer?.resume()
            }
        
    }
    
    func getTodayString() -> String{

                   let date = Date()
                   let calender = Calendar.current
                   let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

                   let year = components.year
                   let month = components.month
                   let day = components.day
                   let hour = components.hour
                   let minute = components.minute
                   let second = components.second

                   let today_string = String(year!) + String(month!) + String(day!) + String(hour!) + String(minute!) +  String(second!)

                   return today_string

               }
    
    // LOCATION UPDATE TO SERVER
    func updateUserLocationToServer(coordinates: CLLocationCoordinate2D) {
        
        //YYYYMMDDHHMMSSmmm  : CST hit the api after 8 sec
        
        let todayDate = getTodayString()

        
            print("Hi this is Date\(todayDate)")
        
        
        //print("coordinates are \(coordinates.latitude) and you \(coordinates.longitude)")
        //  let ticks = Date().ticks
//          var apiURL = "http://www.incabdispatch.com/justSendAddress.aspx?dot=2150093&timestamp=\(todayDate)&PhoneNumber=4174553609&drivertype=Driver&driver=1&truck=1&orderid=&lat=36.7314857&lon=-94.41146345&distance=14.028028689250945&speed=0.0&timespan=14015&address=&onJob=&trailer=2&manufacturer=LGE&model=LG-US996&version=3.0"
        
        var apiURL = ""
       
         if let dictValue = UserDefaults.standard.value(forKey: "SaveDict") as? [String : String] {
            
            let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
            
            apiURL = "http://\(firstPart)/justSendAddress.aspx?dot=\(dictValue["companyDot"] ?? "")&timestamp=\(todayDate)&PhoneNumber=\(dictValue["deviceID"] ?? "0")&drivertype=Driver&driver=\(dictValue["driverID"] ?? "")&truck=\(dictValue["truckID"] ?? "")&orderid=&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&distance=0.14374149186357857&speed=\(speed)&timespan=15631&address=&onJob=&trailer=\(dictValue["TrailerID"] ?? "")&manufacturer=ios&model=iphone&version=10.3"
        }
        
        print("Here is the complete URL\(apiURL)")
        
       WebServiceClass.sharedInstance.dataTask(urlName: apiURL, method: "POST", params: "") { (success, response, errorMsg) in
            
            print("success aa gyA \(response)")
        }
        
 
    }
  
}
// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
