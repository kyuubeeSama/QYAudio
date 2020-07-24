//
//  FileTool.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/5/12.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class FileTool: NSObject {
    /// 获取document文件夹
    static func getDocumentPath()->String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    // 创建指定文件夹
    static func createDirectory(path:String) throws ->Bool{
        let fileManger = FileManager.default
        var isDirectory:ObjCBool = false
        let isExist = fileManger.fileExists(atPath: path, isDirectory: &isDirectory)
        // 文件是否存在
        if !isExist {
            do{
                try fileManger.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return true
            }catch let error{
                print(error)
                return false
            }
        }else{
            return true
        }
    }
    
    // 获取本地音乐文件
    static func getAudioFileList()->Array<LocalAudioModel>{
        // TODO:获取本地音乐文件
        var array:[LocalAudioModel] = []
        var path = self.getDocumentPath()
        path += "/music"
//        let dirEnum = fileManager.enumerator(atPath: path)
        
        let enumerator = FileManager.default.enumerator(atPath: path)
        while let fileName = enumerator?.nextObject() as? String {
            print(fileName)

            if let fType = enumerator?.fileAttributes?[FileAttributeKey.type] as? FileAttributeType{
                switch fType{
                case .typeRegular:
                    print("文件")
                    if fileName.contains(".mp3") || fileName.contains(".flac"){
                        let model:LocalAudioModel = LocalAudioModel.init()
                        model.fileName = fileName
                        model.filePath = path+"/"+fileName
                        array.append(model)
                    }
                case .typeDirectory:
                    print("文件夹")
                default:
                    print("未知类型")
                }
            }

        }
        return array
    }
}
