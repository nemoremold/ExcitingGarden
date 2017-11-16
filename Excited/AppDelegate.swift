//
//  AppDelegate.swift
//  Excited
//
//  Created by Emoin Lam on 29/03/2017.
//  Copyright © 2017 Emoin Lam. All rights reserved.
//

import UIKit
//var passValue: PlantType?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //开启通知,通知是默认开启的，反抗也没有用！！！！
        //let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        let types: UIUserNotificationType = [.alert, .badge, .sound]
        let settings :UIUserNotificationSettings=UIUserNotificationSettings(types: types, categories: nil);
        application.registerUserNotificationSettings(settings)
        return true
    }
    func application(application: UIApplication,
                     didReceiveLocalNotification notification: UILocalNotification) {
        //设定Badge数目
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let info = notification.userInfo as! [String:Int]
        let number = info["ItemID"]
        
        let alertController = UIAlertController(title: "本地通知",
                                                message: "消息内容：\(notification.alertBody)用户数据：\(number)",
            preferredStyle: UIAlertControllerStyle.alert)
        
        
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil);
        
        alertController.addAction(cancel);
        
        self.window?.rootViewController!.present(alertController,
                                                 animated: true, completion: nil)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

