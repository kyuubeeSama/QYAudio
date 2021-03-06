//
//  QYRequestData.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/12/2.
//  Copyright © 2019 qykj. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UploadFileModel {
    var fileName:String?
    var filePath:String?
    var fileData:Data?
    var fileMimeType:String?

    required init() {

    }
}

private let NetWorkRequestShareInstance = QYRequestData()

class QYRequestData{
    class var sharedInstance:QYRequestData {
        NetWorkRequestShareInstance
    }
}
//网络请求类型
enum requestMethod {
    case get
    case post
}
//文件上传方式
enum uploadFileType {
    case filePath
    case fileData
}

extension QYRequestData{
    // 网络请求
    // TODO:后期完善设置header
    func request(urlString:String,params:[String:Any]?,method:requestMethod,success:@escaping(_ response:[String:AnyObject])->(),failure:@escaping(_ error:Error)->()){
        let dataUrl = BaseUrl+urlString
        var afMethod:HTTPMethod = .get
        if method == requestMethod.post{
            afMethod = .post
        }
        AF.request(dataUrl, method: afMethod, parameters: params).responseJSON{(response) in
            switch response.result{
            case .success(let value):
                if let value = response.value as? [String:AnyObject]{
                    success(value)
                }
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
                failure(error)
            }
        }
    }

    // TODO:上传图片。单图上传，多图上传，图片文件上传，图片地址上传  文件上传
    func uploadFile(urlString:String,params:[String:Any],fileData:[UploadFileModel],uploadType:uploadFileType,uploadProgress:@escaping (_ progressValue:Progress)->(),success:@escaping (_ result:[String:Any])->(),failure:@escaping (_ error:Error)->()){
        let uploadUrl = BaseUrl+urlString
        AF.upload(multipartFormData: { multipartFormData in
            for model in fileData {
                // 图片地址
                if uploadType == uploadFileType.filePath{
                    multipartFormData.append(URL(fileURLWithPath: model.filePath!), withName: model.fileName!, fileName: model.fileName!, mimeType: model.fileMimeType!)
                }else{
                    // 图片数据
                    multipartFormData.append(model.fileData!, withName: model.fileName!,fileName: model.fileName!,mimeType: model.fileMimeType!)
                }
            }
        }, to: uploadUrl).uploadProgress{progress in
            uploadProgress(progress)
        }.responseJSON{ response in
            switch response.result{
            case .success(let value):
                if let value = response.value as? [String:AnyObject]{
                    success(value)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    // TODO:文件下载
    func downloadFile(urlStr:String,savePath:String,downloadProgress:@escaping (_ progress:Progress)->(),success:@escaping (_ result:[String:Any])->(),failure:@escaping (_ error:Error)->()){
        let downloadUrl = BaseUrl+urlStr
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("image.png")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(downloadUrl, to: destination)
            .downloadProgress{ progress in
                downloadProgress(progress)
            }.responseJSON { response in
                switch response.result{
                case .success (let value):
                    if let value = response.value as? [String:AnyObject]{
                        success(value)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
    }
    
}
