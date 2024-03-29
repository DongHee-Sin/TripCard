//
//  AppDelegate.swift
//  TripCard
//
//  Created by 신동희 on 2022/09/06.
//

import UIKit

import FirebaseCore
import GooglePlaces
import IQKeyboardManagerSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        GMSPlacesClient.provideAPIKey(APIKeys.googleKey)
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorManager.shared.textColor, NSAttributedString.Key.font: UIFont.customFont(size: .large)], for: UIControl.State.normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorManager.shared.textColor, NSAttributedString.Key.font: UIFont.customFont(size: .large)], for: UIControl.State.highlighted)
        
        
        // Firebase
        FirebaseApp.configure()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

