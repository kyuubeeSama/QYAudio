//
//  AppDelegate.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/4/23.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let fileName = url.lastPathComponent
        var path = url.absoluteString
        if path.contains("file://"){
            path = path.replacingOccurrences(of: "file://", with: "")
            let dic = ["fileName":fileName,"filePath":path]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileNotification"), object: nil, userInfo: dic)
        }
        return true
    }
}

// 当文件名为中文时，解决url编码问题
//    - (NSString *)URLDecodedString:(NSString *)str {
//        NSString *decodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef) str, CFSTR("")));
//    //    NSLog(@"decodedString = %@",decodedString);
//        return decodedString;
//    }
//}

