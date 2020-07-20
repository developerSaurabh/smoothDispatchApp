//
//  UploadDocViewController.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Alamofire
import Photos
class UploadDocViewController: UIViewController,ShowAlert{
    
    @IBOutlet var tableView: UITableView!
    var selectedIndex = 0
    var myImage = UIImage()
    var imageSelected = false
    var DictData = Dictionary<String, AnyObject>()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var vSpinner : UIView?
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerXib()
        initDict()
        let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
        url = "http://\(firstPart)/justcatchimage.aspx?dot=2150093&deviceid=4174553609&ordernum=1&driverid=1&truckid=1&trailerid=1&drivertype=driver&note=test&doctype=MISC"
        // Do any additional setup after loading the view.
        //self.uploadFile()
    }
    
    func initDict(){
        //BOL,DIV,DET,MISC
        DictData["doctype"] = "BOL" as AnyObject
        DictData["note"] = "" as AnyObject
        DictData["ordernum"] = "" as AnyObject
        
    }
 
    func registerXib() {
        
        self.tableView.register(UINib(nibName: "UploadOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadOptionsTableViewCell")
        self.tableView.register(UINib(nibName: "NoteTextTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTextTableViewCell")
        
         self.tableView.register(UINib(nibName: "SaveSettingsBtnTableViewCell", bundle: nil), forCellReuseIdentifier: "SaveSettingsBtnTableViewCell")
        
        self.tableView.register(UINib(nibName: "UploadImageTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadImageTableViewCell")
    }
    
    func activityIndicator(_ title: String) {

           strLabel.removeFromSuperview()
           activityIndicator.removeFromSuperview()
           effectView.removeFromSuperview()

           strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
           strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.medium)
           strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

           effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
           effectView.layer.cornerRadius = 15
           effectView.layer.masksToBounds = true

        activityIndicator = UIActivityIndicatorView(style: .white)
           activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
           activityIndicator.startAnimating()

           effectView.addSubview(activityIndicator)
           effectView.addSubview(strLabel)
           view.addSubview(effectView)
       }

}

extension UploadDocViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UploadOptionsTableViewCell") as! UploadOptionsTableViewCell
                cell.billOfLandingPAge.addTarget(self, action: #selector(tapFirstBtn), for: .touchUpInside)
                cell.diversionImageBtn.addTarget(self, action: #selector(tapsecondBtn), for: .touchUpInside)
                cell.detentionBtn.addTarget(self, action: #selector(tapThirdBtn), for: .touchUpInside)
                cell.miscBtn.addTarget(self, action: #selector(tapFourthBtn), for: .touchUpInside)
                cell.orderTxtfld.delegate = self
                cell.orderTxtfld.keyboardType = .twitter
    
                return cell
        }else if indexPath.row == 1 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "NoteTextTableViewCell") as! NoteTextTableViewCell
                cell.noteTxView.delegate = self
            return cell
        }else if indexPath.row == 2 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "UploadImageTableViewCell") as!   UploadImageTableViewCell
                cell.imageView_.image = myImage
                return cell
            
        }else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SaveSettingsBtnTableViewCell") as! SaveSettingsBtnTableViewCell
                cell.setingsBrn.addTarget(self, action: #selector(tapopenGallery), for: .touchUpInside)
                cell.setingsBrn.setTitle("CAPTURE IMAGE AND UPLOAD", for: .normal)
            return cell
        }
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
           return 250
        case 1 :
            return 200
        case 2 :
            return imageSelected == false ? 0.1 : 150
        default:
            return 100
        }
    }
    
    
    // MArk:- Selector
    @objc func tapopenGallery(){
        
        if let orderNum =  DictData["ordernum"] as? String , orderNum.count == 0 {
            self.showAlert("Please enter Order number")
        } else if let note =  DictData["note"] as? String , note.count == 0 {
            self.showAlert("Please enter note")
        } else {
              self.showActionSheetForImage()
        }
    }
    
    
    //MARK:- Call ActionSheet For image
    func showActionSheetForImage() {
        
        // Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            
            print("Take Photo")
            self.openImagePickerViewController(sourceType: .camera, mediaTypes: [kUTTypeImage as String])
        }
        
        actionSheetControllerIOS8.addAction(saveActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    
  
    //MARK:- ACTIONS
    @objc func tapFirstBtn(){
       
        let  cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UploadOptionsTableViewCell
             cell.radio1.image = #imageLiteral(resourceName: "radio")
             cell.radio2.image = #imageLiteral(resourceName: "radioUncheck")
             cell.radio3.image = #imageLiteral(resourceName: "radioUncheck")
             cell.radio4.image = #imageLiteral(resourceName: "radioUncheck")
             selectedIndex = 0
             DictData["doctype"] = "BOL" as AnyObject
            
          //  tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        
        
    }
    
    @objc func tapsecondBtn(){
        let  cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UploadOptionsTableViewCell
            cell.radio1.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio2.image = #imageLiteral(resourceName: "radio")
            cell.radio3.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio4.image = #imageLiteral(resourceName: "radioUncheck")
            selectedIndex = 1
            DictData["doctype"] = "DIV" as AnyObject
             //BOL,DIV,DET,MISC
    }
    
    @objc func tapThirdBtn(){
        let  cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UploadOptionsTableViewCell
            cell.radio1.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio2.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio3.image = #imageLiteral(resourceName: "radio")
            cell.radio4.image = #imageLiteral(resourceName: "radioUncheck")
            selectedIndex = 2
            DictData["doctype"] = "DET" as AnyObject
    }
    
    @objc func tapFourthBtn(){
        let  cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UploadOptionsTableViewCell
            cell.radio1.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio2.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio3.image = #imageLiteral(resourceName: "radioUncheck")
            cell.radio4.image = #imageLiteral(resourceName: "radio")
            selectedIndex = 3
            DictData["doctype"] = "MISC" as AnyObject
    }
    
}

// Image Picker Code

extension UploadDocViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func openImagePickerViewController(sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        
        if sourceType == .camera {
            self.checkPermissionsCamera(sourceType: sourceType, mediaTypes: mediaTypes)
        }
    }
    
    func checkPermissionsCamera(sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraAuthorizationStatus {
            
        case .denied:
            self.alertPromptToAllowCameraAccessViaSetting(accessType: "Camera")
        case .authorized:
            self.openImagePicker(sourceType: sourceType, mediaTypes: mediaTypes)
        case .restricted:
            self.alertPromptToAllowCameraAccessViaSetting(accessType: "Camera")
        case .notDetermined:
            self.openAccessCameraPop(mediaTypes: mediaTypes)
            
        }
    }
    
    func checkPhotoStatusPhotos(sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        
        let photsAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photsAuthorizationStatus {
            
        case .denied:
            self.alertPromptToAllowCameraAccessViaSetting(accessType: "Library")
        case .authorized:
            self.openImagePicker(sourceType: sourceType, mediaTypes: mediaTypes)
        case .restricted:
            self.alertPromptToAllowCameraAccessViaSetting(accessType: "Library")
        case .notDetermined:
            self.openAccessPhotoLibraryPop(mediaTypes: mediaTypes)
            
        }
        
    }
    
    func openAccessCameraPop(mediaTypes: [String]) {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            
            if(granted){
                self.openImagePicker(sourceType: .camera, mediaTypes: mediaTypes)
            } else {
                self.alertPromptToAllowCameraAccessViaSetting(accessType: "Camera")
            }
            
        }
    }
    
    func openAccessPhotoLibraryPop(mediaTypes: [String]) {
        
        PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus)in
            
            switch status {
                
            case .denied:
                self.alertPromptToAllowCameraAccessViaSetting(accessType: "Library")
                break
                
            case .authorized:
                self.openImagePicker(sourceType: .photoLibrary, mediaTypes: mediaTypes)
                break
                
            case .restricted:
                self.alertPromptToAllowCameraAccessViaSetting(accessType: "Library")
                break
                
            case .notDetermined:
                self.alertPromptToAllowCameraAccessViaSetting(accessType: "Library")
                break
            }
        })
    }
    
    
    @objc func openImagePicker(sourceType: UIImagePickerController.SourceType, mediaTypes: [String]) {
        
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
                  if #available(iOS 11.0, *) {
                      picker.videoExportPreset = AVAssetExportPresetPassthrough
                  }
                  picker.sourceType = sourceType
                  picker.delegate = self
                  picker.mediaTypes = mediaTypes
                  picker.navigationBar.isTranslucent = false
                  picker.navigationBar.titleTextAttributes = [
                      NSAttributedString.Key.foregroundColor : UIColor.black
                  ]
             self.present(picker, animated: true, completion: nil)
        }
    
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting(accessType: String) {
        
        let alert = UIAlertController(title: "Access to \(accessType) is restricted", message: "You need to enable access to \(accessType). Apple Settings > Privacy > \(accessType).", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        
        present(alert, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {}
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? UploadImageTableViewCell else {
            return
        }
        
        myImage = image
//        cell.imageView_.image = image
        imageSelected = true
        self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        
        if let dictInfo_ = UserDefaults.standard.value(forKey: "SaveDict") as?  [String : String] {
              let firstPart = UserDefaults.standard.value(forKey: "DynamicDomain") as! String
           let Url =    "http://\(firstPart)/justcatchimage.aspx?dot=\(dictInfo_["companyDot"] ?? "0")&deviceid=\(dictInfo_["deviceID"] ?? "0")&ordernum=\(DictData["ordernum"] as? String ?? "")&driverid=\(dictInfo_["driverID"] ?? "0")&truckid=\(dictInfo_["truckID"] ?? "0")&trailerid=\(dictInfo_["TrailerID"] ?? "0")&drivertype=driver&note=\(DictData["note"] as? String ?? "")&doctype=\(DictData["doctype"] as? String ?? "")"
            
            self.showSpinner(onView: self.view)
            self.view.isUserInteractionEnabled = false
             self.uploadFile(myImageFile: myImage, UrlPath: Url)
            
          }
      
    }
  
    //Hit the Api
    
    //MARK: Uplaod User Profile Pic
    
    func uploadFile(myImageFile : UIImage, UrlPath : String){
      
     //   let image = UIImage.init(named: "dummy")
            let imgData = myImageFile.jpegData(compressionQuality: 0.2)!

            let parameters = ["description": DictData["note"] as? String ?? ""] //Optional for extra parameter
            
           Alamofire.upload(multipartFormData: { multipartFormData in
                   multipartFormData.append(imgData, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
                   for (key, value) in parameters {
                           multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                       } //Optional for extra parameters
               },
           to: UrlPath)
           { (result) in
               self.removeSpinner()
               switch result {
               case .success(let upload, _, _):
                     
                    print("Sucess")
                   self.view.isUserInteractionEnabled = true
                   upload.uploadProgress(closure: { (progress) in
                       print("Upload Progress: \(progress.fractionCompleted)")
                   })

                   upload.responseJSON { response in
                        print(response as? AnyObject)
                    print(response.result.description)
                    // Create the alert controller
                       let alertController = UIAlertController(title: "Smooth Dispatch", message: "Image uploaded sucessfully.", preferredStyle: .alert)

                       // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                           UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                       }
                        // Add the actions
                    alertController.addAction(okAction)
                           // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                    
                   }

               case .failure(let encodingError):
                   print(encodingError)
                  
                    print("Cool")
               }
           }
    
    }
    
}

extension UploadDocViewController : UITextViewDelegate,UITextFieldDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DictData["note"] = textView.text as AnyObject
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        DictData["ordernum"] = textField.text! as AnyObject
      
    }
 
}


 
extension UploadDocViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
