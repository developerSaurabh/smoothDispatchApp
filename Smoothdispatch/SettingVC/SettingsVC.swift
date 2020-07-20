//
//  SettingsVC.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class SettingsVC: UIViewController,ShowAlert {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var MoreBtn: UIBarButtonItem!
    let placeholderArray = ["Device ID","Driver ID","Truck ID","Trailer ID"]
    var dictInfo = [String : String]()
    var edit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.registerXib()
        if edit == false{
            self.initDict()
        }else{
            self.editedDict()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func registerXib() {
        
         self.tableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextfieldTableViewCell")
         self.tableView.register(UINib(nibName: "SimpleTextfldTableViewCell", bundle: nil), forCellReuseIdentifier: "SimpleTextfldTableViewCell")
         self.tableView.register(UINib(nibName: "SaveSettingsBtnTableViewCell", bundle: nil), forCellReuseIdentifier: "SaveSettingsBtnTableViewCell")
        
    }
    
    func initDict() {
        dictInfo["companyDot"] = ""
        dictInfo["deviceID"] = ""
        dictInfo["driverID"] = ""
        dictInfo["truckID"] = ""
        dictInfo["TrailerID"] = ""
        UserDefaults.standard.set(dictInfo, forKey: "SaveDict")
    }
    
    func editedDict(){
    
        let dict = UserDefaults.standard.value(forKey: "SaveDict") as! [String : String]
        
            dictInfo["companyDot"] = dict["companyDot"]
            dictInfo["deviceID"] =   dict["deviceID"]
            dictInfo["driverID"] =   dict["driverID"]
            dictInfo["truckID"]  =   dict["truckID"]
            dictInfo["TrailerID"] =  dict["TrailerID"]
        
           UserDefaults.standard.set(dictInfo, forKey: "SaveDict")
    
    }
    
    //MARK:- ACTION
    @IBAction func menuBrnAction(_ sender: Any) {
        
    }
 
}
extension SettingsVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextfieldTableViewCell") as! TextfieldTableViewCell
            let dict = UserDefaults.standard.value(forKey: "SaveDict") as! [String : String]
                if dict["companyDot"]?.count != 0 {
                    cell.txtfld.text = dict["companyDot"]
                }else{
                    cell.txtfld.placeholder = "Company DOT#"
                    cell.txtfld.isSelected = true
                }
                cell.txtfld.delegate = self
                cell.txtfld.tag = indexPath.row
                return cell
        case placeholderArray.count + 1 :
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SaveSettingsBtnTableViewCell") as! SaveSettingsBtnTableViewCell
                cell.setingsBrn.addTarget(self, action: #selector(tapSaveBtn), for: .touchUpInside)
            return cell
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SimpleTextfldTableViewCell") as! SimpleTextfldTableViewCell
                let dict = UserDefaults.standard.value(forKey: "SaveDict") as! [String : String]
                if dict["companyDot"]?.count != 0 {
                    if indexPath.row == 1 {
                        cell.textfield.text = dict["deviceID"]
                        cell.textfield.keyboardType = .numberPad
                    }else if indexPath.row == 2 {
                         cell.textfield.text = dict["driverID"]
                         cell.textfield.keyboardType = .numberPad
                    }else if indexPath.row == 3 {
                         cell.textfield.text = dict["truckID"]
                         cell.textfield.keyboardType = .numberPad
                    }else{
                         cell.textfield.text = dict["TrailerID"]
                         cell.textfield.keyboardType = .numberPad
                    }
              }
                cell.textfield.placeholder = placeholderArray[indexPath.row - 1]
                cell.textfield.tag = indexPath.row
                cell.textfield.delegate = self
             return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 90
    }
    
  @objc  func tapSaveBtn() {
        let result = textfieldValidation()
        if result == true {
            if edit == true {
                if var dictValue = UserDefaults.standard.value(forKey: "SaveDict") as? [String : String] {
                    dictValue["companyDot"] = dictInfo["companyDot"]
                    dictValue["deviceID"] =  dictInfo["deviceID"]
                    dictValue["driverID"] =  dictInfo["driverID"]
                    dictValue["truckID"] =  dictInfo["truckID"]
                    dictValue["TrailerID"] = dictInfo["TrailerID"]
                    UserDefaults.standard.set(dictValue, forKey: "SaveDict")
                }
                
            }else{
                 UserDefaults.standard.set(dictInfo, forKey: "SaveDict")
            }
            
            
            if Reachability.isConnectedToNetwork() == true {
                self.getAuthrization()
            }else{
                print("InterNet not available")
            }
         
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
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetPasswordViewController") as! SetPasswordViewController
                            self.navigationController?.show(vc, sender: self)
                            
                        }else{
                            self.showAlert("Invalid User.")
                        }
                 
                  }
           }
      }
}


extension SettingsVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
             dictInfo["companyDot"] = textField.text ?? ""
        case 1 :
             dictInfo["deviceID"] = textField.text ?? ""
        case 2 :
            dictInfo["driverID"] = textField.text ?? ""
        case 3 :
            dictInfo["truckID"] = textField.text ?? ""
        default:
            dictInfo["TrailerID"] = textField.text ?? ""
        }
    }
    
    // validation function
    
    func textfieldValidation() -> Bool {
        
        if dictInfo["companyDot"]?.count == 0 {
            self.showAlert("Please enter Company Dot#")
            return false
        }else if dictInfo["deviceID"]?.count == 0 {
            self.showAlert("Please enter Device ID")
          return false
        }else if dictInfo["driverID"]?.count == 0 {
            self.showAlert("Please enter Driver ID")
            return false
        }else if dictInfo["truckID"]?.count == 0 {
            self.showAlert("Please enter Truck ID")
            return false
        }else if dictInfo["TrailerID"]?.count == 0 {
            self.showAlert("Please enter Trailer ID")
            return false
        }else {
           //  self.showAlert("All Good")
            return true
        }
     
    }
 
}
