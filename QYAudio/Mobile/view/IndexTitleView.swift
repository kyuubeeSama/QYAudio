//
//  IndexTitleView.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/5/11.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class IndexTitleView: UIView {
    
    var titleBtnBlock:((_ index:NSInteger)->())?
    var lineLayer = CALayer.init()

    var index:NSInteger = 0{
        didSet{
            // TOOD:实现选中按钮设置
            print(360+index)
            let button:UIButton = self.viewWithTag(360+index) as! UIButton
            buttonClick(button: button)
        }
    }
    
    @objc func buttonClick(button:UIButton){
        //TOOD:实现按钮点击事件
        for item in [360,361] {
            let btn:UIButton = self.viewWithTag(item) as! UIButton
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        UIView.animate(withDuration: 0.5) { () -> Void in
            if button.tag == 360{
                let string = "本地音乐"
                let size = string.getStringSize(font: UIFont.systemFont(ofSize: 16), size: CGSize(width:Double(MAXFLOAT), height: 16.0))
                self.lineLayer.frame = CGRect(x: 0, y: self.frame.size.height-1, width: size.width, height: 2)
            }else {
                let string = "蜻蜓FM"
                let size = string.getStringSize(font: UIFont.systemFont(ofSize: 16), size: CGSize(width:Double(MAXFLOAT), height: 16.0))
                self.lineLayer.frame = CGRect(x: self.frame.size.width-size.width, y: self.frame.size.height-1, width: size.width, height: 2)
            }
        }
        if self.titleBtnBlock != nil{
            self.titleBtnBlock!(button.tag-360)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //MARK:带key的数组循环
        for (key,item) in ["本地音乐","蜻蜓FM"].enumerated() {
            let button = UIButton.init(type: .custom)
            self.addSubview(button)
            button.frame = CGRect(x: 100*key, y: 0, width: 100, height: Int(frame.size.height)-1)
            button.tag = 360+key
            if key == 0 {
                button.contentHorizontalAlignment = .left
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            }else{
                button.contentHorizontalAlignment = .right
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            }
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            button.setTitleColor(.black, for: .normal)
            button.setTitle(item, for: .normal)
        }
        let string = "本地音乐"
        let size = string.getStringSize(font: UIFont.systemFont(ofSize: 16), size: CGSize(width:Double(MAXFLOAT), height: 16.0))
        lineLayer.frame = CGRect(x: 0, y: frame.size.height-1, width: size.width, height: 2)
        lineLayer.backgroundColor = UIColor.colorWithHexString(hexString: "C83A3A").cgColor
        self.layer.addSublayer(lineLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
