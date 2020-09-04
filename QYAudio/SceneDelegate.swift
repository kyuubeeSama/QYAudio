//
//  SceneDelegate.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/4/23.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import QTOpenSDK
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        QTOpenSDK.registerClientId("MmYxYThlY2EtYWMxMi0xMWU4LTkyM2YtMDAxNjNlMDAyMGFk", host: "https://open.staging.qingting.fm", redirectUrl: "http://qttest.qingting.fm")
        let windowScene = scene as! UIWindowScene
        self.window = UIWindow.init(windowScene: windowScene)
        self.window?.backgroundColor = .white
        if Tool.isPad() {
            print("平板")
        }else{
            let VC = IndexViewController.init()
            let navgation = UINavigationController(rootViewController: VC);
            self.window?.rootViewController=navgation;
        }
        self.window?.makeKeyAndVisible()
        //        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        print("音乐文件路径是\(url.absoluteString)")
        let fileName = url.lastPathComponent
        var path = url.absoluteString
        path = self.URLDecoded(string: path)
        if path.contains("file://"){
            path = path.replacingOccurrences(of: "file://private/", with: "")
            let localPath = FileTool.getDocumentPath()+"/music/"+fileName
            print("目标保存位置是:\(localPath)")
            let dic = ["fileName":fileName,"filePath":path]
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: localPath) {
                // 文件不存在，重新拷贝
                print("文件已存在")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileExistsNotification"), object: nil, userInfo: dic)
            }else{
                // 文件已存在
                do{
                    try fileManager.copyItem(atPath: path, toPath: localPath)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileSaveSuccessNotification"), object: nil, userInfo: dic)
                }catch let error{
                    print(error);
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileSaveFieldFileNotification"), object: nil, userInfo: dic)
                }
            }
        }
    }
    
    // 中文文件名编码处理
    func URLDecoded(string:String)->(String){
        let decodedString:String = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return decodedString
    }
    
}

