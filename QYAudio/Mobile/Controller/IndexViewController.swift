//
//  IndexViewController.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/4/23.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import AVFoundation
import QTOpenSDK

class IndexViewController: BaseViewController,UIScrollViewDelegate {
    
    let scrollView = UIScrollView.init()
    let titleView = IndexTitleView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    var audioView = AudioView.init(frame: CGRect(x: screenW-60, y: screenH-200, width: 60, height: 60))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNav()
        if(self.makeMusicDirectory()){
            // 文件创建成功，可以进行音乐拷贝
        }else{
            // 文件创建失败
            Tool.showSystemAlert(viewController: self, title: "警告", message: "本地文件创建失败") {
                
            }
        }
        self .makeUI()
    }

    func setupMediaPLayer() {
    }
    
    func setNav(){
        
        self.navigationItem.titleView = titleView
        titleView.titleBtnBlock = { index in
            self.scrollView.contentOffset = CGPoint(x: Int(screenW)*index, y: 0)
        }
        let leftBtnItem = UIBarButtonItem.init(image: UIImage.init(systemName: "list.dash"), style: .plain, target: self, action: #selector(sliderBtnClick))
            self.navigationItem.leftBarButtonItem = leftBtnItem
    }
    
    // 创建本地音乐文件夹
    func makeMusicDirectory() -> Bool {
        var path = FileTool.getDocumentPath()
        path += "/music"
        print(path)
        do{
            return try FileTool.createDirectory(path: path)
        }catch{
            return false
        }
    }
    
    func makeUI(){
        // 设置scrollview
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: top_height, width: screenW, height: screenH-(top_height))
        scrollView.contentSize = CGSize(width:screenW*2, height: screenH-(top_height))
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        // 本地音乐文件列表
        let localAudioTable = LocalAudioTableView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: scrollView.frame.size.height), style: .plain)
        scrollView.addSubview(localAudioTable)
        localAudioTable.listArr = FileTool.getAudioFileList()
        localAudioTable.reloadData()
        // 蜻蜓fm列表
        let qingtingTable = QingtingAudioTableView.init(frame: CGRect(x: screenW, y: 0, width: screenW, height: scrollView.frame.size.height), style: .plain)
        scrollView.addSubview(qingtingTable)
        self.view.addSubview(audioView)
        
        var categoryArr:[QTORadioCategory] = []
        QTOpenSDK.defaultService()?.requestRadioCategories(success: { (result) in
            if let listArr = result?.regionCategories{
//                listarray 中保存的是省份列表
                categoryArr = listArr;
                for model:QTORadioCategory in listArr {
                    print(model.name as Any)
                    self.getRadioList(categoryId: model.categoryId, page: 1)
                }
            }
        }, failed: { (error) in
            print(error as Any)
        })
    }
    
    func getRadioList(categoryId:Int,page:Int){
        QTOpenSDK.defaultService()?.requestRadioChannelList(withCategoryId: categoryId, page: page, success: { (result) in
            if let list = result?.items{
                for model:QTORadioChannel in list{
                    print(model.title);
                }
            }
        }, failed: { (error) in
            print(error)
        })

    }
    
    @objc func sliderBtnClick(){
        print("打开侧滑")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>=screenW {
            titleView.index = 1
        }else if scrollView.contentOffset.x == 0{
            titleView.index = 0
        }
    }
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
