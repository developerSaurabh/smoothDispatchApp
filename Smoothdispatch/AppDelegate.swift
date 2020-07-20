//
//  AppDelegate.swift
//  Smoothdispatch
//
//  Created by Ravinder on 18/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shareModel = LocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
          IQKeyboardManager.shared.enable = true
        
         // Override point for customization after application launch.
          self.validationForBackgroundLocations(launchOptions: launchOptions)
        if UserDefaults.standard.value(forKey: "DynamicDomain") == nil {
             UserDefaults.standard.set("incabdispatch.com", forKey: "DynamicDomain")
        }
        
        if let loginValue =  UserDefaults.standard.value(forKey: "Login") as? Bool {
            if loginValue == true {
                let storyboard =  UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "SetPasswordViewController") as! SetPasswordViewController
                    mainViewController.hitDomainUrl = true
                let navVC = UINavigationController(rootViewController: mainViewController)
                self.window?.rootViewController = navVC
            }
        }
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
         self.setupBackgroundLocationFetch()
     }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.shareModel.restartMonitoringLocation()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Remove the "afterResume" Flag after the app is active again.

              self.shareModel.afterResume = false
              self.shareModel.startMonitoringLocation()
        
    }
    
    //MARK:- Intialize Location Fetch Function
    
    func setupBackgroundLocationFetch() {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        self.shareModel = LocationManager.sharedInstance
        self.shareModel.afterResume = false
        self.shareModel.startMonitoringLocation()
    }
    
    
    func validationForBackgroundLocations(launchOptions:
          [UIApplication.LaunchOptionsKey: Any]?) {
          if (UIApplication.shared.backgroundRefreshStatus == .denied) {
              //            self.showAlertAppDelegate(message: "The app doesn't work
              //                without the Background App Refresh enabled. To turn it on, go to
              //                Settings > General > Background App Refresh")
              let alert = UIAlertController(title: "", message:"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
              self.window?.rootViewController?.present(alert, animated: true, completion: nil)
              
              //            showAlert(title: "", message: "The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh", controller: self)
          } else if (UIApplication.shared.backgroundRefreshStatus ==
              .restricted) {
              //            self.showAlertAppDelegate(message: "The functions of this
              //                app are limited because the Background App Refresh is disable.")
              
              
              let alert = UIAlertController(title: "", message:"The functions of this app are limited because the Background App Refresh is disable.", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
              self.window?.rootViewController?.present(alert, animated: true, completion: nil)
          } else {
              // When there is a significant changes of the location,
              // The key UIApplicationLaunchOptionsLocationKey will be
              //            returned from didFinishLaunchingWithOptions
              // When the app is receiving the key, it must reinitiate
              //            the locationManager and get
              // the latest location updates
              
              // This UIApplicationLaunchOptionsLocationKey key enables
              //            the location update even when
              
              // the app has been killed/terminated (Not in th
              //            background) by iOS or the user.
              if  launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
                  // This "afterResume" flag is just to show that he
                  //                receiving location updates
                  // are actually from the key
                  //                "UIApplicationLaunchOptionsLocationKey"
                  self.shareModel.afterResume = true
                  self.shareModel.startMonitoringLocation()
              }
              
          }
          
      }
    
    
    
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Smoothdispatch")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



