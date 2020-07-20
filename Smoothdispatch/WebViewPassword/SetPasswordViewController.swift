//
//  SetPasswordViewController.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation
class SetPasswordViewController: UIViewController,WKNavigationDelegate,ShowAlert{
    @IBOutlet var mainWebView: UIView!
    @IBOutlet var WebView: WKWebView!
    @IBOutlet var tableView: UITableView!
    var menuOption = ["Refresh","Upload Docs","Setting","Exit"]
    var menuSelected = false
    let locationManager = CLLocationManager()
    weak var timer: Timer?
    var timerDispatchSourceTimer : DispatchSourceTimer?
    var speed : Double = 0.0
    var hitDomainUrl = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews(){
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLocation()
        self.mainWebView.isHidden = false
        WebView.navigationDelegate = self
        WebView = WKWebView(frame: mainWebView.bounds, configuration: WKWebViewConfiguration())
        WebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UserDefaults.standard.set(true, forKey: "Login")
        
      
        if let dictInfo_ = UserDefaults.standard.value(forKey: "SaveDict") as?  [String : String] {
            let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
            let url = URL(string: "http://\(firstPart)/justDriverLogin.aspx?dot=\(dictInfo_["companyDot"] ?? "0")&driverid=\(dictInfo_["driverID"] ?? "0")&deviceid=\(dictInfo_["deviceID"] ?? "0")&truckid=\(dictInfo_["truckID"] ?? "0")&trailerid=\(dictInfo_["TrailerID"] ?? "0")")!
             WebView.load(URLRequest(url: url))
            
            print(url)
            if hitDomainUrl == true {
                self.getAuthrization()
            }
            
        }
       
        WebView.allowsBackForwardNavigationGestures = true
        self.mainWebView.addSubview(WebView)
        self.tableView.estimatedRowHeight = 45
        self.tableView.isHidden = true
   
    }
    
    func initLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    

    
    
    func refreshWebView() {
        
        if let dictInfo_ = UserDefaults.standard.value(forKey: "SaveDict") as?  [String : String] {
            let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
            let url = URL(string: "http://\(firstPart)/justDriverLogin.aspx?dot=\(dictInfo_["companyDot"] ?? "0")&driverid=\(dictInfo_["driverID"] ?? "0")&deviceid=\(dictInfo_["deviceID"] ?? "0")&truckid=\(dictInfo_["truckID"] ?? "0")&trailerid=\(dictInfo_["TrailerID"] ?? "0")")!
                WebView.load(URLRequest(url: url))
        }
    }
    
    
     func getAuthrization(){
            
            if let dictValue = UserDefaults.standard.value(forKey: "SaveDict") as? [String : String] {
                let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
                let webserviceURL = "http://\(firstPart)/justconfirmdriver.aspx?dot=\(dictValue["companyDot"] ?? "")&deviceid=\(dictValue["deviceID"]  ?? "")&driverid=\(dictValue["driverID"]  ?? "")&truck=\(dictValue["truckID"]  ?? "")&trailer=\(dictValue["TrailerID"]  ?? "")&manufacturer=IOS"
                      
                        WebServiceClass.sharedInstance.dataTask(urlName: webserviceURL, method: "GET", params: "") { (success, response, errorMsg) in
                              print(success)
                              print(response as? Dictionary<String,AnyObject>)
                              let innerValue = response as? Dictionary<String,AnyObject>
                            
                              print(innerValue?["domain"] as? String ?? "")
                            if innerValue?["domain"] as? String ?? "" != "" {
                                UserDefaults.standard.set(innerValue?["domain"] as? String ?? "", forKey: "DynamicDomain")
                            }else{
                                self.showAlert("Invalid User.")
                            }
                     
                      }
               }
          }
   
  
    @IBAction func tapMoreActionBtn(_ sender: Any) {
        if menuSelected == false {
            tableView.isHidden = false
            menuSelected = true
        }else{
            tableView.isHidden = true
            menuSelected = false
        }
    }
    
}

extension SetPasswordViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SideMenuableViewCell") as! SideMenuableViewCell
            cell.labelMenu.text = menuOption[indexPath.row]
            return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch indexPath.row {
        case 0:
           self.refreshWebView()
           tableView.isHidden = true
           menuSelected = false
        case 1 :
            tableView.isHidden = true
            menuSelected = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UploadDocViewController") as! UploadDocViewController
            self.navigationController?.show(vc, sender: self)
        case 2 :
             tableView.isHidden = true
                       menuSelected = false
                       let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                           vc.edit = true
                       self.navigationController?.show(vc, sender: self)
        default:
            print("defualt")
            tableView.isHidden = true
            menuSelected = false
            exit(0)
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension SetPasswordViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            guard let currentLocation = self.locationManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
          
            
            if (placemarks?.count)! > 0 {
                
                print("placemarks",placemarks!)
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
                self.speed = self.locationManager.location?.speed ?? 0.0
                
                if #available(iOS 10.0, *) {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { [weak self] _ in
                                   // do something here
                      //  self?.sendDataTOserver(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
                        }

                    } else {
                       // Fallback on earlier versions
                    self.timerDispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
                    self.timerDispatchSourceTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(10))
                    self.timerDispatchSourceTimer?.setEventHandler{
                                       // do something here
                             
                        }
                    self.timerDispatchSourceTimer?.resume()
                }
           
           
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            print("your location is:-",containsPlacemark)
            //stop updating location to save battery life
          //  locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            print("The complete address \(String(describing: locality)),\(postalCode),\(administrativeArea),\(country)")
         //   localityTxtField.text = locality
        //    postalCodeTxtField.text = postalCode
        //    aAreaTxtField.text = administrativeArea
        //    countryTxtField.text = country
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    //Api call
    func sendDataTOserver(lat : Double , long : Double){
        
    print("coordinates are \(lat) and you \(long)")
        let todayDate = getTodayString()
//        var apiURL = "http://www.incabdispatch.com/justSendAddress.aspx?dot=2150093&timestamp=\(todayDate)&PhoneNumber=4174553609&drivertype=Driver&driver=1&truck=1&orderid=&lat=36.7314857&lon=-94.41146345&distance=14.028028689250945&speed=0.0&timespan=14015&address=&onJob=&trailer=2&manufacturer=LGE&model=LG-US996&version=3.0"
        
      var apiURL = ""
        
       if let dictValue = UserDefaults.standard.value(forKey: "SaveDict") as? [String : String] {
        let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
          apiURL = "http://\(firstPart)/justSendAddress.aspx?dot=\(dictValue["companyDot"] ?? "")&timestamp=\(todayDate)&PhoneNumber=\(dictValue["deviceID"] ?? "0")&drivertype=Driver&driver=\(dictValue["driverID"] ?? "")&truck=\(dictValue["truckID"] ?? "")&orderid=&lat=\(lat)&lon=\(long)&distance=0.14374149186357857&speed=\(speed)&timespan=15631&address=&onJob=&trailer=\(dictValue["TrailerID"] ?? "")&manufacturer=ios&model=iphone&version=10.3"
      }
        
                       // do something here
                       WebServiceClass.sharedInstance.dataTask(urlName: apiURL, method: "POST", params: "") { (success, response, errorMsg) in
                           
                           print("inner Success aa gya \(response)")
                       }
                       self.locationManager.stopUpdatingLocation()
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
       
   
    
}
