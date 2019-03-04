//
//  AppDelegate.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let userName1 = Auth.auth().currentUser?.email as! String
        let modUserName11 = userName1.replacingOccurrences(of: "@", with: "")
        let modUsername21 = modUserName11.replacingOccurrences(of: ".", with: "")
        let improperlyClosedDB = Database.database().reference().child("Users").child(modUsername21)
        
        improperlyClosedDB.updateChildValues(["ImproperlyClosed": "Y"]){
            //improperlyClosedDB.setValue(["ImproperlyClosed": "Y"]){
            (error,reference) in
            if error != nil{
                print(error!)
            } else {
                print("Message saved successfully!")
                
            }
            
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

