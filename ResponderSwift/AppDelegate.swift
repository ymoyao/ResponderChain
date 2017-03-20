//
//  AppDelegate.swift
//  ResponderSwift
//
//  Created by MasterFly on 2017/3/1.
//  Copyright © 2017年 MasterFly. All rights reserved.
//

import UIKit

class MyWindow: UIWindow {
    //点击测试
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(self)

        let view = super.hitTest(point, with: event)
        return view
    }
    
    //hitTest 核心，用来测试触摸点是否命中self
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let pointFromSelf = convert(point, from: self)
        if self.bounds.contains(pointFromSelf) {
            return true
        }
        return false
    }
    
    //开始点击回调，这里用来打印出整条 响应者链条
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("响应者链条从这里开始 \n\(self)")
        var next = self.next
        while next != nil {
            print(next!)
            next = next?.next
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: MyWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = MyWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let vc = ViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
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

