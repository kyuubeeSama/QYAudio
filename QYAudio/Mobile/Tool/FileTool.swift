//
//  FileTool.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/5/12.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import AVFoundation
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
        let enumerator = FileManager.default.enumerator(atPath: path)
        while let fileName = enumerator?.nextObject() as? String {
            print(fileName)
            if let fType = enumerator?.fileAttributes?[FileAttributeKey.type] as? FileAttributeType{
                switch fType{
                case .typeRegular:
                    if fileName.contains(".mp3") || fileName.contains(".flac"){
                        let model:LocalAudioModel = LocalAudioModel.init()
                        model.fileName = fileName
                        model.filePath = path+"/"+fileName
                        self.getAudioInfo(filePath: model.filePath!)
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

    // 获取音频相关信息
    static func getAudioInfo(filePath:String)->(LocalAudioModel){
        print(filePath)
        let fileManager = FileManager.default
        let model = LocalAudioModel.init()
        do {
            let dictAtt = try fileManager.attributesOfItem(atPath: filePath)
            let audioAsset = AVAsset.init(url: URL.init(fileURLWithPath: filePath))
            print(audioAsset.availableMetadataFormats.count)
            for format:AVMetadataFormat in audioAsset.availableMetadataFormats {
                for item:AVMetadataItem in audioAsset.metadata(forFormat: format) {
                    if (item.commonKey!.rawValue == "title"){
                        print("歌曲名是\(item.value)")
                    }
                    if (item.commonKey!.rawValue == "artist"){
                        print("歌手是\(item.value)")
                    }
                    if (item.commonKey!.rawValue == "albumName"){
                        print("专辑名\(item.value)")
                    }
                    if(item.commonKey!.rawValue == "artwork"){
                        let dict:[String:Any] = item.value as! [String : Any]
                        let data = dict["data"]
                        let image:UIImage = UIImage.init(data: data as! Data)!
                    }
                }
            }
            let timpFlo:Float = dictAtt[FileAttributeKey(rawValue: "NSFileSize")] as! Float/1024/1024
        }catch let error{
            print(error)
        }
        return model
    }
    
}
